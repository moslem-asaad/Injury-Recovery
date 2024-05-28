import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/components/my_text_field.dart';
import 'package:injury_recovery/features/presentation/views/register_view.dart';

void main() {
  /*setUpAll(() async {
    // Ensure Firebase is initialized before running tests
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });*/

  testWidgets('Register Page Test - Successful Registration',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterView()));

    final ctr = find.text('יצירת החשבון שלך ');
    expect(ctr, findsOneWidget);

    final ctr1 = find.text('שם פרטי ');
    expect(ctr1, findsOneWidget);

    final ctr2 = find.text('שם משפחה');
    expect(ctr2, findsOneWidget);

    final ctr3 = find.text('מספר טלפון');
    expect(ctr3, findsOneWidget);

    final ctr4 = find.text('דואר אלקטרוני');
    expect(ctr4, findsOneWidget);

    final ctr5 = find.text('סיסמה');
    expect(ctr5, findsOneWidget);

    final ctr6 = find.text('אישור סיסמה');
    expect(ctr6, findsOneWidget);

    expect(find.byType(MyTextField).at(0), findsOneWidget);

    expect(find.byType(MyTextField).at(1), findsOneWidget);

    expect(find.byType(MyTextField).at(2), findsOneWidget);

    expect(find.byType(MyTextField).at(3), findsOneWidget);

    expect(find.byType(MyTextField).at(4), findsOneWidget);

    expect(find.byType(MyTextField).at(5), findsOneWidget);

    expect(find.byType(MyButton), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'haitam');
    expect(find.text('haitam'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(1), 'assadi');
    expect(find.text('assadi'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(2), '0549323444');
    expect(find.text('0549323444'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(3), 'haitam890@gmail.com');
    expect(find.text('haitam890@gmail.com'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(4), 'password123');
    expect(find.text('password123'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(5), 'password123');
    expect(find.text('password123'), findsExactly(2));

    //await tester.tap(find.text('הרשמה'));
    //await tester.pump();
  });

  testWidgets('Register Page Test - Password Mismatch',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterView()));

    final ctr = find.text('יצירת החשבון שלך ');
    expect(ctr, findsOneWidget);

    final ctr1 = find.text('שם פרטי ');
    expect(ctr1, findsOneWidget);

    final ctr2 = find.text('שם משפחה');
    expect(ctr2, findsOneWidget);

    final ctr3 = find.text('מספר טלפון');
    expect(ctr3, findsOneWidget);

    final ctr4 = find.text('דואר אלקטרוני');
    expect(ctr4, findsOneWidget);

    final ctr5 = find.text('סיסמה');
    expect(ctr5, findsOneWidget);

    final ctr6 = find.text('אישור סיסמה');
    expect(ctr6, findsOneWidget);

    expect(find.byType(MyTextField).at(0), findsOneWidget);

    expect(find.byType(MyTextField).at(1), findsOneWidget);

    expect(find.byType(MyTextField).at(2), findsOneWidget);

    expect(find.byType(MyTextField).at(3), findsOneWidget);

    expect(find.byType(MyTextField).at(4), findsOneWidget);

    expect(find.byType(MyTextField).at(5), findsOneWidget);

    expect(find.byType(MyButton), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'haitam');
    expect(find.text('haitam'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(1), 'assadi');
    expect(find.text('assadi'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(2), '0549323444');
    expect(find.text('0549323444'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(3), 'haitam890@gmail.com');
    expect(find.text('haitam890@gmail.com'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(4), 'password123');
    expect(find.text('password123'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(5), 'password456');
    expect(find.text('password456'), findsOneWidget);

    //await tester.tap(find.text('הרשמה'));
    //await tester.pump();
  });
}
