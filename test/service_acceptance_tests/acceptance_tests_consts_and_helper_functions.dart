import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/features/presentation/services/response.dart';
import 'package:injury_recovery/features/presentation/services/service_layer.dart';


// Users
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

 

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// Videos
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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///// Treatments
///
/// 1
 const treatment1CustomerUser = "customer_user_1_test@hotmail.com";
 const treatment1videosIds = [1];
 const treatment1Description = "treatment1Description";
 const treatment1Name = "treatment1Name";

 /// 2
 const treatment2CustomerUser = "customer_user_1_test@hotmail.com";
 const treatment2videosIds = [2,4];
 const treatment2Description = "treatment2Description";
 const treatment2Name = "treatment2Name";


/// 3
 const treatment3CustomerUser = "customer_user_2_test@hotmail.com";
 const treatment3videosIds = [1,3];
 const treatment3Description = "treatment3Description";
 const treatment3Name = "treatment3Name";


/// 4
 const treatment4CustomerUser = "customer_user_3_test@hotmail.com";
 const treatment4videosIds = [1,2,3,4];
 const treatment4Description = "treatment4Description";
 const treatment4Name = "treatment4Name";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///// Feedback Requests
///
/// 1
/// 


 const feedbackRequest1TreatmentId = 1 ;
 const feedbackRequest1VideoId = 1;
 const feedbackRequest1PerformanceVideoURL = "https://performance_video1_download_url";
 const feedbackRequest1Description = "feedbackRequest1Description";
const feedbackRequest1response = "feedbackRequest1response";


 const feedbackRequest2TreatmentId = 2 ;
 const feedbackRequest2VideoId = 4;
 const feedbackRequest2PerformanceVideoURL = "https://performance_video2_download_url";
 const feedbackRequest2Description = "feedbackRequest2Description";


 const feedbackRequest3TreatmentId = 3 ;
 const feedbackRequest3VideoId = 3;
 const feedbackRequest3PerformanceVideoURL = "https://performance_video3_download_url";
 const feedbackRequest3Description = "feedbackRequest3Description";


 const feedbackRequest4TreatmentId = 4 ;
 const feedbackRequest4VideoId = 3;
 const feedbackRequest4PerformanceVideoURL = "https://performance_video4_download_url";
 const feedbackRequest4Description = "feedbackRequest4Description";




Service service = Service();

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




Future<bool> createTreatmentsToUseInFeedbackRequests() async{

    ResponseT<bool> response = await service.logIn(systemManagerEmail, systemManagerPass);
    expect(response.errorOccured, false);
    expect(response.val, true);

    //1
    response = await service.createTreatment(treatment1CustomerUser,treatment1Name,
    treatment1Description, treatment1videosIds);
     
    expect(response.errorOccured, false);
    expect(response.val, true);

    //2
    response = await service.createTreatment(treatment2CustomerUser,treatment2Name,
    treatment2Description, treatment2videosIds);
     
    expect(response.errorOccured, false);
    expect(response.val, true);

    //3

    response = await service.createTreatment(treatment3CustomerUser,treatment3Name,
    treatment3Description, treatment3videosIds);
    expect(response.errorOccured, false);
    expect(response.val, true);

    //4
    response = await service.createTreatment(treatment4CustomerUser,treatment4Name,
    treatment4Description, treatment4videosIds);
    expect(response.errorOccured, false);
    expect(response.val, true);


    response = await service.logout();
    expect(response.errorOccured, false);
    expect(response.val, true);
    return true;

}