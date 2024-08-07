import 'dart:async';
import '../../data/services/firebase_service_impl.dart';
import '../entities/exercise_video.dart';
import 'users_profiles_controller.dart';

class ExerciseVideosController {
  static final ExerciseVideosController _instance =
      ExerciseVideosController.internalConstructor();
  FirebaseServiceImpl firebaseService = FirebaseServiceImpl();

  ExerciseVideosController.internalConstructor();

  factory ExerciseVideosController() {
    return _instance;
  }

  Future<bool> createExerciseVideo(String videoDownloadURL, String videoSummary,
      String videoDescription) async {
    UsersProfilesController().validatSystemManagerIsLoggedIn();
    UsersProfilesController()
        .validateNotNullOrEmptyString("סיכום וידאו", videoSummary);
    UsersProfilesController()
        .validateNotNullOrEmptyString("תיאור וידאו", videoDescription);

    return await firebaseService.createExerciseVideo(
        videoDownloadURL, videoSummary, videoDescription);
  }

  Future<String> uploadVideo(
      String videoURL, String path, Function(double)? onProgress) async {
    //UsersProfilesController().validatSystemManagerIsLoggedIn();
    UsersProfilesController()
        .validateNotNullOrEmptyString("קישור לוידאו", videoURL);

    return await firebaseService.uploadVideo(videoURL, path, onProgress);
  }

  Future<List<ExerciseVideo>> getAllExerciseVideos() async {
    UsersProfilesController().validatSystemManagerIsLoggedIn();
    return await firebaseService.getAllExerciseVideos();
  }

  Future<ExerciseVideo> getExerciseVideoById(int videoId) async{
    UsersProfilesController().validatUserIsLoggedIn();
    return await firebaseService.getExerciseVideoById(videoId);
  }
}
