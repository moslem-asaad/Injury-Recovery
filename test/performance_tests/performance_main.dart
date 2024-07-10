import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/constants/routes.dart';
import 'package:injury_recovery/features/domain/entities/feedback_request.dart';
import 'package:injury_recovery/features/domain/entities/user.dart';
import 'package:injury_recovery/features/presentation/services/response.dart';
import 'package:injury_recovery/features/presentation/services/service_layer.dart';
import 'package:injury_recovery/features/presentation/views/customer/customer_profile.dart';
import 'package:injury_recovery/features/presentation/views/customer/treatments.dart';
import 'package:injury_recovery/features/presentation/views/gallary_view.dart';
import 'package:injury_recovery/features/presentation/views/login_view.dart';
import 'package:injury_recovery/features/presentation/views/register_view.dart';
import 'package:injury_recovery/features/presentation/views/reset_password_view.dart';
import 'package:injury_recovery/features/presentation/views/system_manager/create_treatment.dart';
import 'package:injury_recovery/features/presentation/views/system_manager/main_view.dart';
import 'package:injury_recovery/features/presentation/views/system_manager/upload_video_view.dart';
import 'package:injury_recovery/features/presentation/views/system_manager/users_feedbacks.dart';
import 'package:injury_recovery/features/presentation/views/verify_email_view.dart';
import 'package:injury_recovery/main.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';

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

  group('performance tests', () {
    systemInitTimeTest;
    logInTimeTest;
    registerTimeTest;
    uploadVideoLinearTime;
    //multipleuserstest;
  });
}

var myapp = MaterialApp(
  title: 'Flutter Demo',
  theme: ThemeData(
    primarySwatch: Colors.blueGrey,
    //scaffoldBackgroundColor: Color.fromARGB(87, 155, 155, 155),
  ),
  home: const HomePage(),
  routes: {
    loginRoute: (context) => const LoginView(),
    registerRoute: (context) => const RegisterView(),
    mainRoute: (context) => const MainView(),
    verifyEmailRoute: (context) => const VerifyEmailView(),
    resetPasswordRout: (context) => const ResetPasswordView(),
    uploadVideoRout: (context) => const UploadVideoView(),
    gallaryRout: (context) => const GallaryView(),
    customerProfileRout: (context) => const CustomerProfile(),
    treatmentsRout: (context) => const Treatmants(),
    createTreatmentRoute: (context) => const CreateTreatments(),
    usersFeedbacksRout: (context) => const UsersFeedbacksView(),
  },
);

var systemInitTimeTest =
    test('System initialization should take less than 6 seconds', () async {
  final stopwatch = Stopwatch()..start();
  runApp(myapp);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    stopwatch.stop();
    print("System initialization time ${stopwatch.elapsed}");
    expect(stopwatch.elapsedMilliseconds, lessThan(6000),
        reason: 'Initialization took too long!');
  });
});

var logInTimeTest =
    test('Logging in process should take less than 6 seconds', () async {
  final stopwatch = Stopwatch()..start();
  await Service().logIn('moslem.asaad2000@gmail.com', '123456');
  stopwatch.stop();
  print("loggin in time ${stopwatch.elapsed}");
  expect(stopwatch.elapsedMilliseconds, lessThan(6000),
      reason: 'Logging in took too long!');
});

var registerTimeTest =
    test('Registration process should take less than 6 seconds', () async {
  final stopwatch = Stopwatch()..start();
  await Service().register('example1@gmail.com', 'example123', 'example123',
      'example first', 'example last', '0123456789');
  stopwatch.stop();
  print("register in time ${stopwatch.elapsed}");
  expect(stopwatch.elapsedMilliseconds, lessThan(6000),
      reason: 'Registration took too long!');
});

var uploadVideoLinearTime =
    test('Upload video process should be linear with video size', () async {
      final stopwatch1 = Stopwatch()..start();
      await service.uploadVideo('https://drive.google.com/file/d/197lyNCz-DAfXJtKSds_dTGrTQ3QD2aFJ/view?usp=sharing', 'videosTest', (progress) {});
      stopwatch1.stop();
      print("upload1 time ${stopwatch1.elapsed}");
      final stopwatch2 = Stopwatch()..start();
      await service.uploadVideo('https://drive.google.com/file/d/1mNiyYjntyAVt1H0dc8ZAel7Bxd7-v3Ae/view?usp=sharing', 'videosTest', (progress) {});
      stopwatch2.stop();
      print("upload2 time ${stopwatch2.elapsed}");
      expect(stopwatch2.elapsedMilliseconds, lessThan(stopwatch1.elapsedMilliseconds),
      reason: 'video 2 sized smaller than video 1 size!');
    });

  /*var multipleuserstest = testWidgets('Simulate multiple users', (WidgetTester tester) async {
    runApp(myapp);
    await tester.pumpAndSettle();

    // Simulate 50 users logging in concurrently
    List<Future> loginFutures = [];
    for (int i = 0; i < 50; i++) {
      loginFutures.add(service.logIn('testuser$i@example.com', 'testpassword'));
    }

    await Future.wait(loginFutures).then((results) {
        print("All logins completed");
        for (var result in results) {
          print("Login result: $result");
        }
      }).catchError((error) {
        print("Error during logins: $error");
      });
  });*/







