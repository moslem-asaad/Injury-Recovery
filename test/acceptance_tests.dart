import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/features/domain/controllers/excercise_videos_controller.dart';
import 'package:injury_recovery/features/domain/controllers/users_profiles_controller.dart';
import 'package:injury_recovery/features/domain/entities/treatment.dart';
import 'package:injury_recovery/features/domain/entities/user.dart';
import 'package:injury_recovery/features/presentation/services/response.dart';
import 'package:injury_recovery/features/presentation/services/service_layer.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';
// ignore_for_file: avoid_print


late Service service;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.firebase().initialize();

  group('Acceptance Tests', ()  {

    setUp(() {
      service = Service();
    });

    test1;

  });
}

var test1 = test('UsersProfilesController.getUserTreatments returns correct treatments', () async {


      await service.logIn("asaadmoslem2000@gmail.com", "password123");
      ResponseT<List<User>> response = await service.getAllUsers();
      expect(response.errorOccured, false);
      expect(response.val!.length, greaterThan(0));
      expect(response.val!.length, greaterThan(1));
      expect(response.val!.length, greaterThan(2));
      expect(response.val![0].email, anyOf([
    equals("asaadmoslem2000@gmail.com"),
    equals("ahmad@hotmail.com")
  ]));

    });




