import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/features/domain/entities/exercise_video.dart';
import 'package:injury_recovery/features/domain/entities/treatment.dart';
import 'package:injury_recovery/features/presentation/views/customer/treatment/treatment_view.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AuthService.firebase().initialize();
  Treatment treatment = Treatment("טיפול הכתף ",7,"כל תרגיל 4 פעמים",[1,2],"moslem.asaad2000@gmail.com");
  ExerciseVideo v1 = ExerciseVideo(1, 'https://firebasestorage.googleapis.com/v0/b/injury-recovery.appspot.com/o/videos%2F2024-05-29%2017%3A15%3A35.686336.mp4?alt=media&token=68d74580-f5c4-425c-86b0-1c769c8e3697'
    , 'ghh', 'sss', 'category1Name', 1);

  ExerciseVideo v2 = ExerciseVideo(2, 'https://firebasestorage.googleapis.com/v0/b/injury-recovery.appspot.com/o/videos%2F2024-05-31%2016%3A02%3A52.757255.mp4?alt=media&token=ec8fcb9d-a766-42eb-8c66-275f657f29bd'
    , 'ccv', 'sde', 'category1Name', 2);
    
  treatment.forTestSetExerciseVideosList(
    [v1,v2]
  );
  testWidgets('treatment view test success', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: TreatmentView(treatment: treatment,index: 0,)));

    final ctr = find.text('Treatment');
    expect(ctr, findsOneWidget);

  });
}
