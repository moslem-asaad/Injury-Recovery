import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseVideo{

  int? videoGlobalId;
  String? videoUrl;
  String? videoSummary;
  String? videoDescription;

  String? categoryName;
  int? videoSecId;

  int? getVideoGlobalId(){
    return videoGlobalId;
  }

  ExerciseVideo(this.videoGlobalId, this.videoUrl, this.videoSummary, 
  this.videoDescription, this.categoryName, this.videoSecId);


  factory ExerciseVideo.fromSnapshot(DocumentSnapshot documentSnapshot){
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return ExerciseVideo(snapshot["videoGlobalId"], snapshot["videoUrl"],
     snapshot["videoSummary"], snapshot["videoDescription"],
     snapshot["categoryName"], snapshot["videoSecId"]);
   }

   Map<String, dynamic> toJson() {
    return {
      "videoGlobalId":videoGlobalId,
      "videoUrl":videoUrl,
      "videoSummary":videoSummary,
      "videoDescription": videoDescription,
      "categoryName": categoryName,
      "videoSecId": videoSecId
    };
   }
  
}