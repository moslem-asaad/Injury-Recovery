
import 'package:injury_recovery/features/domain/entities/user.dart';

import '../entities/customer_user.dart';

abstract class FirebaseService{

  Future<void> logIn(User user) ;
  Future<void> logOut();
  Future<void> createUser(CustomerUser customerUser);
  Future<void> register(CustomerUser customerUser);
  Future<bool> isLoggedIn();
  Future<String> getCurrentUserId();

}