import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackRequest{

  int? feedbackRequestId;
  int? treatmentGlobalId;
  int? exerciseVideoGlobalId;
  String? performanceVideoDownloadURL;
  String? feedbackRequestDescription;
  String? customerUserEmail;
  String? systemManagerResponse;


  int? getFeedbackRequestId(){
    return feedbackRequestId;
  }

  bool wasResponded(){
    return systemManagerResponse != null;
  }

  void setSystemManagerResponse (String response){
    systemManagerResponse = response;
  }

  FeedbackRequest(this.feedbackRequestId, this.treatmentGlobalId,
   this.exerciseVideoGlobalId, this.performanceVideoDownloadURL,
    this.feedbackRequestDescription, this.customerUserEmail, this.systemManagerResponse);


  factory FeedbackRequest.fromSnapshot(DocumentSnapshot documentSnapshot){
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return FeedbackRequest(snapshot["feedbackRequestId"], snapshot["treatmentGlobalId"],
     snapshot["exerciseVideoGlobalId"], snapshot["performanceVideoDownloadURL"],
     snapshot["feedbackRequestDescription"], snapshot["customerUserEmail"], snapshot["systemManagerResponse"]);
   }

   Map<String, dynamic> toJson() {
    return {
      "feedbackRequestId":feedbackRequestId,
      "treatmentGlobalId":treatmentGlobalId,
      "exerciseVideoGlobalId":exerciseVideoGlobalId,
      "performanceVideoDownloadURL": performanceVideoDownloadURL,
      "feedbackRequestDescription": feedbackRequestDescription,
      "customerUserEmail": customerUserEmail,
      "systemManagerResponse": systemManagerResponse
    };
   }
  
}