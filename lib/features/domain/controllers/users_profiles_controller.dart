import 'dart:async';
import 'package:injury_recovery/features/data/services/auth_exceptions.dart';
import 'package:injury_recovery/features/domain/entities/customer_user.dart';
import 'package:injury_recovery/features/domain/entities/system_manager.dart';
import '../../data/services/firebase_service_impl.dart';
import '../entities/feedback_request.dart';
import '../entities/treatment.dart';
import '../entities/user.dart';



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


  Future<bool> logIn(String email, String password) async{
      validateNotNullOrEmptyString("Email",email);
      validateNotNullOrEmptyString("Password",password);
      validatUserIsNotLoggedIn();
      User user = await firebaseService.logIn(email,password);
      if(user.isSystemManager){
          loggedInSystemManager =  SystemManager(user.userId!, user.email, user.firstName!, user.lastName!, user.phoneNumber!);
          isSystemManagerLoggedIn = true;
      }else{
          loggedInUser =  CustomerUser(user.userId!, user.email, user.firstName!, user.lastName!, user.phoneNumber!);
      }
      return true;
  }

  Future<User> getLoggedInUser() async{
    User user = await firebaseService.getLoggedInUser();
      if(user.isSystemManager){
        loggedInSystemManager =  SystemManager(user.userId!, user.email, user.firstName!, user.lastName!, user.phoneNumber!);
        isSystemManagerLoggedIn = true;
      }else{
        loggedInUser =  CustomerUser(user.userId!, user.email, user.firstName!, user.lastName!, user.phoneNumber!);
      }
    return user;
  }

  Future<bool> logOut() async {
      validatUserIsLoggedIn();
      bool logOutSucceeded = await firebaseService.logOut();
      if (logOutSucceeded) {
        loggedInUser = null;
        loggedInSystemManager = null;
        isSystemManagerLoggedIn = false;
      }
      return logOutSucceeded;
  }

  Future<bool> register(String email, String password, String confirmedPassword,
   String firstName, String lastName, String phoneNumber) async{
      validateNotNullOrEmptyString("Email",email);
      validateNotNullOrEmptyString("Password",password);
      validateNotNullOrEmptyString("Confirmed Password",confirmedPassword);
      validateNotNullOrEmptyString("First Name",firstName);
      validateNotNullOrEmptyString("Last Name",lastName);
      validateNotNullOrEmptyString("Phone Number",phoneNumber);
      if(password != confirmedPassword){
          throw ExpectedFailureException("Confirmed Password does not match");
      }

      if(!isValidNumberString(phoneNumber)){
          throw ExpectedFailureException("Phone Number isn't valid");
      }

      if(!containsOnlyLetters(firstName) || !containsOnlyLetters(lastName) ){
          throw ExpectedFailureException("First and Last Name should contain letters only");
      }

    return await firebaseService.register(email, password, firstName, lastName, phoneNumber);
  }

  Future<bool> createTreatment(String customerUserEmail, String treatmentDescription,
   List<int> exerciseVideosIds) async{
    validateNotNullOrEmptyString("Treatment Description",treatmentDescription);
    validateNotNullOrEmptyString("Customer User Email",customerUserEmail);
    if(exerciseVideosIds.isEmpty){
      throw ExpectedFailureException("you can't create Treatment without any Exercise Video");
    }
    validatSystemManagerIsLoggedIn();
    return await firebaseService.createTreatment(customerUserEmail,
     treatmentDescription, exerciseVideosIds);
  }

  Future<List<Treatment>> getUserTreatments() async{

    validatCustomerUserIsLoggedIn();
    return await firebaseService.getUserTreatments(loggedInUser!.getEmail());
  }

  Future<bool> sendFeedbackRequest(int treatmentId, int videoTreamentId,
   String? myVideoURL, String description) async{

    validateNotNullOrEmptyString("Feedback Request Description",description);
    validatCustomerUserIsLoggedIn();
    return await firebaseService.createFeedbackRequest(loggedInUser!.getEmail(), treatmentId,
     videoTreamentId, myVideoURL, description);
  }






  Future<List<FeedbackRequest>> getTreatmentFeedbackRequests(int treatmentId) async {
    validatCustomerUserIsLoggedIn();
    return await firebaseService.getTreatmentFeedbackRequests(loggedInUser!.getEmail(), treatmentId);
  }

  Future<List<FeedbackRequest>> getMyFeedbackRequests() async {
    validatCustomerUserIsLoggedIn();
    return await firebaseService.getUserFeedbackRequests(loggedInUser!.getEmail());
  }

  Future<List<FeedbackRequest>> getAllUsersFeedbackRequests() async {
    validatSystemManagerIsLoggedIn();
    return await firebaseService.getAllUsersFeedbackRequests();
  }

  Future<List<User>> getAllUsers() async {
    validatSystemManagerIsLoggedIn();
    return await firebaseService.getAllUsers();
  }

  Future<bool> sendFeedbackResponse(
      int feedbackId, String response) async {

    validateNotNullOrEmptyString("Feedback Respnose",response);
    validatSystemManagerIsLoggedIn();
    return await firebaseService.sendFeedbackResponse(feedbackId, response);
  }

  Future<bool> cleanCollection(String collectionName) async {
    return await firebaseService.cleanCollection(collectionName);
  }
  void setIsTestExecution(bool flag){
    firebaseService.setIsTestExecution(flag);
  }
  

  String getUserFirstName(){
    validatUserIsLoggedIn();
    if(loggedInUser != null){
      return loggedInUser!.getFirstName();
    }
    return loggedInSystemManager!.getFirstName();
  }

  String getUserLastName(){
    validatUserIsLoggedIn();
    if(loggedInUser != null){
      return loggedInUser!.getLastName();
    }
    return loggedInSystemManager!.getLastName();

  }


// bool getters and validations
  void validateNotNullOrEmptyString(String argumentName, String input){
    
    // ignore: unnecessary_null_comparison
    if(input == null){
      throw ExpectedFailureException("$argumentName can't be null");
    }

    if(input == ""){
      throw ExpectedFailureException("$argumentName can't be empty");
    }
  }

  bool customerUserIsLoggedIn(){
    if(loggedInUser != null){
        return true;
    }
    return false;
  }

  bool systemManagerIsLoggedIn(){
    if(loggedInSystemManager != null && isSystemManagerLoggedIn == true){
        return true;
    }
    return false;
  }

  bool userIsLoggedIn(){
    if(customerUserIsLoggedIn() || systemManagerIsLoggedIn()){
        return true;
    }
    return false;
  }
  void validatUserIsNotLoggedIn(){
    if(userIsLoggedIn()){
      throw ExpectedFailureException("you have already Logged In");
    }
  }

  void validatUserIsLoggedIn(){
    if(!userIsLoggedIn()){
      throw ExpectedFailureException("you are not Logged In");
    }
  }

  void validatSystemManagerIsLoggedIn(){
    validatUserIsLoggedIn();
    if(!systemManagerIsLoggedIn()){
      throw ExpectedFailureException("you are not Logged In as System Manager");
    }
  }

  void validatCustomerUserIsLoggedIn(){
    validatUserIsLoggedIn();
    if(!customerUserIsLoggedIn()){
      throw ExpectedFailureException("you are not Logged In as Customer User");
    }
  }

bool isValidNumberString(String input) {
  final RegExp regex = RegExp(r'^\+?\d+(-\d+)*$');
  return regex.hasMatch(input);
}

bool containsOnlyLetters(String input) {
  // english, arabic, hebrew letters allowed
  final RegExp regex = RegExp(r'^[a-zA-Z\u0590-\u05FF\u0600-\u06FF]+$');
  return regex.hasMatch(input);
}


  /*List<Treatment> getUserTreatments1() {
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
          1),
          ExerciseVideo(
          2,
          "https://firebasestorage.googleapis.com/v0/b/injury-recovery.appspot.com/o/videos%2F2024-03-04%2011%3A14%3A12.550336.mp4?alt=media&token=9b31310a-7a1a-42fc-b379-b44aa1b59343",
          'videoSummary',
          'videoDescription',
          '',
          2),
          ExerciseVideo(
          3,
          "https://firebasestorage.googleapis.com/v0/b/injury-recovery.appspot.com/o/videos%2F2024-03-04%2011%3A13%3A13.819039.mp4?alt=media&token=cefbbee2-90b7-4554-a86f-488516408b18",
          'videoSummary',
          'videoDescription saiodjsaiodjsioadjiosajdoiasjdioaxmcosancuenovnasklcnsaklcmioqemvdmsnvdsicoewmklcsa oiwemfkc ioasl;,edkc ioasndoisnadionqeioc ',
          '',
          3),
          ExerciseVideo(
          4,
          "https://firebasestorage.googleapis.com/v0/b/injury-recovery.appspot.com/o/videos%2F2024-03-14%2014%3A53%3A01.139339.mp4?alt=media&token=ca004a0c-994f-45ac-99b7-ea0ded12f8ff",
          'videoSummary',
          'videoDescription',
          '',
          4),
    ];
    l.add(t);
   
    return l;
  }*/

  Future<void> SendFeedbackRequest(int treatmentId, int videoTreamentId,
      String? myVideiURL, String description) {
    throw Exception('${treatmentId} $videoTreamentId $description $myVideiURL');
  }
}
