
import '../../domain/entities/customer_user.dart';
import '../../domain/entities/treatment.dart';
import '../../domain/entities/user.dart';

abstract class UsersController{

  Future<void> logIn(User user);
  Future<void> logOut();
  Future<void> register(CustomerUser customerUser);
  Future<bool> isLoggedIn();
  Future<String> getCurrentUserId();
  List<Treatment> getUserTreatments();

}