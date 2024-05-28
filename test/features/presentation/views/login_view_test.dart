import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/components/my_text_field.dart';
import 'package:injury_recovery/features/presentation/views/login_view.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';

void main() {
  setUpAll(() async {
    // Ensure Firebase is initialized before running tests
    TestWidgetsFlutterBinding.ensureInitialized();
    await AuthService.firebase().initialize();
  });

  testWidgets('login view Test succses', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginView()));

    final ctr = find.text('דואר אלקטרוני');
    expect(ctr, findsOneWidget);

    final ctr1 = find.text('1דואר אלקטרוני');
    expect(ctr1, findsNothing);

    final ctr2 = find.text('סיסמה');
    expect(ctr2, findsOneWidget);

    final ctr3 = find.text('1סיסמה');
    expect(ctr3, findsNothing);

    expect(find.byType(MyTextField).first, findsOneWidget);

    await tester.enterText(
        find.byType(MyTextField).first, 'haitam890@gmail.com');
    expect(find.text('haitam890@gmail.com'), findsOneWidget);

    expect(find.byType(MyTextField).last, findsOneWidget);

    await tester.enterText(find.byType(MyTextField).last, 'password123');
    expect(find.text('password123'), findsOneWidget);

    expect(find.byType(MyButton), findsOneWidget);

    await tester.tap(find.byType(MyButton));
    await tester.pump();
  });

  testWidgets('login view Test fail', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginView()));

    final ctr = find.text('דואר אלקטרוני');
    expect(ctr, findsOneWidget);

    final ctr1 = find.text('1דואר אלקטרוני');
    expect(ctr1, findsNothing);

    final ctr2 = find.text('סיסמה');
    expect(ctr2, findsOneWidget);

    final ctr3 = find.text('1סיסמה');
    expect(ctr3, findsNothing);

    expect(find.byType(MyTextField).first, findsOneWidget);

    await tester.enterText(find.byType(MyTextField).first, 'love@gmail.com');
    expect(find.text('love@gmail.com'), findsOneWidget);

    expect(find.byType(MyTextField).last, findsOneWidget);

    await tester.enterText(find.byType(MyTextField).last, 'password123');
    expect(find.text('password123'), findsOneWidget);

    expect(find.byType(MyButton), findsOneWidget);

    await tester.tap(find.byType(MyButton));
    await tester.pump();
  });
}
