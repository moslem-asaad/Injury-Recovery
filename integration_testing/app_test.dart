import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/components/menu_button.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/components/my_text_field.dart';
import 'package:injury_recovery/constants/colors.dart';
import 'package:injury_recovery/constants/routes.dart';
import 'package:injury_recovery/features/domain/controllers/users_profiles_controller.dart';
import 'package:injury_recovery/features/presentation/services/service_layer.dart';
import 'package:injury_recovery/features/presentation/views/customer/customer_profile.dart';
import 'package:injury_recovery/features/presentation/views/customer/treatment/videos_view.dart';
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
import 'package:injury_recovery/features/presentation/widgets/my_container_button.dart';
import 'package:injury_recovery/features/presentation/widgets/my_video_player.dart';
import 'package:injury_recovery/features/presentation/widgets/video_navigation_button.dart';
import 'package:injury_recovery/main.dart' as app;
import 'package:injury_recovery/main.dart';
import 'package:integration_test/integration_test.dart';
import 'package:video_player/video_player.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
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
  Future<void> _myVideoPlayerSenarios(WidgetTester tester) async {
    expect(find.byType(VideoPlayer), findsOneWidget);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(VideoPlayer));
    await tester.pump();

    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byType(VideoPlayer));
    await tester.pump();

    await tester.pump(const Duration(seconds: 1));
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    expect(find.byIcon(Icons.volume_up_outlined), findsOneWidget);
    expect(find.byIcon(Icons.fullscreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.volume_up_outlined));
    await tester.pump();

    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byType(VideoPlayer));
    await tester.pump();

    await tester.pump(const Duration(seconds: 1));
    //await tester.tap(find.byIcon(Icons.volume_off_outlined));
    //await tester.pump();

    //await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.byIcon(Icons.fullscreen));
    await tester.pump();

    await tester.pump(const Duration(seconds: 5));
    expect(find.byType(VideoPlayer), findsOneWidget);
    await Future.delayed(Duration(seconds: 2));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(VideoPlayer));
    await tester.pump();

    await tester.pump(const Duration(seconds: 1));
    expect(find.byIcon(Icons.fullscreen), findsOneWidget);
    await tester.tap(find.byIcon(Icons.fullscreen));
    await tester.pump();

    await tester.pump(const Duration(seconds: 5));
    //expect(find.byType(VideoPlayer), findsOneWidget);
    await Future.delayed(Duration(seconds: 2));
    await tester.pumpAndSettle();
  }

  Future<void> _navigateIndex(WidgetTester tester, index) async {
    await tester.tap(find.byWidgetPredicate((widget) {
      if (widget is Container && widget.decoration is BoxDecoration) {
        final BoxDecoration decoration = widget.decoration as BoxDecoration;
        return decoration.shape ==
            BoxShape.circle /*&& decoration.color != my_blue*/;
      }
      return false;
    }).at(index));
    await tester.pumpAndSettle();
  }

  Future<void> _feedbackWithoutVideo(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'משוב ללא סרטון');
    await Future.delayed(Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('שליחת הבקשה'), findsOneWidget);
    await Future.delayed(Duration(seconds: 5));
    await tester.pump(const Duration(seconds: 10));
    await tester.tap(find.text('שליחת הבקשה'));
    await Future.delayed(Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    await tester.pumpAndSettle();
  }

  Future<void> _openRequest(WidgetTester tester) async {
    await tester.pumpAndSettle();
    expect(find.text('עיון בבקשה'), findsAtLeast(1));
    await tester.tap(find.text('עיון בבקשה').first);
    await tester.pumpAndSettle();
  }

  group(
    'app test',
    () {
      testWidgets('Test Cutomer side',
          (WidgetTester tester) async {
        await tester.pumpWidget(myapp);

        await tester.pumpAndSettle();
        try {
          var user = await UsersProfilesController().getLoggedInUser();
          print('aaaaaaaaaaaaa ${user.email}');
          //await UsersProfilesController().logOut();
          await tester.pumpWidget(myapp);
          await tester.pumpAndSettle();
          final ctr = find.text('הפרופיל שלי');
          expect(ctr, findsOneWidget);
          await tester
              .tap(find.byType(TextButton).at(0)); // Navigate to feedbacks page
          await tester.pumpAndSettle(); // Wait for navigation to complete

          await Future.delayed(Duration(seconds: 3));
          await tester.pump(Duration(seconds: 3));
          await _openRequest(tester);
          await tester.pumpAndSettle();
          await tester.pageBack(); // Navigate back to profile page
          await tester.pumpAndSettle();
          await tester.pageBack(); // Navigate back to profile page
          await tester.pumpAndSettle();

          await Future.delayed(Duration(seconds: 2));

          await tester.tap(find.byType(TextButton).at(1));
          await Future.delayed(Duration(seconds: 2));
          await tester.pumpAndSettle();
          final ctr1 = find.text('טיפולים שלי');
          expect(ctr1, findsOneWidget);
          await tester.pumpAndSettle();
          await tester.tap(find.byType(TextButton).at(0));
          await Future.delayed(Duration(seconds: 2));
          await tester.pumpAndSettle();
          await Future.delayed(Duration(seconds: 2));
          await tester.pumpAndSettle();
          await Future.delayed(Duration(seconds: 2));
          await tester.pumpAndSettle();
          expect(find.text('תרגילים'), findsOneWidget);
          expect(find.text('בקשות משוב'), findsOneWidget);
          // Ensure the video player is displayed
          //await _myVideoPlayerSenarios(tester);
          await tester.pumpAndSettle();

          await _navigateIndex(tester, 1);
          //await _myVideoPlayerSenarios(tester);
          await Future.delayed(Duration(seconds: 3));
          await tester.pumpAndSettle();
          await _navigateIndex(tester, 2);
          //await _myVideoPlayerSenarios(tester);
          await tester.pumpAndSettle();
          expect(find.text('משהו לא ברור ? תשלח משוב כאן'), findsOneWidget);
          await Future.delayed(Duration(seconds: 1));
          await tester.tap(find.text('משהו לא ברור ? תשלח משוב כאן'));
          await Future.delayed(Duration(seconds: 1));
          await tester.pumpAndSettle();
          expect(find.text('לחיצה כאן'), findsOneWidget);
          await Future.delayed(Duration(seconds: 1));
          await _feedbackWithoutVideo(tester);
          await tester.tap(find.text('Ok'));
          //await tester.pump(const Duration(seconds: 15));
          //expect(find.text('Feedback sent successfully'), findsOneWidget);
          //await Future.delayed(Duration(seconds: 1));
          await tester.pump(const Duration(seconds: 5));
          await tester.pumpAndSettle();
          //expect(find.text('משהו לא ברור ? תשלח משוב כאן'), findsOneWidget);

          // Tap on the 'בקשות משוב' tab
          await tester.tap(find.text('בקשות משוב'));
          await tester.pumpAndSettle();
          await Future.delayed(Duration(seconds: 3));
          await tester.pump(Duration(seconds: 3));
          await _openRequest(tester);
          await tester.pumpAndSettle();
          
        } catch (e) { // if the user not logged in, make the logging in process
        
           await tester.pumpAndSettle();
          // Trigger navigation to the reset password page
          await tester.tap(find.byType(TextButton).at(0));
          await tester.pumpAndSettle();
          await tester.pageBack();
          await tester.pumpAndSettle();
          await tester.tap(find.byType(TextButton).at(2));
          await tester.pumpAndSettle();
          await tester.tap(find.byType(TextButton).at(1));
          await tester.pumpAndSettle();
          await tester.enterText(
              find.byType(MyTextField).at(0), 'moslem.asaad2000@gmail.com');
          await tester.enterText(find.byType(MyTextField).at(1), '123456');
          await tester.tap(find.byType(TextButton).at(1));
          await tester.pumpAndSettle();
          await tester.pumpWidget(myapp);
          await tester.pumpAndSettle();
        }
      });
      /*testWidgets('register senarios', (tester) async {
        app.main();
        await tester.pumpAndSettle();

        await tester.tap(find.byType(TextButton).at(2));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).at(0), 'haitam');
        expect(find.text('haitam'), findsOneWidget);

        await tester.enterText(find.byType(TextField).at(1), 'assadi');
        expect(find.text('assadi'), findsOneWidget);

        await tester.enterText(find.byType(TextField).at(2), '0549323444');
        expect(find.text('0549323444'), findsOneWidget);

        await tester.enterText(find.byType(TextField).at(3), 'asd@gmail.com');
        expect(find.text('asd@gmail.com'), findsOneWidget);

        await tester.enterText(find.byType(TextField).at(4), 'password123');
        expect(find.text('password123'), findsOneWidget);

        await tester.enterText(find.byType(TextField).at(5), 'password123');
        //expect(find.text('password123'), findsOneWidget);
        await Future.delayed(Duration(seconds: 5));
        await tester.tap(find.byType(TextButton).first);
        await tester.pumpAndSettle();
        await (find.byType(LoginView), findsNothing);
        await tester.pumpAndSettle();
        final ctr = find.text('דואר אלקטרוני');
        expect(ctr, findsOneWidget);
        await tester.pumpAndSettle();
        /*await tester.tap(find.byType(TextButton).at(2));
        await tester.pumpAndSettle();*/
      });*/
      /*testWidgets('login register login senarios', (tester) async {
        app.main();
        await tester.pumpAndSettle();
        
          // Trigger navigation to the reset password page
          await tester.enterText(
              find.byType(MyTextField).at(0), 'moslem.asaad2000@gmail.com');
          await tester.pumpAndSettle();
          await tester.enterText(find.byType(MyTextField).at(1), '123456');
          await tester.pumpAndSettle();
          await tester.tap(find.byType(TextButton).at(1));
          await tester.pumpAndSettle();
      });*/
    },
  );
}

//await tester.tap(find.byType(GestureDetector).at(1));//feedback request
//await tester.tap(find.byType(GestureDetector).at(2));//navigation 1
//await tester.tap(find.byType(GestureDetector).at(3));//navigation2
//await tester.tap(find.byType(GestureDetector).at(4));//navigation3
//await tester.tap(find.byType(GestureDetector).at(5));//navigation 4
// await tester.tap(find.byType(GestureDetector).at(6));// navigation 5
//await tester.tap(find.byType(GestureDetector).at(7)); // back
//await tester.tap(find.byType(GestureDetector).at(8)); // videos (bsr button)
//await tester.tap(find.byType(GestureDetector).at(9)); // feedbacks (bar button)
