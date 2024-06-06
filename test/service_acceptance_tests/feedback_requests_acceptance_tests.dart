import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/features/consts.dart';
import 'package:injury_recovery/features/domain/entities/feedback_request.dart';
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
      print("reminder: you need to run register acceptance test first, or call loginAndLogOutSetUp()");
      //await service.cleanCollection(FirestoreTablesNames.exerciseVideos);
      //await service.cleanCollection(FirestoreTablesNames.treatments);
      await service.cleanCollection(FirestoreTablesNames.feedbackRequests);
      //await service.cleanCollection(FirestoreTablesNames.counters);
      //loginAndLogOutSetUp();
      //await createExerciseVideosToUseInTreatment();
      //await createTreatmentsToUseInFeedbackRequests();
  });

  tearDownAll(() async {

      // await service.cleanCollection(FirestoreTablesNames.exerciseVideos);
      // await service.cleanCollection(FirestoreTablesNames.treatments);
      // await service.cleanCollection(FirestoreTablesNames.feedbackRequests);
      // await service.cleanCollection(FirestoreTablesNames.counters);
     
  });


  group('Feedback Requests Acceptance Tests', ()  {

    test1;
    test2;
    test3;
    test4;
    test5;
    test6;
    test7;
    test8;
    test9;

    

  });
}

var test1 = test('create FeedbackRequest base test', () async {

    ResponseT<bool> response = await service.logIn(customerUser1Email, customerUser1Pass);
    expect(response.errorOccured, false);
    expect(response.val, true);


    response = await service.sendFeedbackRequest(feedbackRequest1TreatmentId,
     feedbackRequest1VideoId, feedbackRequest1PerformanceVideoURL, feedbackRequest1Description);
    expect(response.errorOccured, false);
    expect(response.val, true);

    ResponseT<List<FeedbackRequest>> response1 = await service.getTreatmentFeedbackRequests(feedbackRequest1TreatmentId);
    expect(response1.errorOccured, false);
    expect(response1.val!.length, 1); 

    ResponseT<List<FeedbackRequest>> response2 = await service.getMyFeedbackRequests();
    expect(response2.errorOccured, false);
    expect(response2.val!.length, 1); 

    FeedbackRequest feedbackRequest = response2.val![0];
    expect(feedbackRequest.treatmentGlobalId, feedbackRequest1TreatmentId);
    expect(feedbackRequest.exerciseVideoGlobalId, feedbackRequest1VideoId);
    expect(feedbackRequest.performanceVideoDownloadURL, feedbackRequest1PerformanceVideoURL); 
    expect(feedbackRequest.feedbackRequestDescription, feedbackRequest1Description); 
    expect(feedbackRequest.customerUserEmail, customerUser1Email); 
    expect(feedbackRequest.systemManagerResponse, isNull); 
    expect(feedbackRequest.wasResponded(), false); 

    //log out

    response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);


    });


    var test2 = test('responde FeedbackRequest base test', () async {


      ResponseT<bool> response = await service.logIn(systemManagerEmail, systemManagerPass);
      expect(response.errorOccured, false);
      expect(response.val, true);

      response = await service.sendFeedbackResponse(1, feedbackRequest1response);
      expect(response.errorOccured, false);
      expect(response.val, true);

      ResponseT<List<FeedbackRequest>> response1 = await service.getAllUsersFeedbackRequests();
      expect(response1.errorOccured, false);
      expect(response1.val!.length, 1); 

      FeedbackRequest feedbackRequest = response1.val![0];
      expect(feedbackRequest.treatmentGlobalId, feedbackRequest1TreatmentId);
      expect(feedbackRequest.exerciseVideoGlobalId, feedbackRequest1VideoId);
      expect(feedbackRequest.performanceVideoDownloadURL, feedbackRequest1PerformanceVideoURL); 
      expect(feedbackRequest.feedbackRequestDescription, feedbackRequest1Description); 
      expect(feedbackRequest.customerUserEmail, customerUser1Email); 
      expect(feedbackRequest.systemManagerResponse, feedbackRequest1response); 

      response = await service.logout();
      expect(response.errorOccured, false);
      expect(response.val, true);

    /////////////////////////////////////////////////////////////////////////

      response = await service.logIn(customerUser1Email, customerUser1Pass);
      expect(response.errorOccured, false);
      expect(response.val, true);

      ResponseT<List<FeedbackRequest>> response2 = await service.getMyFeedbackRequests();
      expect(response2.errorOccured, false);
      expect(response2.val!.length, 1); 

      FeedbackRequest feedbackRequest1 = response2.val![0];
      expect(feedbackRequest1.systemManagerResponse, feedbackRequest1response); 
      expect(feedbackRequest1.wasResponded(), true); 

      //log out

      response = await service.logout();
      expect(response.errorOccured, false);
      expect(response.val, true);

    });





var test3 = test('create another FeedbackRequest for same user , but different treatment', () async {

    ResponseT<bool> response = await service.logIn(customerUser1Email, customerUser1Pass);
    expect(response.errorOccured, false);
    expect(response.val, true);


    response = await service.sendFeedbackRequest(feedbackRequest2TreatmentId,
     feedbackRequest2VideoId, feedbackRequest2PerformanceVideoURL, feedbackRequest2Description);
    expect(response.errorOccured, false);
    expect(response.val, true);

    ResponseT<List<FeedbackRequest>> response1 = await service.getTreatmentFeedbackRequests(feedbackRequest2TreatmentId);
    expect(response1.errorOccured, false);
    expect(response1.val!.length, 1); 

    ResponseT<List<FeedbackRequest>> response2 = await service.getMyFeedbackRequests();
    expect(response2.errorOccured, false);
    expect(response2.val!.length, 2); 

    FeedbackRequest feedbackRequest = response1.val![0];
    expect(feedbackRequest.treatmentGlobalId, feedbackRequest2TreatmentId);
    expect(feedbackRequest.exerciseVideoGlobalId, feedbackRequest2VideoId);
    expect(feedbackRequest.performanceVideoDownloadURL, feedbackRequest2PerformanceVideoURL); 
    expect(feedbackRequest.feedbackRequestDescription, feedbackRequest2Description); 
    expect(feedbackRequest.customerUserEmail, customerUser1Email); 
    expect(feedbackRequest.systemManagerResponse, isNull); 



    FeedbackRequest feedbackRequest1 = response2.val![0];
    FeedbackRequest feedbackRequest2 = response2.val![1];

    if(feedbackRequest1.feedbackRequestId != 1 && feedbackRequest1.feedbackRequestId == 2 ){
      FeedbackRequest feedbackRequestTemp = feedbackRequest2;
      feedbackRequest2 = feedbackRequest1;
      feedbackRequest1 = feedbackRequestTemp;
    }

    expect(feedbackRequest1.treatmentGlobalId, feedbackRequest1TreatmentId);
    expect(feedbackRequest1.exerciseVideoGlobalId, feedbackRequest1VideoId);
    expect(feedbackRequest1.performanceVideoDownloadURL, feedbackRequest1PerformanceVideoURL); 
    expect(feedbackRequest1.feedbackRequestDescription, feedbackRequest1Description); 
    expect(feedbackRequest1.customerUserEmail, customerUser1Email);


    expect(feedbackRequest2.treatmentGlobalId, feedbackRequest2TreatmentId);
    expect(feedbackRequest2.exerciseVideoGlobalId, feedbackRequest2VideoId);
    expect(feedbackRequest2.performanceVideoDownloadURL, feedbackRequest2PerformanceVideoURL); 
    expect(feedbackRequest2.feedbackRequestDescription, feedbackRequest2Description); 
    expect(feedbackRequest2.customerUserEmail, customerUser1Email); 
    expect(feedbackRequest2.systemManagerResponse, isNull); 


    //log out

    response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);


    });


var test4 = test('create another FeedbackRequest for another user', () async {

    ResponseT<bool> response = await service.logIn(customerUser2Email, customerUser2Pass);
    expect(response.errorOccured, false);
    expect(response.val, true);


    response = await service.sendFeedbackRequest(feedbackRequest3TreatmentId,
     feedbackRequest3VideoId, feedbackRequest3PerformanceVideoURL, feedbackRequest3Description);
    expect(response.errorOccured, false);
    expect(response.val, true);

    ResponseT<List<FeedbackRequest>> response1 = await service.getTreatmentFeedbackRequests(feedbackRequest3TreatmentId);
    expect(response1.errorOccured, false);
    expect(response1.val!.length, 1); 

    ResponseT<List<FeedbackRequest>> response2 = await service.getMyFeedbackRequests();
    expect(response2.errorOccured, false);
    expect(response2.val!.length, 1); 

    FeedbackRequest feedbackRequest = response2.val![0];
    expect(feedbackRequest.treatmentGlobalId, feedbackRequest3TreatmentId);
    expect(feedbackRequest.exerciseVideoGlobalId, feedbackRequest3VideoId);
    expect(feedbackRequest.performanceVideoDownloadURL, feedbackRequest3PerformanceVideoURL); 
    expect(feedbackRequest.feedbackRequestDescription, feedbackRequest3Description); 
    expect(feedbackRequest.customerUserEmail, customerUser2Email); 
    expect(feedbackRequest.systemManagerResponse, isNull); 

    //log out

    response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);

    //log in again as system manager

    response = await service.logIn(systemManagerEmail, systemManagerPass);
    expect(response.errorOccured, false);
    expect(response.val, true);

    ResponseT<List<FeedbackRequest>> response3 = await service.getAllUsersFeedbackRequests();
    expect(response3.errorOccured, false);
    expect(response3.val!.length, 3); 

    //log out
    response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);


    });




    var test5 = test('create FeedbackRequest with not existing treatment - fail', () async {

      ResponseT<bool> response = await service.logIn(customerUser1Email, customerUser1Pass);
      expect(response.errorOccured, false);
      expect(response.val, true);

      response = await service.sendFeedbackRequest(100,
        feedbackRequest1VideoId, feedbackRequest1PerformanceVideoURL, feedbackRequest1Description);
      expect(response.errorOccured, true);



      //log out

      response = await service.logout();
      expect(response.errorOccured, false);
      expect(response.val, true);


    });



    var test6 = test('create FeedbackRequest with not existing video - fail', () async {

      ResponseT<bool> response = await service.logIn(customerUser1Email, customerUser1Pass);
      expect(response.errorOccured, false);
      expect(response.val, true);

      response = await service.sendFeedbackRequest(feedbackRequest1TreatmentId,
        100, feedbackRequest1PerformanceVideoURL, feedbackRequest1Description);
      expect(response.errorOccured, true);

      //log out

      response = await service.logout();
      expect(response.errorOccured, false);
      expect(response.val, true);


    });



  var test7 = test('create FeedbackRequest with not owned treatment - fail', () async {

      ResponseT<bool> response = await service.logIn(customerUser1Email, customerUser1Pass);
      expect(response.errorOccured, false);
      expect(response.val, true);

      response = await service.sendFeedbackRequest(feedbackRequest3TreatmentId,
        feedbackRequest1TreatmentId, feedbackRequest1PerformanceVideoURL, feedbackRequest1Description);
      expect(response.errorOccured, true);

      //log out

      response = await service.logout();
      expect(response.errorOccured, false);
      expect(response.val, true);


    });



        var test8 = test('create FeedbackRequest with a video which is not in treatment - fail', () async {

      ResponseT<bool> response = await service.logIn(customerUser1Email, customerUser1Pass);
      expect(response.errorOccured, false);
      expect(response.val, true);

      response = await service.sendFeedbackRequest(feedbackRequest1TreatmentId,
        feedbackRequest2VideoId, feedbackRequest1PerformanceVideoURL, feedbackRequest1Description);
      expect(response.errorOccured, true);



      //log out

      response = await service.logout();
      expect(response.errorOccured, false);
      expect(response.val, true);


    });



    var test9 = test('create FeedbackRequest with a empty description - fail', () async {

      ResponseT<bool> response = await service.logIn(customerUser1Email, customerUser1Pass);
      expect(response.errorOccured, false);
      expect(response.val, true);

      response = await service.sendFeedbackRequest(feedbackRequest1TreatmentId,
        feedbackRequest1VideoId, feedbackRequest1PerformanceVideoURL, "");
      expect(response.errorOccured, true);



      //log out

      response = await service.logout();
      expect(response.errorOccured, false);
      expect(response.val, true);


    });



