import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/features/domain/controllers/excercise_videos_controller.dart';
import 'package:injury_recovery/features/domain/controllers/users_profiles_controller.dart';
import 'package:injury_recovery/features/domain/entities/treatment.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';
// ignore_for_file: avoid_print


late UsersProfilesController usersProfilesController;
late ExerciseVideosController exerciseVideosController;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.firebase().initialize();

  group('Acceptance Tests', ()  {

    setUp(() {
      usersProfilesController = UsersProfilesController();
      exerciseVideosController = ExerciseVideosController();
    });


    test('UsersProfilesController.getUserTreatments returns correct treatments', () async {

      List<Treatment> treatments = await usersProfilesController.getUserTreatments('ahmad1999@gmail.com');

      expect(treatments, isNotEmpty); 
      expect(treatments.length, 2);

    });


    test('UsersProfilesController.getUserTreatments returns correct treatments for another user', () async {
      List<Treatment> treatments2 = await usersProfilesController.getUserTreatments('haitham2001@gmail.com');
      expect(treatments2, isNotEmpty);
      expect(treatments2.length, 1);

    });



  });
}



