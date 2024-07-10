import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/features/domain/entities/feedback_request.dart';
import 'package:injury_recovery/features/domain/entities/user.dart';
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
    // loginAndLogOutSetUp()
    print(
        "reminder: you need to run register acceptance test first, or call loginAndLogOutSetUp()");
  });

  tearDownAll(() {});

  group('Login and Logout Acceptance Tests', () {
    test1;
    test2;
    test3;
    test4;
    test5;
    test6;
    test7;
    //testmultipleRegisters;
  });
}

var testmultipleRegisters = test('multiple registesr', () async {
  var usersExampleEmail = {};
  var usersExamplePasswords = {};
  var usersExampleFirstName = {};
  var usersExampleLastName = {};
  const usersExamplePhoneNumber = "0512345678";

  for (int i = 0; i < 50; i++) {
    usersExampleEmail[i] = 'testuser$i@example.com';
    usersExamplePasswords[i] = 'password$i';
    usersExampleFirstName[i] = 'userFirstName';
    usersExampleLastName[i] = 'userLastName';
  }
  for (int i = 0; i < 50; i++) {
    try {
      ResponseT<bool> response = await service.register(
          usersExampleEmail[i],
          usersExamplePasswords[i],
          usersExamplePasswords[i],
          usersExampleFirstName[i],
          usersExampleLastName[i],
          usersExamplePhoneNumber);

      expect(response.errorOccured, false);
      expect(response.val, true);
    } catch (e) {
      print("error ${e.toString()}");
    }
  }
});

var test1 = test('login success for System Manager', () async {
  ResponseT<bool> response =
      await service.logIn(systemManagerEmail, systemManagerPass);

  expect(response.errorOccured, false);
  expect(response.val, true);

  ResponseT<List<User>> response1 = await service.getAllUsers();

  expect(response1.errorOccured, false);
  expect(response1.val!.length, greaterThan(3));

  ResponseT<List<FeedbackRequest>> response2 =
      await service.getAllUsersFeedbackRequests();

  expect(response2.errorOccured, false);
  expect(response2.val!.length, greaterThan(-1));

  await service.logout();
});

var test2 = test('login success for CustomerUser1', () async {
  ResponseT<bool> response =
      await service.logIn(customerUser1Email, customerUser1Pass);

  expect(response.errorOccured, false);
  expect(response.val, true);

  ResponseT<String> response1 = await service.getUserFirstName();

  expect(response1.errorOccured, false);
  expect(response1.val, customerUser1FirstName);

  ResponseT<List<FeedbackRequest>> response2 =
      await service.getMyFeedbackRequests();

  expect(response2.errorOccured, false);
  expect(response2.val!.length, greaterThan(-1));

  await service.logout();
});

var test3 = test(
    'login success for CustomerUser2 after CustomerUser1 logged out', () async {
  ResponseT<bool> response =
      await service.logIn(customerUser1Email, customerUser1Pass);
  expect(response.errorOccured, false);

  ResponseT<String> response1 = await service.getUserFirstName();
  expect(response1.val, customerUser1FirstName);

  await service.logout();

  ResponseT<bool> response2 =
      await service.logIn(customerUser2Email, customerUser2Pass);

  expect(response2.errorOccured, false);
  expect(response2.val, true);

  response1 = await service.getUserFirstName();
  expect(response1.val, customerUser2FirstName);

  ResponseT<List<FeedbackRequest>> response3 =
      await service.getMyFeedbackRequests();

  expect(response3.errorOccured, false);
  expect(response3.val!.length, greaterThan(-1));

  await service.logout();
});

var test4 = test('double login fail for CustomerUser1', () async {
  ResponseT<bool> response =
      await service.logIn(customerUser1Email, customerUser1Pass);
  expect(response.errorOccured, false);
  expect(response.val, true);

  response = await service.logIn(customerUser1Email, customerUser1Pass);
  expect(response.errorOccured, true);

  ResponseT<String> response1 = await service.getUserFirstName();
  expect(response1.errorOccured, false);

  ResponseT<List<FeedbackRequest>> response3 =
      await service.getMyFeedbackRequests();

  expect(response3.errorOccured, false);
  expect(response3.val!.length, greaterThan(-1));

  response = await service.logout();
  expect(response.errorOccured, false);
  expect(response.val, true);
});

var test5 = test('login wrong password fail for CustomerUser1', () async {
  ResponseT<bool> response =
      await service.logIn(customerUser1Email, customerUser2Pass);
  expect(response.errorOccured, true);

  ResponseT<String> response1 = await service.getUserFirstName();
  expect(response1.errorOccured, true);

  response =
      await service.logIn(customerUser1Email, "${customerUser1Pass}extra");
  expect(response.errorOccured, true);
});

var test6 = test('logout success', () async {
  ResponseT<bool> response =
      await service.logIn(customerUser1Email, customerUser1Pass);
  expect(response.errorOccured, false);
  expect(response.val, true);

  ResponseT<String> response1 = await service.getUserFirstName();
  expect(response1.errorOccured, false);
  expect(response1.val, customerUser1FirstName);

  response = await service.logout();

  expect(response.errorOccured, false);
  expect(response.val, true);

  response1 = await service.getUserFirstName();
  expect(response1.errorOccured, true);
});

var test7 = test('logout while not logged in fail', () async {
  ResponseT<bool> response =
      await service.logIn(customerUser1Email, customerUser1Pass);
  expect(response.errorOccured, false);
  expect(response.val, true);

  response = await service.logout();

  expect(response.errorOccured, false);
  expect(response.val, true);

  response = await service.logout();

  expect(response.errorOccured, true);
});

var multipleuserstest = test('Simulate multiple users', () async {
  // Simulate 50 users logging in concurrently
  List<Future> loginFutures = [];
  for (int i = 0; i < 50; i++) {
    loginFutures.add(service.logIn('testuser$i@example.com', 'testpassword'));
  }

  /*await Future.wait(loginFutures).then((results) {
        print("All logins completed");
        for (var result in results) {
          print("Login result: $result");
        }
      }).catchError((error) {
        print("Error during logins: $error");
      });*/
});
