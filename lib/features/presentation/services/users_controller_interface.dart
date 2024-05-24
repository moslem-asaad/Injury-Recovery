
import '../../domain/entities/customer_user.dart';
import '../../domain/entities/treatment.dart';
import '../../domain/entities/user.dart';

abstract class UsersController{

  Future<void> logIn(String email,String password);
  Future<void> logOut();
  Future<void> register(CustomerUser customerUser);
  Future<bool> isLoggedIn();
  Future<String> getCurrentUserId();
  List<Treatment> getUserTreatments();
  Future<void> SendFeedbackRequest(String treatmentId, String videoTreamentId, String? myVideiURL, String description);
}