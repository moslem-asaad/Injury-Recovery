
import 'package:injury_recovery/features/domain/entities/customer_user.dart';

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




}