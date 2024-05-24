import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injury_recovery/features/data/services/auth_exceptions.dart';
import 'package:injury_recovery/features/domain/entities/customer_user.dart';
import 'package:injury_recovery/features/domain/entities/exercise_video.dart';
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
        throw UserNotLoggedInAuthException();
      }

    }on FirebaseAuthException catch (e){
      if (e.code == 'user-not-found'){
        throw UserNotFoundAuthException();
      }
      else if (e.code == 'wrong-password'){
        throw WrongPasswordAuthException();
      }else{
        throw GenericAuthException();
      }
    } catch (_){
        throw GenericAuthException();
    }
  }


  Future<String> getSystemManagerEmail() async{
    try{
      print("getSystemManagerEmail 1");
      final systemManagerCollection =  firestore.collection(FirestoreTablesNames.systemManager);
      DocumentSnapshot systemManagerEmailDocument = await systemManagerCollection.doc("1").get();
      print("getSystemManagerEmail 2");
      if(systemManagerEmailDocument.exists){
        print("getSystemManagerEmail 3");
        var snapshot = systemManagerEmailDocument.data() as Map<String, dynamic>;
        return snapshot["SystemManagerEmail"];
      }
      else{
        print("getSystemManagerEmail 4");
        throw SystemManagerEmailIsNotDefined();
      }
    }on SystemManagerEmailIsNotDefined catch(_){
        rethrow;
    } catch(_){
      print("getSystemManagerEmail 5");
      throw GenericAuthException();
    }
  }


  Future<User> getLoggedInUser() async{
    try{
      final usersCollection =  firestore.collection(FirestoreTablesNames.users);
      final userId = await getCurrentUserId();
      DocumentSnapshot userDocument = await usersCollection.doc(userId).get();

      if(userDocument.exists){
        return User.fromSnapshot(userId, userDocument);
      }
      else{
        throw UserNotFoundAuthException();
      }
    }on UserNotFoundAuthException catch(e){
        rethrow;
    } catch(_){
      print("getLoggedInUser GenericAuthException 1");
      throw GenericAuthException();
    }
  }

  Future<bool> logOut() async{
    try{
      await FirebaseAuth.instance.signOut();
      return firebaseAuth.currentUser == null;
    }catch (e){
        throw GenericAuthException();
    }

  }

  Future<bool> register(String email, String password, String firstName, String lastName, String phoneNumber) async{
    try{
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user?.uid != null){
        print("register 1");
        String systemManagerEmail = await getSystemManagerEmail();
        print("register 2");
        User user;
          if(email == systemManagerEmail){
            print("register 3");
            user = SystemManager("", email, firstName, lastName, phoneNumber);
          }else{
            print("register 4");
            user = CustomerUser("", email, firstName, lastName, phoneNumber);
          }
        return await createUser(user);
      }
      else{
        throw RegisterFailedException();
      }

    }on FirebaseAuthException catch(e){
      print("register FirebaseAuthException 1");
      if(e.code == 'weak-password'){
        throw WeakPasswordAuthException();
      }else if (e.code == 'email-already-in-use'){
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email'){
        throw InvalidEmailAuthException();
      }else{
        print("register FirebaseAuthException 2");
        print(e.code);
        throw GenericAuthException();
      }
    }catch(_){
      print("register GenericAuthException 1");
      throw GenericAuthException();
    }
  }
  
  Future<bool> createUser(User user) async{
    try{
      final usersCollection =  firestore.collection(FirestoreTablesNames.users);
      final userId = await getCurrentUserId();
      DocumentSnapshot userDocument = await usersCollection.doc(userId).get();

      if(!userDocument.exists){
        print("createUser 1");
        usersCollection.doc(userId).set(user.toJson());
        return true;
      }
      else{
        return false;
      }
    }catch(_){
      print("createUser GenericAuthException 1");
      throw GenericAuthException();
    }
  }



  Future<bool> createCategory(String categoryName, String categoryDescription) async{
    try{
      final categoriesCollection =  firestore.collection(FirestoreTablesNames.categories);
      DocumentSnapshot categoryDocument = await categoriesCollection.doc(categoryName).get();

      if(!categoryDocument.exists){
        print("createCategory 1");
        int categoryId = await getCounter(FirestoreTablesNames.categories);
        Category category = Category(categoryId, categoryName, categoryDescription, ["1","2","3","4"]);
        categoriesCollection.doc(categoryName).set(category.toJson());
        await setCounter(FirestoreTablesNames.categories, categoryId+1);
        return true;
      }
      else{
        throw CategoryAlreadyExistException();
      }
    }on CategoryAlreadyExistException catch(_){
      rethrow;
    } catch(e){
      print("createCategory general exception 1");
      rethrow;
    }
  }

  Future<int> getCounter(String counterName) async{
    DocumentSnapshot documentSnapshot =
        await firestore.collection(FirestoreTablesNames.counters).doc(counterName).get();

    int counterValue = documentSnapshot.exists ? documentSnapshot['counter'] : 1;
    return counterValue;
  }

  Future<void> setCounter(String counterName, int newCounterValue) async{
    await firestore.collection(FirestoreTablesNames.counters).doc(
      counterName).set({'counter': newCounterValue});
  }

  Future<String> uploadVideo(
      String videoURL, Function(double)? onProgress) async {
    Reference ref = firebaseStorage.ref().child('/videos/${DateTime.now()}.mp4');
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
    return downloadURL;
  }

  Future<bool> createExerciseVideo(String videoDownloadURL, String videoSummary, String videoDescription) async {

    try{
      int videoGlobalId = await getCounter(FirestoreTablesNames.exerciseVideos);
      final videosCollection =  firestore.collection(FirestoreTablesNames.exerciseVideos);
      DocumentSnapshot videoDocument = await videosCollection.doc(videoGlobalId.toString()).get();

      if(!videoDocument.exists){
        ExerciseVideo exerciseVideo = ExerciseVideo(videoGlobalId, videoDownloadURL, videoSummary, videoDescription, "category1Name", 1);
        videosCollection.doc(videoGlobalId.toString()).set(exerciseVideo.toJson());
        await setCounter(FirestoreTablesNames.exerciseVideos, videoGlobalId+1);
        return true;
      }
      else{
        throw VideoAlreadyExistException();
      }
    }on VideoAlreadyExistException catch(_){
      rethrow;
    } catch(e){
      print("createExerciseVideo general exception 1");
      rethrow;
    }
  }


  Future<List<ExerciseVideo>> getExerciseVideoList(List<int> videosGlobalIds) async{
      return List.from(videosGlobalIds.map((int videoId) async {return await getExerciseVideoById(videoId);}));
  }

  Future<ExerciseVideo> getExerciseVideoById(int videoGlobalId) async{
    try{
      final videosCollection =  firestore.collection(FirestoreTablesNames.exerciseVideos);
      DocumentSnapshot videoDocument = await videosCollection.doc(videoGlobalId.toString()).get();

      if(videoDocument.exists){
        return ExerciseVideo.fromSnapshot(videoDocument);
      }
      else{
        throw VideoDoesNotExistException();
      }
    }on VideoDoesNotExistException catch(_){
      rethrow;
    } catch(e){
      print("getExerciseVideoById general exception 1");
      rethrow;
    }
  }


  Future<bool> customerUserExist(String customerUserEmail) async{
    try{
      final usersCollection =  firestore.collection(FirestoreTablesNames.users);
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
        throw CustomerUserDoesNotExistException();
    }
  }

  Future<bool> exerciseVideoExist(int exerciseVideoGlobalID) async{
    try{

      final exerciseVideosCollection =  firestore.collection(FirestoreTablesNames.exerciseVideos);
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
        throw OneOrMoreExerciseVideoDoesNotExistException();
    }
  }


  Future<bool> createTreatment(String customerUserEmail, String treatmentDescription, List<int> exerciseVideosIds) async{
    try{
      print("createTreatment 1");
      validateCustomerUserExists(customerUserEmail);
      print("createTreatment 2");
      validateExerciseVideosExist(exerciseVideosIds);
      print("createTreatment 3");

      int treatmentGlobalId = await getCounter(FirestoreTablesNames.treatments);
      final treatmentsCollection =  firestore.collection(FirestoreTablesNames.treatments);
      DocumentSnapshot treatmentDocument = await treatmentsCollection.doc(treatmentGlobalId.toString()).get();

      print("createTreatment 4");
      if(!treatmentDocument.exists){
        print("createTreatment 5");
        Treatment treatment = Treatment(treatmentGlobalId, treatmentDescription, exerciseVideosIds, customerUserEmail);
        treatmentsCollection.doc(treatmentGlobalId.toString()).set(treatment.toJson());
        await setCounter(FirestoreTablesNames.treatments, treatmentGlobalId+1);
        return true;
      }
      else{
        print("createTreatment 6");
        throw TreatmentAlreadyExistException();
      }
    }on OneOrMoreExerciseVideoDoesNotExistException catch(_){
      rethrow;
    }on CustomerUserDoesNotExistException catch(_){
      rethrow;
    } catch(e){
      print("createTreatment general exception 1");
      rethrow;
    }
  }


  Future<List<Treatment>> getUserTreatments(String customerUserEmail) async{
    try{
      print("getUserTreatments 1");
      validateCustomerUserExists(customerUserEmail);
      print("getUserTreatments 2");
      final usersCollection =  firestore.collection(FirestoreTablesNames.treatments);
      print("getUserTreatments 3");
      QuerySnapshot querySnapshot = await usersCollection.where("customerUserEmail", isEqualTo: customerUserEmail).get();

      print("getUserTreatments 4");
      if(querySnapshot.docs.isNotEmpty){
        print("getUserTreatments 5");
        List<Treatment> treatmentList = [];
        print("getUserTreatments 51");
        for(QueryDocumentSnapshot queryDocumentSnapshot in  querySnapshot.docs){
          treatmentList.add(Treatment.fromSnapshot(queryDocumentSnapshot));
        }
        print("getUserTreatments 52");
        return treatmentList;
      }
      else{
        print("getUserTreatments 6");
        return [];
      }
    }on CustomerUserDoesNotExistException catch(_){
      rethrow;
    }catch(e){
      print("getUserTreatments general exception");
      rethrow;
    }
  }





}