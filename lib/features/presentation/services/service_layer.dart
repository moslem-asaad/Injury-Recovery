import 'package:injury_recovery/features/data/services/firebase_service_impl.dart';
import 'package:injury_recovery/features/domain/controllers/users_profiles_controller.dart';
import 'package:injury_recovery/features/domain/entities/treatment.dart';
import 'package:injury_recovery/features/domain/entities/user.dart';
import 'package:injury_recovery/features/presentation/services/response.dart';
import 'package:injury_recovery/features/presentation/services/users_controller_interface.dart';
import 'package:injury_recovery/services/auth/auth_exceptions.dart';

class Service {
  
  late UsersController usersController;
  Service(){
    usersController = UsersProfilesController(FirebaseServiceImpl());
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
      List<Treatment> treatments = usersController.getUserTreatments();
      return ResponseT.empty(treatments);
    }catch(e){
      return ResponseT(e.toString(), true);
    }
  }
}