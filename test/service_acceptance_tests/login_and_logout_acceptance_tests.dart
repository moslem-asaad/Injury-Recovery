import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/features/domain/entities/feedback_request.dart';
import 'package:injury_recovery/features/domain/entities/user.dart';
import 'package:injury_recovery/features/presentation/services/response.dart';
import 'package:injury_recovery/features/presentation/services/service_layer.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';
// ignore_for_file: avoid_print


late Service service;

 const systemManagerEmail = "system_manager_test@hotmail.com";
 const systemManagerPass = "systemManagerPass123";
 const systemManagerFirstName = "System";
 const systemManagerLastName = "Manager";
 const systemManagerPhoneNumber = "0548362290";

 const customerUser1Email = "customer_user_1_test@hotmail.com";
 const customerUser1Pass = "customerUser1Pass5673";
 const customerUser1FirstName = "UserOneFirstName";
 const customerUser1LastName = "UserOneLastName";
 const customerUser1PhoneNumber = "0588125290";

 const customerUser2Email = "customer_user_2_test@hotmail.com";
 const customerUser2Pass = "customerUser2Pass5673278";
 const customerUser2FirstName = "UserTwoFirstName";
 const customerUser2LastName = "UserTwoLastName";
 const customerUser2PhoneNumber = "0536562440";

 const customerUser3Email = "customer_user_3_test@hotmail.com";
 const customerUser3Pass = "customerUser3Pass5674269";
 const customerUser3FirstName = "UserThreeFirstName";
 const customerUser3LastName = "UserThreeLastName";
 const customerUser3PhoneNumber = "0521167790";

void loginAndLogOutSetUp() async{
        ResponseT<bool> response = await service.register(systemManagerEmail, systemManagerPass,
              systemManagerPass, systemManagerFirstName, systemManagerLastName,
                systemManagerPhoneNumber);
        
        expect(response.errorOccured, false);
        expect(response.val, true);

        response = await service.register(customerUser1Email, customerUser1Pass,
              customerUser1Pass, customerUser1FirstName, customerUser1LastName,
                customerUser1PhoneNumber);

        expect(response.errorOccured, false);
        expect(response.val, true);

        response = await service.register(customerUser2Email, customerUser2Pass,
              customerUser2Pass, customerUser2FirstName, customerUser2LastName,
                customerUser2PhoneNumber);

        expect(response.errorOccured, false);
        expect(response.val, true);

        response = await service.register(customerUser3Email, customerUser3Pass,
              customerUser3Pass, customerUser3FirstName, customerUser3LastName,
                customerUser3PhoneNumber);

        expect(response.errorOccured, false);
        expect(response.val, true);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.firebase().initialize();

  setUpAll(() async {

      service = Service();
      service.setIsTestExecution(true);
      // print("reminder: delete users from Authentication");
      // await service.cleanCollection(FirestoreTablesNames.users);
      // loginAndLogOutSetUp()
      print("reminder: you need to run register acceptance test first, or call loginAndLogOutSetUp()");
  });

  tearDownAll(() {
     
  });


  group('Acceptance Tests', ()  {

    test1;
    test2;
    test3;
    test4;
    test5;
    test6;
    test7;

  });
}
var test1 = test('login success for System Manager', () async {
        ResponseT<bool> response = await service.logIn(systemManagerEmail, systemManagerPass);

        expect(response.errorOccured, false);
        expect(response.val, true);

        ResponseT<List<User>> response1 = await service.getAllUsers();

        expect(response1.errorOccured, false);
        expect(response1.val!.length, greaterThan(3));

        ResponseT<List<FeedbackRequest>> response2 = await service.getAllUsersFeedbackRequests();

        expect(response2.errorOccured, false);
        expect(response2.val!.length, greaterThan(-1));

        await service.logout();
    });


var test2 = test('login success for CustomerUser1', () async {
        ResponseT<bool> response = await service.logIn(customerUser1Email, customerUser1Pass);

        expect(response.errorOccured, false);
        expect(response.val, true);

        ResponseT<String> response1 = await service.getUserFirstName();

        expect(response1.errorOccured, false);
        expect(response1.val, customerUser1FirstName);

        ResponseT<List<FeedbackRequest>> response2 = await service.getMyFeedbackRequests();

        expect(response2.errorOccured, false);
        expect(response2.val!.length, greaterThan(-1));

        await service.logout();
    });

var test3 = test('login success for CustomerUser2 after CustomerUser1 logged out', () async {
        ResponseT<bool> response = await service.logIn(customerUser1Email, customerUser1Pass);
        expect(response.errorOccured, false);

        ResponseT<String> response1 = await service.getUserFirstName();
        expect(response1.val, customerUser1FirstName);

        await service.logout();

        ResponseT<bool> response2 = await service.logIn(customerUser2Email, customerUser2Pass);

        expect(response2.errorOccured, false);
        expect(response2.val, true);


        response1 = await service.getUserFirstName();
        expect(response1.val, customerUser2FirstName);


        ResponseT<List<FeedbackRequest>> response3 = await service.getMyFeedbackRequests();

        expect(response3.errorOccured, false);
        expect(response3.val!.length, greaterThan(-1));

        await service.logout();
    });

var test4 = test('double login fail for CustomerUser1', () async {
        ResponseT<bool> response = await service.logIn(customerUser1Email, customerUser1Pass);
        expect(response.errorOccured, false);
        expect(response.val, true);

        response = await service.logIn(customerUser1Email, customerUser1Pass);
        expect(response.errorOccured, true);


        ResponseT<String> response1 = await service.getUserFirstName();
        expect(response1.errorOccured, false);

        ResponseT<List<FeedbackRequest>> response3 = await service.getMyFeedbackRequests();

        expect(response3.errorOccured, false);
        expect(response3.val!.length, greaterThan(-1));

        response = await service.logout();
        expect(response.errorOccured, false);
        expect(response.val, true);
    });

var test5 = test('login wrong password fail for CustomerUser1', () async {
        ResponseT<bool> response = await service.logIn(customerUser1Email, customerUser2Pass);
        expect(response.errorOccured, true);

        ResponseT<String> response1 = await service.getUserFirstName();
        expect(response1.errorOccured, true);


        response = await service.logIn(customerUser1Email, "${customerUser1Pass}extra");
        expect(response.errorOccured, true);

    });

var test6 = test('logout success', () async {
        ResponseT<bool> response = await service.logIn(customerUser1Email, customerUser1Pass);
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
        ResponseT<bool> response = await service.logIn(customerUser1Email, customerUser1Pass);
        expect(response.errorOccured, false);
        expect(response.val, true);

        response = await service.logout();

        expect(response.errorOccured, false);
        expect(response.val, true);


        response = await service.logout();

        expect(response.errorOccured, true);
    });






