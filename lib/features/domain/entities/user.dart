import 'package:cloud_firestore/cloud_firestore.dart';

class User{

  String? userId;
  String email;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  bool isSystemManager;

  String getEmail(){
    return email;
  }
  String getFirstName(){
    return firstName!;
  }
  String getLastName(){
    return lastName!;
  }

  User(this.userId, this.email, this.firstName, this.lastName, this.phoneNumber, this.isSystemManager);


  factory User.fromSnapshot(String userId, DocumentSnapshot documentSnapshot){
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return User(userId, snapshot["email"], snapshot["firstName"],
     snapshot["lastName"], snapshot["phoneNumber"], snapshot["isSystemManager"]);
   }

   factory User.fromSnapshotWithoutId(DocumentSnapshot documentSnapshot){
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return User(snapshot["userId"], snapshot["email"], snapshot["firstName"],
     snapshot["lastName"], snapshot["phoneNumber"], snapshot["isSystemManager"]);
   }

   Map<String, dynamic> toJson() {
    return {
      "email":email,
      "firstName":firstName,
      "lastName":lastName,
      "phoneNumber":phoneNumber,
      "isSystemManager":isSystemManager
    };
   }

  
}