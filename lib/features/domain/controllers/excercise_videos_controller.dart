import 'dart:async';

import 'package:injury_recovery/features/domain/entities/customer_user.dart';
import 'package:injury_recovery/features/domain/entities/exercise_video.dart';
import 'package:injury_recovery/features/domain/entities/system_manager.dart';
import 'package:injury_recovery/features/presentation/views/treatments.dart';

import '../../data/services/firebase_service_impl.dart';
import '../entities/treatment.dart';
import '../entities/user.dart';

class ExerciseVideosController{

  static final ExerciseVideosController _instance = ExerciseVideosController.internalConstructor();
  FirebaseServiceImpl firebaseService = FirebaseServiceImpl();
  SystemManager? loggedInSystemManager;



  ExerciseVideosController.internalConstructor();

  factory ExerciseVideosController(){
    return _instance;
  }

  void setSystemManager(SystemManager? systemManager){
    loggedInSystemManager = systemManager;
  }


  Future<bool> createExerciseVideo(String videoDownloadURL, String videoSummary,
   String videoDescription) async {

    return firebaseService.createExerciseVideo(videoDownloadURL,
     videoSummary, videoDescription);
  }
  
}