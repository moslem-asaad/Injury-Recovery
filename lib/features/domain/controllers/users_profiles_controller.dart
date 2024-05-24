import 'dart:async';

import 'package:injury_recovery/features/domain/entities/customer_user.dart';
import 'package:injury_recovery/features/domain/entities/exercise_video.dart';
import 'package:injury_recovery/features/presentation/services/users_controller_interface.dart';
import 'package:injury_recovery/features/presentation/views/customer/treatments.dart';

import '../entities/treatment.dart';
import '../entities/user.dart';
import '../services/firebase_service.dart';

class UsersProfilesController implements UsersController {
  FirebaseService firebaseService;
  String? loggedInUserId;

  UsersProfilesController(this.firebaseService);

  Future<void> logIn(String email, String password) {
    return firebaseService.logIn(email, password);
  }

  Future<void> logOut() {
    return firebaseService.logOut();
  }

  Future<void> register(CustomerUser customerUser) {
    return firebaseService.register(customerUser);
  }

  Future<bool> isLoggedIn() {
    return firebaseService.isLoggedIn();
  }

  Future<String> getCurrentUserId() {
    return firebaseService.getCurrentUserId();
  }

  List<Treatment> getUserTreatments() {
    List<Treatment> l = [
      Treatment(
          treatmentId: "1",
          treatmentDescription: "treatment1 desc",
          videosList: [
            ExerciseVideo(
                videoId: "1",
                videoUrl:
                    "https://firebasestorage.googleapis.com/v0/b/injury-recovery.appspot.com/o/videos%2FScreen_Recording_20200822-001856_PUBG_MOBILE%5B1%5D.mp4?alt=media&token=84cfdd70-b2b9-4bb1-b934-8ba771c48b01",
                videoSummary: "",
                videoDescription: "video1 desc"),
            ExerciseVideo(
                videoId: "2",
                videoUrl: "https://firebasestorage.googleapis.com/v0/b/injury-recovery.appspot.com/o/videos%2F2024-03-14%2015%3A00%3A03.840932.mp4?alt=media&token=1a3d9673-eda3-47c9-8f60-d0c648ff4e5e",
                videoSummary: "",
                videoDescription: "video2 desc"),
            ExerciseVideo(
                videoId: "3",
                videoUrl: "https://firebasestorage.googleapis.com/v0/b/injury-recovery.appspot.com/o/videos%2F2024-03-04%2011%3A13%3A13.819039.mp4?alt=media&token=cefbbee2-90b7-4554-a86f-488516408b18",
                videoSummary: "",
                videoDescription: "video3 desc"),
            ExerciseVideo(
                videoId: "4",
                videoUrl: "https://firebasestorage.googleapis.com/v0/b/injury-recovery.appspot.com/o/videos%2F2024-03-04%2011%3A14%3A12.550336.mp4?alt=media&token=9b31310a-7a1a-42fc-b379-b44aa1b59343",
                videoSummary: "",
                videoDescription: "video4 desc")
          ]),
      Treatment(
          treatmentId: "2",
          treatmentDescription: "treatment2 desc",
          videosList: []),
      Treatment(
          treatmentId: "3",
          treatmentDescription: "treatment3 desc",
          videosList: [])
    ];
    return l;
  }

  Future<void> SendFeedbackRequest(String treatmentId, String videoTreamentId, String? myVideiURL, String description){
    throw Exception('${treatmentId} $videoTreamentId $description $myVideiURL');
  }
}
