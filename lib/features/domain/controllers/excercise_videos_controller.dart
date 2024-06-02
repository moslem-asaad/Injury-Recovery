import 'dart:async';
import '../../data/services/firebase_service_impl.dart';
import '../entities/exercise_video.dart';
import 'users_profiles_controller.dart';

class ExerciseVideosController{

  static final ExerciseVideosController _instance = ExerciseVideosController.internalConstructor();
  FirebaseServiceImpl firebaseService = FirebaseServiceImpl();

  ExerciseVideosController.internalConstructor();

  factory ExerciseVideosController(){
    return _instance;
  }

  Future<bool> createExerciseVideo(String videoDownloadURL, String videoSummary,
   String videoDescription) async {
    UsersProfilesController().validatSystemManagerIsLoggedIn();
    UsersProfilesController().validateNotNullOrEmptyString("Video Summary", videoSummary);
    UsersProfilesController().validateNotNullOrEmptyString("Video Description", videoDescription);

    return await firebaseService.createExerciseVideo(videoDownloadURL,
     videoSummary, videoDescription);
  }

  Future<String> uploadVideo(String videoURL, String path,Function(double)? onProgress) async {
      //UsersProfilesController().validatSystemManagerIsLoggedIn();
      UsersProfilesController().validateNotNullOrEmptyString("Video URL", videoURL);

      return await firebaseService.uploadVideo(videoURL, path,onProgress);
  }

  Future<List<ExerciseVideo>> getAllExerciseVideos() async{
  //validatSystemManagerIsLoggedIn();
    return await firebaseService.getAllExerciseVideos();
  }


  
}