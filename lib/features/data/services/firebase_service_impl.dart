import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injury_recovery/features/data/services/auth_exceptions.dart';
import 'package:injury_recovery/features/domain/entities/customer_user.dart';
import 'package:injury_recovery/features/domain/entities/exercise_video.dart';
import 'package:injury_recovery/features/domain/entities/feedback_request.dart';
import 'package:injury_recovery/features/domain/entities/system_manager.dart';
import 'package:injury_recovery/features/domain/entities/treatment.dart';
import 'package:injury_recovery/features/domain/entities/user.dart';
import '../../consts.dart';
import '../../domain/entities/category.dart';
// ignore_for_file: avoid_print

class FirebaseServiceImpl{
  static final FirebaseServiceImpl _instance = FirebaseServiceImpl.internalConstructor();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  bool isTestExecution = false;

  void setIsTestExecution(bool flag){
      isTestExecution = flag;
  }

  String getCollectionName(String collectionName){
      String addition = "";
      if(isTestExecution){
        addition = "Test";
      }
      return addition+collectionName;
  }

  FirebaseServiceImpl.internalConstructor();

  factory FirebaseServiceImpl(){
    return _instance;
  }

  Future<String> getCurrentUserId() async{
    return firebaseAuth.currentUser!.uid;
  }

  Future<bool> isLoggedIn() async{
    return firebaseAuth.currentUser?.uid != null;
  }

  Future<User> logIn(String email, String password) async{
    try{

        UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
        if(userCredential.user?.uid != null){
          return await getLoggedInUser();
        }else{

        throw InternalFailureException("logIn: else clasue");
      }
    }on FirebaseAuthException catch (e){

      if (e.code == 'user-not-found'){
        throw ExpectedFailureException('user not found');
      }
      else if (e.code == 'wrong-password'){
        throw ExpectedFailureException('entered password is wrong');
      }else{

      
        throw InternalFailureException("logIn: FirebaseAuthException with unexpected e.code: ${e.code}");
      }
    } catch (e){

      rethrow;
    }
  }

  Future<String> getSystemManagerEmail() async{
    try{
      final systemManagerCollection = firestore.collection(getCollectionName(FirestoreTablesNames.systemManager));
      DocumentSnapshot systemManagerEmailDocument = await systemManagerCollection.doc("1").get();

      if(systemManagerEmailDocument.exists){
        var snapshot = systemManagerEmailDocument.data() as Map<String, dynamic>;
        return snapshot["SystemManagerEmail"];
      }
      else{
        throw InternalFailureException('System Manager email is not defined');
      }
    }on InternalFailureException catch(_){
        rethrow;
    } catch(_){
      print("getSystemManagerEmail 5");
      rethrow;
    }
  }

  Future<User> getLoggedInUser() async{
    try{
      final usersCollection =  firestore.collection(getCollectionName(FirestoreTablesNames.users));
      final userId = await getCurrentUserId();
      DocumentSnapshot userDocument = await usersCollection.doc(userId).get();

      if(userDocument.exists){
        return User.fromSnapshot(userId, userDocument);
      }
      else{
        throw InternalFailureException("logged in user can be found in firebase");
      }
    }on InternalFailureException catch(_){
        rethrow;
    } catch(_){
      print("getLoggedInUser GenericAuthException 1");
      rethrow;
    }
  }

  Future<bool> logOut() async{
    try{
      await FirebaseAuth.instance.signOut();
      return firebaseAuth.currentUser == null;
    }catch (e){
        rethrow;
    }

  }

  Future<bool> register(String email, String password, String firstName, String lastName, String phoneNumber) async{
    try{


      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user?.uid != null){
        String systemManagerEmail = await getSystemManagerEmail();
        User user;
          if(email == systemManagerEmail){
            user = SystemManager("", email, firstName, lastName, phoneNumber);
          }else{
            user = CustomerUser("", email, firstName, lastName, phoneNumber);
          }
        return await createUser(user);
      }
      else{
        throw InternalFailureException("register: register has failed");
      }

    }on FirebaseAuthException catch(e){
      print("register FirebaseAuthException 1");
      if(e.code == 'weak-password'){
        throw ExpectedFailureException("password is weak");
      }else if (e.code == 'email-already-in-use'){
        throw ExpectedFailureException("email already in use");
      } else if (e.code == 'invalid-email'){
        throw ExpectedFailureException("invalid email");
      }else{
        print("register FirebaseAuthException 2");
        print(e.code);
        throw InternalFailureException("register: unexpected FirebaseAuthException e.code");
      }
    }catch(_){
      print("register GenericAuthException 1");
      rethrow;
    }
  }
  
  Future<bool> createUser(User user) async{
    try{
      final usersCollection =  firestore.collection(getCollectionName(FirestoreTablesNames.users));
      final userId = await getCurrentUserId();
      DocumentSnapshot userDocument = await usersCollection.doc(userId).get();

      if(!userDocument.exists){
        usersCollection.doc(userId).set(user.toJson());
        return true;
      }
      else{
        return false;
      }
    }catch(_){
      print("createUser GenericAuthException 1");
      rethrow;
    }
  }

  Future<bool> createCategory(String categoryName, String categoryDescription) async{
    try{
      final categoriesCollection =  firestore.collection(getCollectionName(FirestoreTablesNames.categories));
      DocumentSnapshot categoryDocument = await categoriesCollection.doc(categoryName).get();

      if(!categoryDocument.exists){
        int categoryId = await getCounter(getCollectionName(FirestoreTablesNames.categories));
        Category category = Category(categoryId, categoryName, categoryDescription, ["1","2","3","4"]);
        categoriesCollection.doc(categoryName).set(category.toJson());
        await setCounter(getCollectionName(FirestoreTablesNames.categories), categoryId+1);
        return true;
      }
      else{
        throw ExpectedFailureException("Category name already exists");
      }
    }on ExpectedFailureException catch(_){
      rethrow;
    } catch(e){
      print("createCategory general exception 1");
      rethrow;
    }
  }

  Future<int> getCounter(String counterName) async{
    DocumentSnapshot documentSnapshot =
        await firestore.collection(getCollectionName(FirestoreTablesNames.counters)).doc(counterName).get();

    int counterValue = documentSnapshot.exists ? documentSnapshot['counter'] : 1;
    return counterValue;
  }

  Future<void> setCounter(String counterName, int newCounterValue) async{
    await firestore.collection(getCollectionName(FirestoreTablesNames.counters)).doc(
      counterName).set({'counter': newCounterValue});
  }

  Future<String> uploadVideo(
      String videoURL, String path,Function(double)? onProgress) async {
    Reference ref = firebaseStorage.ref().child('/$path/${DateTime.now()}.mp4');
    UploadTask uploadTask = ref.putFile(File(videoURL));

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = snapshot.bytesTransferred / snapshot.totalBytes;
      onProgress?.call(progress);
    }, onError: (error) {
      // Handle upload error
      print('Error uploading video: $error');
    });
    await uploadTask;
    //await ref.putFile(File(videoURL));
    String downloadURL = await ref.getDownloadURL();
            print('sendFeedbackRequestt downloadURL $downloadURL');

    return downloadURL;
  }

  Future<bool> createExerciseVideo(String videoDownloadURL, String videoSummary, String videoDescription) async {

    try{
      int videoGlobalId = await getCounter(getCollectionName(FirestoreTablesNames.exerciseVideos));
      final videosCollection =  firestore.collection(getCollectionName(FirestoreTablesNames.exerciseVideos));
      DocumentSnapshot videoDocument = await videosCollection.doc(videoGlobalId.toString()).get();

      if(!videoDocument.exists){
        ExerciseVideo exerciseVideo = ExerciseVideo(videoGlobalId, videoDownloadURL, videoSummary,
         videoDescription, "category1Name", 1);

        videosCollection.doc(videoGlobalId.toString()).set(exerciseVideo.toJson());
        await setCounter(getCollectionName(FirestoreTablesNames.exerciseVideos), videoGlobalId+1);
        return true;
      }
      else{
        throw InternalFailureException("createExerciseVideo: video id already exists");
      }
    }on InternalFailureException catch(_){
      rethrow;
    } catch(e){
      print("createExerciseVideo general exception 1");
      rethrow;
    }
  }
  
  Future<List<ExerciseVideo>> getExerciseVideoList(List<int> videosGlobalIds) async{
      List<ExerciseVideo> list = [];
      for(int i=0; i<videosGlobalIds.length; i++){
        list.add(await getExerciseVideoById(videosGlobalIds[i]));
      }
      return list;

      //return List.from(videosGlobalIds.map((int videoId) async {return await getExerciseVideoById(videoId);}));
  }

  Future<ExerciseVideo> getExerciseVideoById(int videoGlobalId) async{
    try{
      final videosCollection =  firestore.collection(getCollectionName(FirestoreTablesNames.exerciseVideos));
      DocumentSnapshot videoDocument = await videosCollection.doc(videoGlobalId.toString()).get();

      if(videoDocument.exists){
        return ExerciseVideo.fromSnapshot(videoDocument);
      }
      else{
        throw InternalFailureException("createExerciseVideo: video id does not exists");
      }
    }on InternalFailureException catch(_){
      rethrow;
    } catch(e){
      print("getExerciseVideoById general exception 1");
      rethrow;
    }
  }

  Future<bool> customerUserExist(String customerUserEmail) async{
    try{
      final usersCollection =  firestore.collection(getCollectionName(FirestoreTablesNames.users));
      QuerySnapshot querySnapshot = await usersCollection.where("email", isEqualTo: customerUserEmail).get();

      if(querySnapshot.docs.isNotEmpty){
        return true;
      }
      else{
        return false;
      }
    } catch(e){
      print("customerUserExist general exception");
      rethrow;
    }
  }

  Future<void> validateCustomerUserExists(String customerUserEmail) async{
    if(! await customerUserExist(customerUserEmail)){
        throw ExpectedFailureException("entered user email does not exist");
    }
  }

  Future<bool> exerciseVideoExist(int exerciseVideoGlobalID) async{
    try{

      final exerciseVideosCollection =  firestore.collection(getCollectionName(FirestoreTablesNames.exerciseVideos));
      DocumentSnapshot videoDocument = await exerciseVideosCollection.doc(exerciseVideoGlobalID.toString()).get();

      if(videoDocument.exists){
        return true;
      }
      else{
        return false;
      }
    } catch(e){
      print("exerciseVideoExist general exception");
      rethrow;
    }
  }

  Future<bool> exerciseVideosExist(List<int> exerciseVideosIds) async{
    for(int exerciseVideoId in exerciseVideosIds){
      if(!await exerciseVideoExist(exerciseVideoId)){
          return false;
      }
    }
    return true;
  }

  Future<void> validateExerciseVideosExist(List<int> exerciseVideosIds) async{
    if(! await exerciseVideosExist(exerciseVideosIds)){
       throw ExpectedFailureException("one or more exercise videos does not exist");
    }
  }

  Future<bool> createTreatment(String customerUserEmail, String treatmentDescription, List<int> exerciseVideosIds) async{
    try{
      await validateCustomerUserExists(customerUserEmail);
      await validateExerciseVideosExist(exerciseVideosIds);

      int treatmentGlobalId = await getCounter(getCollectionName(FirestoreTablesNames.treatments));
      final treatmentsCollection =  firestore.collection(getCollectionName(FirestoreTablesNames.treatments));
      DocumentSnapshot treatmentDocument = await treatmentsCollection.doc(treatmentGlobalId.toString()).get();
      
      if(!treatmentDocument.exists){
        Treatment treatment = Treatment(treatmentGlobalId, treatmentDescription, exerciseVideosIds, customerUserEmail);
        treatmentsCollection.doc(treatmentGlobalId.toString()).set(treatment.toJson());
        await setCounter(getCollectionName(FirestoreTablesNames.treatments), treatmentGlobalId+1);
        return true;
      }
      else{
        throw InternalFailureException("createTreatment: treatment id already exist");
      }
    }catch(e){
      print("createTreatment general exception 1");
      rethrow;
    }
  }

  Future<List<Treatment>> getUserTreatments(String customerUserEmail) async{
    try{
      await validateCustomerUserExists(customerUserEmail);
      final usersCollection =  firestore.collection(getCollectionName(FirestoreTablesNames.treatments));
      QuerySnapshot querySnapshot = await usersCollection.where("customerUserEmail", isEqualTo: customerUserEmail).get();
      if(querySnapshot.docs.isNotEmpty){
        List<Treatment> treatmentList = [];
        for(QueryDocumentSnapshot queryDocumentSnapshot in  querySnapshot.docs){

          treatmentList.add(await Treatment.fromSnapshot(queryDocumentSnapshot).setExerciseVideosList());
        }
        return treatmentList;
      }
      else{
        return [];
      }
    }on ExpectedFailureException catch(_){
      rethrow;
    }catch(e){
        print("getUserTreatments 1");
      rethrow;
    }
  }

  Future<bool> createFeedbackRequest(String customerUserEmail, int treatmentId,
      int videoTreamentId, String? myVideoURL, String description) async {
      try{
        Treatment treatment = await getTreatmentById(treatmentId);
        if(treatment.customerUserEmail != customerUserEmail){
            throw InternalFailureException("current user does not have a treatment with this treatmentId");
        }

        if(!treatment.getvideosIdsList().contains(videoTreamentId)){
            throw InternalFailureException("current treatment does not have a video with this video Id");
        }

        int feedbackRequestId = await getCounter(getCollectionName(FirestoreTablesNames.feedbackRequests));
        final feedbackRequestsCollection =  firestore.collection(getCollectionName(FirestoreTablesNames.feedbackRequests));
        DocumentSnapshot feedbackRequestDocument = await feedbackRequestsCollection.doc(feedbackRequestId.toString()).get(); 


        if(!feedbackRequestDocument.exists){
          FeedbackRequest feedbackRequest = FeedbackRequest(feedbackRequestId, treatmentId, videoTreamentId,
          myVideoURL, description, customerUserEmail, null);
          feedbackRequestsCollection.doc(feedbackRequestId.toString()).set(feedbackRequest.toJson());
          await setCounter(getCollectionName(FirestoreTablesNames.feedbackRequests), feedbackRequestId+1);
          return true;
        }
        else{
          throw InternalFailureException("createFeedbackRequest: feedbackRequestId already exists");
        }
      }on InternalFailureException catch(_){
        rethrow;
      } catch(e){
        print("createFeedbackRequest general exception 1");
        rethrow;
      }
  }

  Future<List<FeedbackRequest>> getTreatmentFeedbackRequests(String customerUserEmail,
   int treatmentId) async{
    try{
        Treatment treatment = await getTreatmentById(treatmentId);
        if(treatment.customerUserEmail != customerUserEmail){
            throw InternalFailureException("current user does not have a treatment with this treatmentId");
        }


      final feedbackRequestsCollection =  firestore.collection(getCollectionName(FirestoreTablesNames.feedbackRequests));
      QuerySnapshot querySnapshot = await feedbackRequestsCollection.where("treatmentGlobalId", isEqualTo: treatmentId).get();

      if(querySnapshot.docs.isNotEmpty){
        List<FeedbackRequest> feedbackRequestsList = [];
        for(QueryDocumentSnapshot queryDocumentSnapshot in  querySnapshot.docs){
          feedbackRequestsList.add(FeedbackRequest.fromSnapshot(queryDocumentSnapshot));
        }
        return feedbackRequestsList;
      }
      else{
        return [];
      }
    }catch(e){
      print("getTreatmentFeedbackRequests general exception");
      rethrow;
    }
  }

  Future<List<FeedbackRequest>> getUserFeedbackRequests(String customerUserEmail) async{
    try{
      final feedbackRequestsCollection =  firestore.collection(getCollectionName(FirestoreTablesNames.feedbackRequests));
      QuerySnapshot querySnapshot = await feedbackRequestsCollection.where("customerUserEmail", isEqualTo: customerUserEmail).get();

      if(querySnapshot.docs.isNotEmpty){
        List<FeedbackRequest> feedbackRequestsList = [];
        for(QueryDocumentSnapshot queryDocumentSnapshot in  querySnapshot.docs){
          feedbackRequestsList.add(FeedbackRequest.fromSnapshot(queryDocumentSnapshot));
        }
        return feedbackRequestsList;
      }
      else{
        return [];
      }
    }catch(e){
      print("getUserFeedbackRequests general exception");
      rethrow;
    }
  }

  Future<List<FeedbackRequest>> getAllUsersFeedbackRequests() async{
    try{
      final feedbackRequestsCollection =  firestore.collection(getCollectionName(FirestoreTablesNames.feedbackRequests));
      QuerySnapshot querySnapshot = await feedbackRequestsCollection.get();

      if(querySnapshot.docs.isNotEmpty){
        List<FeedbackRequest> feedbackRequestsList = [];
        for(QueryDocumentSnapshot queryDocumentSnapshot in  querySnapshot.docs){
          feedbackRequestsList.add(FeedbackRequest.fromSnapshot(queryDocumentSnapshot));
        }
        return feedbackRequestsList;
      }
      else{
        return [];
      }
    }catch(e){
      print("getUserFeedbackRequests general exception");
      rethrow;
    }
  }

  Future<FeedbackRequest> getFeedbackRequestbyId(int feedbackRequestId) async{
    try{
      final feedbackRequestCollection =  firestore.collection(getCollectionName(FirestoreTablesNames.feedbackRequests));
      DocumentSnapshot feedbackRequestDocument = await feedbackRequestCollection.doc(feedbackRequestId.toString()).get();

      if(feedbackRequestDocument.exists){
        return FeedbackRequest.fromSnapshot(feedbackRequestDocument);
      }
      else{
        throw InternalFailureException("getFeedbackRequest: feedbackRequestId does not exists");
      }
    }on InternalFailureException catch(_){
      rethrow;
    } catch(e){
      print("getFeedbackRequest general exception 1");
      rethrow;
    }
  }

  Future<bool> sendFeedbackResponse(int feedbackId, String response) async {
    try{
      FeedbackRequest feedbackRequest = await getFeedbackRequestbyId(feedbackId);
      if(feedbackRequest.wasResponded()){
        throw ExpectedFailureException("Feedback request was already responded");
      }
      feedbackRequest.setSystemManagerResponse(response);
      updateFeedbackRequest(feedbackRequest);
      return true;
    }on InternalFailureException catch(_){
      rethrow;
    } catch(e){
      print("sendFeedbackResponse general exception 1");
      rethrow;
    }
  }

  Future<bool> updateFeedbackRequest(FeedbackRequest feedbackRequest) async {
    try{
      final feedbackRequestsCollection =  firestore.collection(getCollectionName(FirestoreTablesNames.feedbackRequests));
      DocumentSnapshot feedbackRequestDocument = await feedbackRequestsCollection.doc(feedbackRequest.getFeedbackRequestId().toString()).get(); 

      if(feedbackRequestDocument.exists){
        feedbackRequestsCollection.doc(feedbackRequest.getFeedbackRequestId().toString()).update(feedbackRequest.toJson());
        return true;
      }
      else{
        throw InternalFailureException("updateFeedbackRequest: feedbackRequestId does not exists");
      }
    }on InternalFailureException catch(_){
      rethrow;
    } catch(e){
      print("updateFeedbackRequest general exception 1");
      rethrow;
    }
  }

  Future<List<User>> getAllUsers() async{
    try{
      final usersCollection =  firestore.collection(getCollectionName(FirestoreTablesNames.users));
    
      QuerySnapshot querySnapshot = await usersCollection.get();

      if(querySnapshot.docs.isNotEmpty){
        List<User> usersList = [];
        for(QueryDocumentSnapshot queryDocumentSnapshot in  querySnapshot.docs){
          usersList.add(User.fromSnapshotWithoutId(queryDocumentSnapshot));
        }
        return usersList;
      }
      else{
        return [];
      }
    }catch(e){
      print("getAllUsers general exception");
      rethrow;
    }
  }

  Future<List<ExerciseVideo>> getAllExerciseVideos() async{
    try{
      final exerciseVideosCollection =  firestore.collection(getCollectionName(FirestoreTablesNames.exerciseVideos));
      QuerySnapshot querySnapshot = await exerciseVideosCollection.get();

      if(querySnapshot.docs.isNotEmpty){
        List<ExerciseVideo> exerciseVideos = [];
        for(QueryDocumentSnapshot queryDocumentSnapshot in  querySnapshot.docs){
          exerciseVideos.add(ExerciseVideo.fromSnapshot(queryDocumentSnapshot));
        }
        return exerciseVideos;
      }
      else{
        return [];
      }
    }catch(e){
      print("getAllExerciseVideos general exception");
      rethrow;
    }
  }

  Future<Treatment> getTreatmentById(int treatmentId) async{
    try{
      final treatmentsCollection =  firestore.collection(getCollectionName(FirestoreTablesNames.treatments));
      DocumentSnapshot treatmentDocument = await treatmentsCollection.doc(treatmentId.toString()).get();

      if(treatmentDocument.exists){
        return await Treatment.fromSnapshot(treatmentDocument).setExerciseVideosList();
      }
      else{
        throw InternalFailureException("getTreatmentById: treatmentId does not exists");
      }
    }on InternalFailureException catch(_){
      rethrow;
    } catch(e){
      print("getTreatmentById general exception 1");
      rethrow;
    }
  }

  Future<bool> cleanCollection(String collectionName) async{
    try{
      final collection =  firestore.collection(getCollectionName(collectionName));
      QuerySnapshot querySnapshot = await collection.get();

      if(querySnapshot.docs.isNotEmpty){
        for(QueryDocumentSnapshot queryDocumentSnapshot in  querySnapshot.docs){

           await queryDocumentSnapshot.reference.delete();
        }
      }

      final countersCollection =  firestore.collection(getCollectionName(FirestoreTablesNames.counters));
      DocumentSnapshot collectionDocument = await countersCollection.doc(getCollectionName(collectionName)).get();
      if(collectionDocument.exists){
         await collectionDocument.reference.delete();
      }
      return true;
    }catch(e){
      print("cleanCollection general exception");
      rethrow;
    }
  }
  


///////



}