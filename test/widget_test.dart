// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/features/data/services/firebase_service_impl.dart';
import 'package:injury_recovery/features/domain/entities/customer_user.dart';
import 'package:injury_recovery/firebase_options.dart';

import 'package:injury_recovery/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {


    var a = CustomerUser("", "newemail11@hotmail.com", "dsklfhJ345ds", "", "", "");
    print("heree1");
    // ignore: avoid_print
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);
    print("here2");

    var service = FirebaseServiceImpl(firestore: FirebaseFirestore.instance, firebaseAuth: FirebaseAuth.instance);
    service.register(a);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const HomePage());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
