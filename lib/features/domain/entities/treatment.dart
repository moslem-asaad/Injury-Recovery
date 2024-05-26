import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injury_recovery/features/domain/entities/exercise_video.dart';

import '../../data/services/firebase_service_impl.dart';

class Treatment{


  int? treatmentGlobalId;
  String? treatmentDescription;
  List<ExerciseVideo>? videosList;
  List<int>? videosIdsList;

  String? customerUserEmail;


  List<int> getVideosIds(List<ExerciseVideo> videosList){
    return List.from(videosList.map((ExerciseVideo e){return e.getVideoGlobalId();}));
  }

  List<int> getvideosIdsList(){
    return videosIdsList!;
  }

  Treatment(this.treatmentGlobalId, this.treatmentDescription, 
  this.videosIdsList, this.customerUserEmail);

    factory Treatment.fromSnapshot(DocumentSnapshot documentSnapshot){
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return Treatment(snapshot["treatmentGlobalId"], snapshot["treatmentDescription"],
     List.from(snapshot["videosIdsList"]),
     snapshot["customerUserEmail"]);
   }

   Future<Treatment> setExerciseVideosList() async{
      videosList = await FirebaseServiceImpl().getExerciseVideoList(videosIdsList!);
      return this;
   }

   Map<String, dynamic> toJson() {
    return {
      "treatmentGlobalId":treatmentGlobalId,
      "treatmentDescription":treatmentDescription,
      "videosIdsList":videosIdsList,
      "customerUserEmail": customerUserEmail
    };
   }
  
}