import 'package:injury_recovery/features/domain/controllers/users_profiles_controller.dart';
import 'package:injury_recovery/features/domain/entities/treatment.dart';
import 'package:injury_recovery/features/presentation/services/response.dart';

class Service {
  
  late UsersProfilesController usersController;
  Service(){
    usersController = UsersProfilesController();
  }

  Future<Response> logIn(String email,String password) async{
    try{
      await usersController.logIn(email,password);
      return Response.empty();
    }catch(e){
      return Response(e.toString(), true);
    }
  }

  ResponseT<List<Treatment>> getUserTreatments(){
    try{
      List<Treatment> treatments = usersController.getUserTreatments1();
      return ResponseT.empty(treatments);
    }catch(e){
      return ResponseT(e.toString(), true);
    }
  }

   Future<Response> sendFeedbackRequest(int treatmentId, int videoTreamentId, String? myVideiURL, String description) async{
    try{
      await usersController.SendFeedbackRequest(
        treatmentId,
        videoTreamentId,
        myVideiURL,
        description
      );
      return Response.empty();
    }catch(e){
      return Response(e.toString(), true);
    }
  }
}