import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/features/consts.dart';
import 'package:injury_recovery/features/domain/entities/exercise_video.dart';
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
      // loginAndLogOutSetUp()
      print("reminder: you need to run register acceptance test first, or call loginAndLogOutSetUp()");
      await service.cleanCollection(FirestoreTablesNames.exerciseVideos);
      await service.cleanCollection(FirestoreTablesNames.treatments);
      await createExerciseVideosToUseInTreatment();
  });

  tearDownAll(() async {
      await service.cleanCollection(FirestoreTablesNames.exerciseVideos);
      await service.cleanCollection(FirestoreTablesNames.treatments);
     
  });


  group('Treatments Acceptance Tests', ()  {

    test1;
    test2;
    test3;
    test4;
    test5;
    test6;
    test7;

  });
}

var test1 = test('create Treatment base test', () async {

  ResponseT<bool> response = await service.logIn(systemManagerEmail, systemManagerPass);
    expect(response.errorOccured, false);
    expect(response.val, true);


    response = await service.createTreatment(treatment1CustomerUser,treatment1Name,
     treatment1Description, treatment1videosIds);
     
    expect(response.errorOccured, false);
    expect(response.val, true);

    response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);


    response = await service.logIn(customerUser1Email, customerUser1Pass);
    expect(response.errorOccured, false);
    expect(response.val, true);


    ResponseT<List<Treatment>> response1 = await service.getUserTreatments();
    expect(response1.errorOccured, false);
    expect(response1.val!.length, 1);

    Treatment treatment = response1.val![0];
    expect(treatment.customerUserEmail, treatment1CustomerUser);
    expect(treatment.treatmentDescription, treatment1Description);
    expect(treatment.videosIdsList!.length, treatment1videosIds.length);
    expect(treatment.videosList!.length, treatment1videosIds.length);
    expect(treatment.videosIdsList, treatment1videosIds);

    ExerciseVideo exerciseVideo = treatment.videosList![0];

    expect(exerciseVideo.videoUrl, video1DownloadUrl);
    expect(exerciseVideo.videoSummary, video1Summary);
    expect(exerciseVideo.videoDescription, video1Description);

    response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);

    });

var test2 = test('create another Treatment for the same user', () async {

  ResponseT<bool> response = await service.logIn(systemManagerEmail, systemManagerPass);
    expect(response.errorOccured, false);
    expect(response.val, true);

    response = await service.createTreatment(treatment2CustomerUser,treatment2Name,
     treatment2Description, treatment2videosIds);
     
    expect(response.errorOccured, false);
    expect(response.val, true);

    response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);


    response = await service.logIn(customerUser1Email, customerUser1Pass);
    expect(response.errorOccured, false);
    expect(response.val, true);


    ResponseT<List<Treatment>> response1 = await service.getUserTreatments();
    expect(response1.errorOccured, false);
    expect(response1.val!.length, 2);

    Treatment treatment1 = response1.val![0];
    Treatment treatment2 = response1.val![1];

      if(treatment1.treatmentDescription == treatment2Description){
        Treatment temp = treatment2;
        treatment2 = treatment1;
        treatment1 = temp;
      }

      expect(treatment1.customerUserEmail, treatment1CustomerUser);
      expect(treatment1.treatmentDescription, treatment1Description);
      expect(treatment1.videosIdsList!.length, treatment1videosIds.length);
      expect(treatment1.videosList!.length, treatment1videosIds.length);
      expect(treatment1.videosIdsList, treatment1videosIds);

      ExerciseVideo exerciseVideo1 = treatment1.videosList![0];

      expect(exerciseVideo1.videoUrl, video1DownloadUrl);
      expect(exerciseVideo1.videoSummary, video1Summary);
      expect(exerciseVideo1.videoDescription, video1Description);


      ///////
      expect(treatment2.customerUserEmail, treatment2CustomerUser);
      expect(treatment2.treatmentDescription, treatment2Description);
      expect(treatment2.videosIdsList!.length, treatment2videosIds.length);
      expect(treatment2.videosList!.length, treatment2videosIds.length);
      expect(treatment2.videosIdsList, treatment2videosIds);

    response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);

    });

var test3 = test('other users dont have any treatments yet', () async {

    ResponseT<bool> response = await service.logIn(customerUser2Email, customerUser2Pass);
    expect(response.errorOccured, false);
    expect(response.val, true);


    ResponseT<List<Treatment>> response1 = await service.getUserTreatments();
    expect(response1.errorOccured, false);
    expect(response1.val!.length, 0);

    response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);


    response = await service.logIn(customerUser3Email, customerUser3Pass);
    expect(response.errorOccured, false);
    expect(response.val, true);


    response1 = await service.getUserTreatments();
    expect(response1.errorOccured, false);
    expect(response1.val!.length, 0);

    response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);



    response = await service.logIn(customerUser1Email, customerUser1Pass);
    expect(response.errorOccured, false);
    expect(response.val, true);


    response1 = await service.getUserTreatments();
    expect(response1.errorOccured, false);
    expect(response1.val!.length, 2);

    response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);

});

var test4 = test('create Treatment for other 2 users', () async {

  ResponseT<bool> response = await service.logIn(systemManagerEmail, systemManagerPass);
    expect(response.errorOccured, false);
    expect(response.val, true);

    response = await service.createTreatment(treatment3CustomerUser,treatment3Name,
     treatment3Description, treatment3videosIds);
    expect(response.errorOccured, false);
    expect(response.val, true);


    response = await service.createTreatment(treatment4CustomerUser,treatment4Name,
    treatment4Description, treatment4videosIds);
    expect(response.errorOccured, false);
    expect(response.val, true);

    response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);


    response = await service.logIn(customerUser1Email, customerUser1Pass);
    expect(response.errorOccured, false);
    expect(response.val, true);


    ResponseT<List<Treatment>> response1 = await service.getUserTreatments();
    expect(response1.errorOccured, false);
    expect(response1.val!.length, 2);

    Treatment treatment1 = response1.val![0];
    Treatment treatment2 = response1.val![1];

      if(treatment1.treatmentDescription == treatment2Description){
        Treatment temp = treatment2;
        treatment2 = treatment1;
        treatment1 = temp;
      }

      expect(treatment1.customerUserEmail, treatment1CustomerUser);
      expect(treatment1.videosIdsList, treatment1videosIds);

      ExerciseVideo exerciseVideo1 = treatment1.videosList![0];

      expect(exerciseVideo1.videoUrl, video1DownloadUrl);

      expect(treatment2.videosIdsList, treatment2videosIds);

    response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);




/////////////////////////////////////////////////
    response = await service.logIn(customerUser2Email, customerUser2Pass);
    expect(response.errorOccured, false);
    expect(response.val, true);


    response1 = await service.getUserTreatments();
    expect(response1.errorOccured, false);
    expect(response1.val!.length, 1);

    treatment1 = response1.val![0];

      expect(treatment1.customerUserEmail, treatment3CustomerUser);
      expect(treatment1.treatmentDescription, treatment3Description);
      expect(treatment1.videosIdsList!.length, treatment3videosIds.length);
      expect(treatment1.videosList!.length, treatment3videosIds.length);
      expect(treatment1.videosIdsList, treatment3videosIds);

          response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);


    /////////////////////////////////////////////////
    response = await service.logIn(customerUser3Email, customerUser3Pass);
    expect(response.errorOccured, false);
    expect(response.val, true);


    response1 = await service.getUserTreatments();
    expect(response1.errorOccured, false);
    expect(response1.val!.length, 1);

    treatment1 = response1.val![0];

      expect(treatment1.customerUserEmail, treatment4CustomerUser);
      expect(treatment1.treatmentDescription, treatment4Description);
      expect(treatment1.videosIdsList!.length, treatment4videosIds.length);
      expect(treatment1.videosList!.length, treatment4videosIds.length);
      expect(treatment1.videosIdsList, treatment4videosIds);

          response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);

    });

var test5 = test('get Treatment fails while not logged in', () async {


      ResponseT<List<Treatment>> response1 = await service.getUserTreatments();
    expect(response1.errorOccured, true);

    ResponseT<bool> response = await service.logIn(customerUser2Email, customerUser2Pass);
    expect(response.errorOccured, false);
    expect(response.val, true);


    response1 = await service.getUserTreatments();
    expect(response1.errorOccured, false);
    expect(response1.val!.length, 1);

    response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);


    response1 = await service.getUserTreatments();
    expect(response1.errorOccured, true);

});

var test6 = test('create Treatment with not existing user fail', () async {

  ResponseT<bool> response = await service.logIn(systemManagerEmail, systemManagerPass);
    expect(response.errorOccured, false);
    expect(response.val, true);


    response = await service.createTreatment("${treatment1CustomerUser}extra56",treatment1Name,
     treatment1Description, treatment1videosIds);
     
    expect(response.errorOccured, true);

    response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);


    
    });

var test7 = test('create Treatment with out any video fail', () async {

  ResponseT<bool> response = await service.logIn(systemManagerEmail, systemManagerPass);
    expect(response.errorOccured, false);
    expect(response.val, true);


    response = await service.createTreatment(treatment1CustomerUser,treatment1Name,
     treatment1Description, []);
     
    expect(response.errorOccured, true);

    response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);


    
    });