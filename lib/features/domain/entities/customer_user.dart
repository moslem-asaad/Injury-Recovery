
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injury_recovery/features/domain/entities/user.dart';

class CustomerUser extends User{



  CustomerUser(String userId, String email, String firstName, String lastName, String phoneNumber):
   super(userId, email, firstName, lastName, phoneNumber, false) ;



  

}