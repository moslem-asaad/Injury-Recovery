import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/features/consts.dart';
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
      await service.cleanCollection(FirestoreTablesNames.users);
      print("reminder: delete users from Authentication");
  });

  tearDownAll(() {
     
  });


  group('Register Acceptance Tests', ()  {

    test1;
    test2;
    test3;
    test4;
    test5;

  });
}
var test5 = test('register CustomerUser1 with wrong confiemed password fail', () async {
        ResponseT<bool> response = await service.register("extra$customerUser1Email", customerUser1Pass,
         "${customerUser1Pass}wrong", customerUser1FirstName, customerUser1LastName,
          customerUser1PhoneNumber);

        expect(response.errorOccured, true);
    });

var test4 = test('register CustomerUser1 with used email fail', () async {
        ResponseT<bool> response = await service.register(customerUser1Email, customerUser1Pass,
         customerUser1Pass, customerUser1FirstName, customerUser1LastName,
          customerUser1PhoneNumber);

        expect(response.errorOccured, true);
    });

var test1 = test('register System Manager success', () async {
        ResponseT<bool> response =await service.register(systemManagerEmail, systemManagerPass,
         systemManagerPass, systemManagerFirstName, systemManagerLastName,
          systemManagerPhoneNumber);
        
        expect(response.errorOccured, false);
        expect(response.val, true);

        response = await service.logIn(systemManagerEmail, systemManagerPass);

        expect(response.errorOccured, false);
        expect(response.val, true);

        ResponseT<List<User>> response1 = await service.getAllUsers();

        expect(response1.errorOccured, false);
        expect(response1.val!.length, 1);

        User user = response1.val![0];

        expect(user.email, systemManagerEmail);
        expect(user.firstName, systemManagerFirstName);
        expect(user.lastName, systemManagerLastName);
        expect(user.phoneNumber, systemManagerPhoneNumber);
        expect(user.isSystemManager, true);

        await service.logout();
    });


var test2 = test('Customer User1 register success', () async {
        ResponseT<bool> response = await service.register(customerUser1Email, customerUser1Pass,
         customerUser1Pass, customerUser1FirstName, customerUser1LastName,
          customerUser1PhoneNumber);

        expect(response.errorOccured, false);
        expect(response.val, true);


        response = await service.logIn(customerUser1Email, customerUser1Pass);

        expect(response.errorOccured, false);
        expect(response.val, true);

        response = await service.logout();

        expect(response.errorOccured, false);
        expect(response.val, true);

        response = await service.logIn(systemManagerEmail, systemManagerPass);

        expect(response.errorOccured, false);
        expect(response.val, true);

        ResponseT<List<User>> response1 = await service.getAllUsers();

        expect(response1.errorOccured, false);
        expect(response1.val!.length, 2);

        User user1 = response1.val![0];
        User user2 = response1.val![1];
        bool user1IsSystemManager = user1.isSystemManager;
        bool user2IsSystemManager = user2.isSystemManager;
        expect(user1IsSystemManager || user2IsSystemManager, isTrue);
        expect(user1IsSystemManager && user2IsSystemManager, isFalse);


        if(user1IsSystemManager){
        expect(user1.email, systemManagerEmail);
        expect(user1.firstName, systemManagerFirstName);
        expect(user1.lastName, systemManagerLastName);
        expect(user1.phoneNumber, systemManagerPhoneNumber);
        expect(user1.isSystemManager, true);

        expect(user2.email, customerUser1Email);
        expect(user2.firstName, customerUser1FirstName);
        expect(user2.lastName, customerUser1LastName);
        expect(user2.phoneNumber, customerUser1PhoneNumber);
        expect(user2.isSystemManager, false);
        }else{

        expect(user2.email, systemManagerEmail);
        expect(user2.firstName, systemManagerFirstName);
        expect(user2.lastName, systemManagerLastName);
        expect(user2.phoneNumber, systemManagerPhoneNumber);
        expect(user2.isSystemManager, true);

        expect(user1.email, customerUser1Email);
        expect(user1.firstName, customerUser1FirstName);
        expect(user1.lastName, customerUser1LastName);
        expect(user1.phoneNumber, customerUser1PhoneNumber);
        expect(user1.isSystemManager, false);
        }

        await service.logout();
    });




var test3 = test('CustomerUser2 and CustomerUser3 register success', () async {
        ResponseT<bool> response = await service.register(customerUser2Email, customerUser2Pass,
         customerUser2Pass, customerUser2FirstName, customerUser2LastName,
          customerUser2PhoneNumber);

        expect(response.errorOccured, false);
        expect(response.val, true);



        response = await service.register(customerUser3Email, customerUser3Pass,
         customerUser3Pass, customerUser3FirstName, customerUser3LastName,
          customerUser3PhoneNumber);

        expect(response.errorOccured, false);
        expect(response.val, true);


        response = await service.logIn(customerUser2Email, customerUser2Pass);

        expect(response.errorOccured, false);
        expect(response.val, true);

        response = await service.logout();

        expect(response.errorOccured, false);
        expect(response.val, true);

        response = await service.logIn(customerUser3Email, customerUser3Pass);

        expect(response.errorOccured, false);
        expect(response.val, true);

        response = await service.logout();

        expect(response.errorOccured, false);
        expect(response.val, true);

        response = await service.logIn(systemManagerEmail, systemManagerPass);

        expect(response.errorOccured, false);
        expect(response.val, true);

        ResponseT<List<User>> response1 = await service.getAllUsers();

        expect(response1.errorOccured, false);
        expect(response1.val!.length, 4);

        List<User> users = [];
        for(int i=0; i<response1.val!.length; i++){
          if(response1.val![i].email == customerUser2Email || response1.val![i].email == customerUser3Email){
                users.add(response1.val![i]);
          }
        }

        expect(users.length, 2);

        int countUser2Email = users.where((user) => user.email == customerUser2Email).length;
        int countUser3Email = users.where((user) => user.email == customerUser3Email).length;

        expect(countUser2Email, equals(1));
        expect(countUser3Email, equals(1));




        await service.logout();
    });




