import 'package:injury_recovery/features/domain/entities/exercise_video.dart';

class Treatment{

  String treatmentId;
  String treatmentDescription;
  List<ExerciseVideo> videosList;


  Treatment({required this.treatmentId, required this.treatmentDescription, required this.videosList});
  
}