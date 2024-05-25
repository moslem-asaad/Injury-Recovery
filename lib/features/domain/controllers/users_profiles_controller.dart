import 'dart:async';

import 'package:injury_recovery/features/domain/entities/customer_user.dart';
import 'package:injury_recovery/features/domain/entities/exercise_video.dart';
import 'package:injury_recovery/features/domain/entities/system_manager.dart';

import '../../data/services/firebase_service_impl.dart';
import '../entities/treatment.dart';
import '../entities/user.dart';
import 'excercise_videos_controller.dart';

class UsersProfilesController {
  static final UsersProfilesController _instance =
      UsersProfilesController.internalConstructor();
  FirebaseServiceImpl firebaseService = FirebaseServiceImpl();
  bool? isSystemManagerLoggedIn = false;
  CustomerUser? loggedInUser;
  SystemManager? loggedInSystemManager;

  UsersProfilesController.internalConstructor();

  factory UsersProfilesController() {
    return _instance;
  }

  Future<bool> logIn(String email, String password) async {
    try {
      User user = await firebaseService.logIn(email, password);
      if (user.isSystemManager) {
        loggedInSystemManager = SystemManager(user.userId!, user.email,
            user.firstName!, user.lastName!, user.phoneNumber!);
        ExerciseVideosController().setSystemManager(loggedInSystemManager);
        isSystemManagerLoggedIn = true;
      } else {
        loggedInUser = CustomerUser(user.userId!, user.email, user.firstName!,
            user.lastName!, user.phoneNumber!);
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> logOut() async {
    try {
      bool logOutSucceeded = await firebaseService.logOut();
      if (logOutSucceeded) {
        loggedInUser = null;
        loggedInSystemManager = null;
        ExerciseVideosController().setSystemManager(loggedInSystemManager);
        isSystemManagerLoggedIn = false;
      }
      return logOutSucceeded;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> register(String email, String password, String firstName,
      String lastName, String phoneNumber) {
    return firebaseService.register(
        email, password, firstName, lastName, phoneNumber);
  }

  Future<bool> createTreatment(String customerUserEmail,
      String treatmentDescription, List<int> exerciseVideosIds) async {
    return firebaseService.createTreatment(
        customerUserEmail, treatmentDescription, exerciseVideosIds);
  }

  Future<List<Treatment>> getUserTreatments(String customerUserEmail) async {
    return firebaseService.getUserTreatments(customerUserEmail);
  }

  List<Treatment> getUserTreatments1() {
    List<Treatment> l = [];

    Treatment t = Treatment(
        1, 'treatmentDescription', [1, 2, 3], 'moslem.asaad2000@gmail.com');
    t.videosList = [
      ExerciseVideo(
          1,
          "https://firebasestorage.googleapis.com/v0/b/injury-recovery.appspot.com/o/videos%2FScreen_Recording_20200822-001856_PUBG_MOBILE%5B1%5D.mp4?alt=media&token=84cfdd70-b2b9-4bb1-b934-8ba771c48b01",
          'videoSummary',
          'videoDescription',
          '',
          2),
    ];
    l.add(t);
    /*
     [
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
    */
    return l;
  }

  Future<void> SendFeedbackRequest(int treatmentId, int videoTreamentId,
      String? myVideiURL, String description) {
    throw Exception('${treatmentId} $videoTreamentId $description $myVideiURL');
  }
}
