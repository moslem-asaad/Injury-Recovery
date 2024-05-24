import 'package:injury_recovery/features/domain/entities/user.dart';

class SystemManager extends User{




  SystemManager(String userId, String email, String firstName, String lastName, String phoneNumber):
   super(userId, email, firstName, lastName, phoneNumber, true) ;


  

}