
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injury_recovery/features/domain/entities/user.dart';

class CustomerUser extends User{

  String? firstName;
  String? lastName;
  String? phoneNumber;

  CustomerUser(String super.userId, String super.email, String super.password,
   this.firstName, this.lastName, this.phoneNumber);


   factory CustomerUser.fromSnapshot(String userId, DocumentSnapshot documentSnapshot){
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return CustomerUser(userId, snapshot["email"], snapshot["password"],
     snapshot["firstName"], snapshot["lastName"], snapshot["phoneNumber"]);
   }

   Map<String, dynamic> toJson() {
    return {
      "userId":userId,
      "email":email,
      "password":password,
      "firstName":firstName,
      "lastName":lastName,
      "phoneNumber":phoneNumber
    };
   }
  

}