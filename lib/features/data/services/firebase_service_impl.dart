import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:injury_recovery/features/data/services/auth_exceptions.dart';
import 'package:injury_recovery/features/domain/entities/customer_user.dart';
import 'package:injury_recovery/features/domain/entities/user.dart';
import '../../consts.dart';
import '../../domain/services/firebase_service.dart';

class FirebaseServiceImpl implements FirebaseService{
  FirebaseFirestore firestore;
  FirebaseAuth firebaseAuth;

  FirebaseServiceImpl({required this.firestore,required this.firebaseAuth});

  @override
  Future<String> getCurrentUserId() async{
    return firebaseAuth.currentUser!.uid;
  }

  @override
  Future<bool> isLoggedIn() async{
    return firebaseAuth.currentUser?.uid != null;
  }

  @override
  Future<void> logIn(User user) async{
    try{
        UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: user.email, password: user.password);
        if(userCredential.user?.uid != null){
          return;
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

  @override
  Future<void> logOut() async{
    try{
      await FirebaseAuth.instance.signOut();
    }catch (_){
        throw GenericAuthException();
    }

  }

  @override
  Future<void> register(CustomerUser customerUser) async{
    try{
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: customerUser.email, password: customerUser.password);
      if (userCredential.user?.uid != null){
        await createUser(customerUser);
      }
      else{
        throw RegisterFailedException();
      }

    }on FirebaseAuthException catch(e){
      print("here1111");
      if(e.code == 'weak-password'){
        throw WeakPasswordAuthException();
      }else if (e.code == 'email-already-in-use'){
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email'){
        throw InvalidEmailAuthException();
      }else{
        throw GenericAuthException();
      }
    }catch(_){
      print("here2222");
      throw GenericAuthException();
    }
  }
  
  @override
  Future<void> createUser(CustomerUser customerUser) async{
    try{
      final usersCollection =  firestore.collection(FirestoreTablesNames.users);
      final userId = await getCurrentUserId();
      DocumentSnapshot userDocument = await usersCollection.doc(userId).get();

      if(userDocument.exists){
        usersCollection.doc(userId).set(customerUser.toJson());
      }
      else{
        //TODO: do we need to update in this case or throw exception ??
        usersCollection.doc(userId).update(customerUser.toJson());
      }
    }catch(_){
      throw GenericAuthException();
    }
  }



}