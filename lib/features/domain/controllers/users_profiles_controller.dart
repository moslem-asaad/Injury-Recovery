
import 'dart:async';

import 'package:injury_recovery/features/domain/entities/customer_user.dart';
import 'package:injury_recovery/features/domain/entities/exercise_video.dart';
import 'package:injury_recovery/features/presentation/views/treatments.dart';

import '../entities/treatment.dart';
import '../entities/user.dart';
import '../services/firebase_service.dart';

class UsersProfilesController{

  FirebaseService firebaseService;
  String? loggedInUserId;

  UsersProfilesController(this.firebaseService);


  Future<void> logIn(User user){
    return firebaseService.logIn(user);
  }

  Future<void> logOut(){
  return firebaseService.logOut();
  }

  Future<void> register(CustomerUser customerUser){
    return firebaseService.register(customerUser);
  }

  Future<bool> isLoggedIn(){
  return firebaseService.isLoggedIn();
  }

  Future<String> getCurrentUserId(){
  return firebaseService.getCurrentUserId();
  }

 List<Treatment> getUserTreatments(){
    List<Treatment> l = [Treatment(treatmentId: "1", treatmentDescription: "treatment1 desc", videosList: [ExerciseVideo(videoId: "1", videoUrl: "empty url", videoSummary: "", videoDescription: "video1 desc"), ExerciseVideo(videoId: "2", videoUrl: "empty url", videoSummary: "", videoDescription: "video2 desc")]),
                          Treatment(treatmentId: "2", treatmentDescription: "treatment2 desc", videosList: []),
                          Treatment(treatmentId: "3", treatmentDescription: "treatment3 desc", videosList: [])];
    return l;
  }




}