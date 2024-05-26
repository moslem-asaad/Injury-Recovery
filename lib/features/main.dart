import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';
import 'data/services/auth_exceptions.dart';
import 'domain/controllers/excercise_videos_controller.dart';
import 'domain/controllers/users_profiles_controller.dart';
import 'domain/entities/treatment.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
// ignore_for_file: avoid_print


void main() async {
  // Initialize Firebase before running tests
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.firebase().initialize();
  print("here1");
  


  group('Acceptance Tests', () {
    late UsersProfilesController usersProfilesController;
    // ignore: unused_local_variable
    late ExerciseVideosController exerciseVideosController;
    List<dynamic> args = ["fds"];


    setUp(() {
      usersProfilesController = UsersProfilesController();
      exerciseVideosController = ExerciseVideosController();
    });

    // test('UsersProfilesController.getUserTreatments returns correct treatments', () async {
    //   // Set up test data in Firebase, if necessary
    //   // For example, ensure the user "ahmad1999@gmail.com" has some treatments

    //   List<Treatment> treatments = await usersProfilesController.getUserTreatments();

    //   expect(treatments, isNotEmpty); 
    //   expect(treatments.length, 2);// Check if treatments are not empty
    //   print("hereee");
    //   print(treatments.length);
    // });

    // test('UsersProfilesController.getUserTreatments returns correct treatments for another user', () async {
    //   List<Treatment> treatments2 = await usersProfilesController.getUserTreatments();

    //   expect(treatments2, isNotEmpty);
    //   expect(treatments2.length, 1); // Check if treatments are not empty
    //   print("hereee2");
    //   print(treatments2.length);
    // });

    // Add more acceptance tests for ExerciseVideosController and other methods as needed
  });
  print("hereee3");
}

/*

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.firebase().initialize();
  runApp(MyApp());
}

Future<void> test_method() async{
  UsersProfilesController usersProfilesController =  UsersProfilesController();
  ExerciseVideosController exerciseVideosController = ExerciseVideosController();

  //usersProfilesController.register("asaadmoslem2000@gmail.com", "456Gdsg45gj5", "moslem", "asaad", "0522375587");
  //usersProfilesController.register("ahmad1999@gmail.com", "456Gdsg45gj5", "ahmad", "essa", "0522377222");
  //usersProfilesController.register("haitham2001@gmail.com", "456Gdsg45gj5", "haitham", "assadi", "0522375111");
  List<Treatment> treatments = await usersProfilesController.getUserTreatments("ahmad1999@gmail.com");
  print("hereee");
  print(treatments.length);


  List<Treatment> treatments2 = await usersProfilesController.getUserTreatments("haitham2001@gmail.com");
  print("hereee2");
  print(treatments2.length);
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Button Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Button Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await test_method();
            // Add your button press logic here
            print('Button Pressed!');
          },
          child: Text('Press Me'),
        ),
      ),
    );
  }
}

*/