import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/features/consts.dart';
import 'package:injury_recovery/features/domain/entities/exercise_video.dart';
import 'package:injury_recovery/features/domain/entities/feedback_request.dart';
import 'package:injury_recovery/features/domain/entities/treatment.dart';
import 'package:injury_recovery/features/presentation/services/response.dart';
import 'package:injury_recovery/features/presentation/services/service_layer.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';

import 'acceptance_tests_consts_and_helper_functions.dart';
// ignore_for_file: avoid_print

late Service service;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.firebase().initialize();

  setUpAll(() async {
    service = Service();
    service.setIsTestExecution(true);
    // print("reminder: delete users from Authentication");
    // await service.cleanCollection(FirestoreTablesNames.users);
    //loginAndLogOutSetUp();
    print(
        "reminder: you need to run register acceptance test first, or call loginAndLogOutSetUp()");
    await service.cleanCollection(FirestoreTablesNames.exerciseVideos);
    await service.cleanCollection(FirestoreTablesNames.treatments);
    await createExerciseVideosToUseInTreatment();
  });

  tearDownAll(() async {
    await service.cleanCollection(FirestoreTablesNames.exerciseVideos);
    await service.cleanCollection(FirestoreTablesNames.treatments);
  });

  group('authorizetion levels Acceptance Tests', () {
    test1;
    /*test2;
    test3;
    test4;
    test5;
    test6;*/
  });
}

var test1 = test('customer user try to create treatment test', () async {
  ResponseT<bool> response =
      await service.logIn(customerUser1Email, customerUser1Pass);
  expect(response.errorOccured, false);
  expect(response.val, true);

  try {
    response = await service.createTreatment(treatment2CustomerUser,
        treatment2Name, treatment2Description, treatment2videosIds);
  } catch (e) {
    expect(response.errorOccured, true);
    expect(response.val, false);
  }

  response = await service.logout();
  expect(response.errorOccured, false);
  expect(response.val, true);
});

var test2 = test('responde FeedbackRequest base test', () async {
  ResponseT<bool> response =
      await service.logIn(customerUser1Email, customerUser1Pass);
  expect(response.errorOccured, false);
  expect(response.val, true);
  try {
    response = await service.sendFeedbackResponse(1, feedbackRequest1response);
  } catch (_) {
    expect(response.errorOccured, true);
    expect(response.val, false);
  }
  response = await service.logout();
  expect(response.errorOccured, false);
  expect(response.val, true);
});
