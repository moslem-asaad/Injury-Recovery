

import 'package:cloud_firestore/cloud_firestore.dart';

class Category{

  int? categoryId;
  String? categoryName;
  String? categoryDescription;
  List<String>? videosIDs;


  Category(this.categoryId,  this.categoryName,
    this.categoryDescription,  this.videosIDs);


   factory Category.fromSnapshot(DocumentSnapshot documentSnapshot){
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return Category(snapshot["categoryId"], snapshot["categoryName"],
     snapshot["categoryDescription"], List.from(snapshot["videosIDs"]));
   }

   Map<String, dynamic> toJson() {
    return {
      "categoryId":categoryId,
      "categoryName":categoryName,
      "categoryDescription":categoryDescription,
      "videosIDs": videosIDs
    };
   }
  
}