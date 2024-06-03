// ignore_for_file: avoid_print

import 'package:injury_recovery/features/data/services/auth_exceptions.dart';
import 'package:injury_recovery/features/domain/controllers/excercise_videos_controller.dart';
import 'package:injury_recovery/features/domain/controllers/users_profiles_controller.dart';
import 'package:injury_recovery/features/domain/entities/feedback_request.dart';
import 'package:injury_recovery/features/domain/entities/treatment.dart';
import 'package:injury_recovery/features/presentation/services/response.dart';

import '../../domain/entities/exercise_video.dart';
import '../../domain/entities/user.dart';

class Service {

  // ignore: non_constant_identifier_names
  final String SOME_THING_WENT_WRONG = "Some Thing Went Wrong";
  UsersProfilesController usersController = UsersProfilesController();
  ExerciseVideosController exerciseVideosController = ExerciseVideosController();
  static final Service _instance = Service.internalConstructor();
  Service.internalConstructor();
  factory Service(){
    return _instance;
  }

  Future<ResponseT<T>> tryCatch<T>(Future<T> Function () body) async{
    try{
        T ret = await body();
        return ResponseT.empty(ret);
    } on ExpectedFailureException catch (e){
        // this is the case where e.toString() is an expected message
        // so we can show its message to user
        print(e.toString());
        return ResponseT(e.toString(), true);
    } on InternalFailureException catch (e){
      // this is the case where e.toString() is an INTERNAL expected message
      // so we CAN'T show its message to user
      String internalException = e.toString();
      print("InternalFailureException: $internalException");
      return ResponseT(SOME_THING_WENT_WRONG, true);
      
    } catch (e){
      // this is the case where e is not expected
      String unExpectedException = e.toString();
      print("unExpectedException: $unExpectedException");
      return ResponseT(SOME_THING_WENT_WRONG, true);
    }

  }
  
  Future<ResponseT<bool>> logIn(String email, String password) async {
    return await tryCatch<bool>(() async {
        return await usersController.logIn(email, password);
    });
  }

  Future<ResponseT<User>> getLoggedInUser() async {
    return await tryCatch<User>(() async {
        return await usersController.getLoggedInUser();
    });
  }



  Future<ResponseT<bool>> cleanCollection(String collectionName) async {
    return await tryCatch<bool>(() async {
        return await usersController.cleanCollection(collectionName);
    });
  }

  Future<ResponseT<bool>> logout() async {
    return await tryCatch<bool>(() async {
        return await usersController.logOut();
    });
  }

  Future<ResponseT<bool>> register(String email, String password,
  String confirmedPassword, String firstName, String lastName, String phoneNumber) async {
    return await tryCatch<bool>(() async {
        return await usersController.register(email, password, confirmedPassword,
         firstName, lastName, phoneNumber);
    });
  }

  Future<ResponseT<List<User>>> getAllUsers() async {
    return await tryCatch<List<User>>(() async {
        return await usersController.getAllUsers();
    });
  }
  
  Future<ResponseT<bool>> createTreatment(String customerUserEmail, String treatmentName,
      String treatmentDescription, List<int> exerciseVideosIds) async {
    return await tryCatch<bool>(() async {
        return await usersController.createTreatment(customerUserEmail,treatmentName, treatmentDescription, exerciseVideosIds);
    });
  }

  Future<ResponseT<List<Treatment>>> getUserTreatments() async {
    return await tryCatch<List<Treatment>>(() async {
        return await usersController.getUserTreatments();
    });
  }

  Future<ResponseT<bool>> sendFeedbackRequest(int treatmentId,
      int videoTreamentId, String? myVideoURL, String description) async {
    return await tryCatch<bool>(() async {
        return await usersController.sendFeedbackRequest(treatmentId, videoTreamentId,
         myVideoURL, description);
    });
  }

  Future<ResponseT<List<FeedbackRequest>>> getTreatmentFeedbackRequests(
      int treatmentId) async {
    return await tryCatch<List<FeedbackRequest>>(() async {
        return await usersController.getTreatmentFeedbackRequests(treatmentId);
    });
  }

  Future<ResponseT<List<FeedbackRequest>>> getMyFeedbackRequests() async {
    return await tryCatch<List<FeedbackRequest>>(() async {
        return await usersController.getMyFeedbackRequests();
    });
  }

  Future<ResponseT<List<FeedbackRequest>>> getAllUsersFeedbackRequests() async {
    return await tryCatch<List<FeedbackRequest>>(() async {
        return await usersController.getAllUsersFeedbackRequests();
    });
  }

  Future<ResponseT<bool>> sendFeedbackResponse(
      int feedbackId, String response) async {
    return await tryCatch<bool>(() async {
        return await usersController.sendFeedbackResponse(feedbackId, response);
    });
  }

  Future<ResponseT<String>> getUserFirstName() async {
    return await tryCatch<String>(() async {
        return usersController.getUserFirstName();
    });
    
  }

  Future<ResponseT<String>> getUserLastName() async {
    return await tryCatch<String>(() async {
        return usersController.getUserLastName();
    });
  }

  Future<ResponseT<bool>> createExerciseVideo(String videoDownloadURL, String videoSummary,
   String videoDescription) async {
    return await tryCatch<bool>(() async {
        return await exerciseVideosController.createExerciseVideo(videoDownloadURL,
         videoSummary, videoDescription);
    });
  }

  Future<ResponseT<String>> uploadVideo(String videoURL, String path ,Function(double)? onProgress) async {
    return await tryCatch<String>(() async {
        return await exerciseVideosController.uploadVideo(videoURL,path ,onProgress);
    });
  }

  Future<ResponseT<List<ExerciseVideo>>> getAllExerciseVideos() async {
    return await tryCatch<List<ExerciseVideo>>(() async {
        return await exerciseVideosController.getAllExerciseVideos();
    });
  }
  

  void setIsTestExecution(bool flag){
    usersController.setIsTestExecution(flag);
  }

  }
  


  /*
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

