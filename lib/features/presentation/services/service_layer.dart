import 'package:injury_recovery/features/domain/controllers/users_profiles_controller.dart';
import 'package:injury_recovery/features/domain/entities/feedback_request.dart';
import 'package:injury_recovery/features/domain/entities/treatment.dart';
import 'package:injury_recovery/features/presentation/services/response.dart';

class Service {
  late UsersProfilesController usersController;
  Service() {
    usersController = UsersProfilesController();
  }

  Future<ResponseT<bool>> logIn(String email, String password) async {
    try {
      await usersController.logIn(email, password);
      return ResponseT.empty(true);
    } catch (e) {
      return ResponseT(e.toString(), true);
    }
  }

  Future<ResponseT<bool>> logout() async {
    try {
      await usersController.logOut();
      return ResponseT.empty(true);
    } catch (e) {
      return ResponseT(e.toString(), true);
    }
  }

  Future<ResponseT<bool>> register(
      String email,
      String password,
      String confirmedPassword,
      String firstName,
      String lastName,
      String phoneNumber) async {
    try {
      await usersController.register(
          email, password, firstName, lastName, phoneNumber);
      return ResponseT.empty(true);
    } catch (e) {
      return ResponseT(e.toString(), true);
    }
  }

  Future<ResponseT<List<Treatment>>> getUserTreatments() async {
    try {
      //List<Treatment> treatments = await usersController.getUserTreatments('moslem.asaad2000@gmail.com');
      List<Treatment> treatments = usersController.getUserTreatments1();
      print('getUserTreatments 40 ${treatments[0].treatmentDescription}');
      return ResponseT.empty(treatments);
    } catch (e) {
      return ResponseT(e.toString(), true);
    }
  }

  Future<ResponseT<bool>> sendFeedbackRequest(int treatmentId,
      int videoTreamentId, String? myVideiURL, String description) async {
    try {
      await usersController.SendFeedbackRequest(
          treatmentId, videoTreamentId, myVideiURL, description);
      return ResponseT.empty(true);
    } catch (e) {
      return ResponseT(e.toString(), true);
    }
  }

  Future<ResponseT<bool>> createTreatment(String customerUserEmail,
      String treatmentDescription, List<int> exerciseVideosIds) async {
    throw Exception();
  }

  Future<ResponseT<List<FeedbackRequest>>> getTreatmentFeedbackRequests(
      int treatmentId) async {
    FeedbackRequest feedbackRequest = FeedbackRequest(
        1,
        1,
        1,
        'https://firebasestorage.googleapis.com/v0/b/injury-recovery.appspot.com/o/videos%2F2024-03-14%2014%3A47%3A53.057595.mp4?alt=media&token=2853134c-c7be-4f5a-9e42-2675fc88c73e',
        'i am in so much paaaaaaaaaain',
        'moslem.asaad2000@gmail.com'
        );
      return ResponseT.empty([feedbackRequest,feedbackRequest]);
    //throw Exception();
  }

  Future<ResponseT<List<FeedbackRequest>>> getMyFeedbackRequests() async {
    throw Exception();
  }

  Future<ResponseT<List<FeedbackRequest>>> getAllUsersFeedbackRequests() async {
    throw Exception();
  }

  Future<ResponseT<bool>> sendFeedbackResponse(
      int feedbackId, String response) async {
    throw Exception();
  }

  Future<ResponseT<String>> getUserFirstName() async {
    try {
      return ResponseT.empty('Moslem');
    } catch (e) {
      return ResponseT(e.toString(), true);
    }
  }

  Future<ResponseT<String>> getUserLastName() async {
    return ResponseT.empty('Asaad');
  }

  /** 
   * ahmad - implement these functions above
   *         convert exceptions with message
   * haitam - testing the functions 
   *          each function 3 success senarions and 2 fail senarions MINIMUM!!!!
   * moslem - add the images to treatments
   *          edit the register [age with name and phone number.. ] and conncet to the domain service
   *          see feedbacks to a treatment view 
   *          change all colors 
   *          change the texts to hebrew
   *          check system manager pages(and connect with the domain service)
   *          there is no current treatment - edit the treatments view and 
   *          customer profile view - (see my feedback requests, username, ..)
   *          -----------------------------------------
   *          if every thing done, treatment steps in domain and presentaion
   */
}
