import 'dart:async';
import '../../data/services/firebase_service_impl.dart';
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

    return firebaseService.createExerciseVideo(videoDownloadURL,
     videoSummary, videoDescription);
  }

  Future<String> uploadVideo(String videoURL, Function(double)? onProgress) async {
      UsersProfilesController().validatSystemManagerIsLoggedIn();
      UsersProfilesController().validateNotNullOrEmptyString("Video URL", videoURL);

      return firebaseService.uploadVideo(videoURL, onProgress);
  }


  
}