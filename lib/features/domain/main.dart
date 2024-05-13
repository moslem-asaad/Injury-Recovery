import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:injury_recovery/features/domain/entities/customer_user.dart';
import 'package:injury_recovery/firebase_options.dart';

import '../data/services/firebase_service_impl.dart';


Future<void> main() async {
  var a = CustomerUser("", "newemail11@hotmail.com", "dsklfhJ345ds", "", "", "");
  print("heree1");
  // ignore: avoid_print
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
print("here2");

var service = FirebaseServiceImpl(firestore: FirebaseFirestore.instance, firebaseAuth: FirebaseAuth.instance);
service.register(a);
}