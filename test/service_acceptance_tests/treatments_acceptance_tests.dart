import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/features/consts.dart';
import 'package:injury_recovery/features/domain/entities/exercise_video.dart';
import 'package:injury_recovery/features/domain/entities/feedback_request.dart';
import 'package:injury_recovery/features/domain/entities/treatment.dart';
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

/////// videos
 const video1DownloadUrl = "https://video1_download_url";
 const video1Summary = "video1 Summary";
 const video1Description = "video1 Description";


 const video2DownloadUrl = "https://video2_download_url";
 const video2Summary = "video2 Summary";
 const video2Description = "video2 Description";



 const video3DownloadUrl = "https://video3_download_url";
 const video3Summary = "video3 Summary";
 const video3Description = "video3 Description";


 const video4DownloadUrl = "https://video4_download_url";
 const video4Summary = "video4 Summary";
 const video4Description = "video4 Description";


/////// treatments
/// 1
 const treatment1CustomerUser = "customer_user_1_test@hotmail.com";
 const treatment1videosIds = [1];
 const treatment1Description = "treatment1Description";

 /// 2
 const treatment2CustomerUser = "customer_user_1_test@hotmail.com";
 const treatment2videosIds = [2,4];
 const treatment2Description = "treatment2Description";


/// 3
 const treatment3CustomerUser = "customer_user_2_test@hotmail.com";
 const treatment3videosIds = [1,3];
 const treatment3Description = "treatment3Description";


/// 4
 const treatment4CustomerUser = "customer_user_3_test@hotmail.com";
 const treatment4videosIds = [1,2,3,4];
 const treatment4Description = "treatment4Description";


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

Future<bool> createExerciseVideosToUseInTreatment() async{

    ResponseT<bool> response = await service.logIn(systemManagerEmail, systemManagerPass);
    expect(response.errorOccured, false);
    expect(response.val, true);

    //1
    response = await service.createExerciseVideo(video1DownloadUrl,video1Summary, video1Description);
    expect(response.errorOccured, false);
    expect(response.val, true);

    //2
    response = await service.createExerciseVideo(video2DownloadUrl,video2Summary, video2Description);
    expect(response.errorOccured, false);
    expect(response.val, true);

    //3
    response = await service.createExerciseVideo(video3DownloadUrl,video3Summary, video3Description);
    expect(response.errorOccured, false);
    expect(response.val, true);

    //4
    response = await service.createExerciseVideo(video1DownloadUrl,video4Summary, video4Description);
    expect(response.errorOccured, false);
    expect(response.val, true);

    response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);
    return true;

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
      await service.cleanCollection(FirestoreTablesNames.exerciseVideos);
      await service.cleanCollection(FirestoreTablesNames.treatments);
      await createExerciseVideosToUseInTreatment();
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

var test1 = test('create Treatment base test', () async {

  ResponseT<bool> response = await service.logIn(systemManagerEmail, systemManagerPass);
    expect(response.errorOccured, false);
    expect(response.val, true);


    response = await service.createTreatment(treatment1CustomerUser,
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

    response = await service.createTreatment(treatment2CustomerUser,
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

var test3 = test('other users dont have anu treatments yet', () async {

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

    response = await service.createTreatment(treatment3CustomerUser,
     treatment3Description, treatment3videosIds);
    expect(response.errorOccured, false);
    expect(response.val, true);


    response = await service.createTreatment(treatment4CustomerUser,
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


    response = await service.createTreatment("${treatment1CustomerUser}extra56",
     treatment1Description, treatment1videosIds);
     
    expect(response.errorOccured, true);

    response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);


    
    });

var test7 = test('create Treatment with out any video  fail', () async {

  ResponseT<bool> response = await service.logIn(systemManagerEmail, systemManagerPass);
    expect(response.errorOccured, false);
    expect(response.val, true);


    response = await service.createTreatment(treatment1CustomerUser,
     treatment1Description, []);
     
    expect(response.errorOccured, true);

    response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);


    
    });