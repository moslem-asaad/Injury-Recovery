
import 'dart:async';

import 'package:injury_recovery/features/domain/entities/customer_user.dart';
import 'package:injury_recovery/features/domain/entities/exercise_video.dart';
import 'package:injury_recovery/features/domain/entities/system_manager.dart';
import 'package:injury_recovery/features/presentation/views/treatments.dart';

import '../../data/services/firebase_service_impl.dart';
import '../entities/treatment.dart';
import '../entities/user.dart';
import 'excercise_videos_controller.dart';

class UsersProfilesController{

  static final UsersProfilesController _instance = UsersProfilesController.internalConstructor();
  FirebaseServiceImpl firebaseService = FirebaseServiceImpl();
  bool? isSystemManagerLoggedIn = false;
  CustomerUser? loggedInUser;
  SystemManager? loggedInSystemManager;



  UsersProfilesController.internalConstructor();

  factory UsersProfilesController(){
    return _instance;
  }


  Future<bool> logIn(String email, String password) async{
    try{
      User user = await firebaseService.logIn(email,password);
      if(user.isSystemManager){
          loggedInSystemManager =  SystemManager(user.userId!, user.email, user.firstName!, user.lastName!, user.phoneNumber!);
          ExerciseVideosController().setSystemManager(loggedInSystemManager);
          isSystemManagerLoggedIn = true;
      }else{
          loggedInUser =  CustomerUser(user.userId!, user.email, user.firstName!, user.lastName!, user.phoneNumber!);
      }
      return true;
    } catch (e){
        rethrow;
    }
  }

  Future<bool> logOut() async {
    try{
      bool logOutSucceeded = await firebaseService.logOut();
      if(logOutSucceeded){
        loggedInUser = null;
        loggedInSystemManager = null;
        ExerciseVideosController().setSystemManager(loggedInSystemManager);
        isSystemManagerLoggedIn = false;
      }
      return logOutSucceeded;
    } catch (e){
        rethrow;
    }
  }

  Future<bool> register(String email, String password, String firstName, String lastName, String phoneNumber){
    return firebaseService.register(email, password, firstName, lastName, phoneNumber);
  }


  Future<bool> createTreatment(String customerUserEmail, String treatmentDescription, List<int> exerciseVideosIds) async{
    return firebaseService.createTreatment(customerUserEmail,
     treatmentDescription, exerciseVideosIds);
  }


  Future<List<Treatment>> getUserTreatments(String customerUserEmail) async{
    return firebaseService.getUserTreatments(customerUserEmail);
  }







}