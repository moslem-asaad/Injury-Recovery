import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/components/my_text_field.dart';
import 'package:injury_recovery/features/presentation/views/login_view.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AuthService.firebase().initialize();

  /*testWidgets('login view Test fail email dose not exist',
      (WidgetTester tester) async {
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

    expect(find.text('הדואר האלקטרוני לא רשום'), findsOneWidget);
  });

  testWidgets('login view Test fail wrong password',
      (WidgetTester tester) async {
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
        find.byType(MyTextField).first, 'moslem.asaad2000@gmail.com');
    expect(find.text('moslem.asaad2000@gmail.com'), findsOneWidget);

    expect(find.byType(MyTextField).last, findsOneWidget);

    await tester.enterText(find.byType(MyTextField).last, 'password123');
    expect(find.text('password123'), findsOneWidget);

    expect(find.byType(MyButton), findsOneWidget);

    await tester.tap(find.byType(MyButton));
    await tester.pump();

    expect(find.text('סיסמה לא תואמת'), findsOneWidget);
  });*/

  testWidgets('login view Test success', (WidgetTester tester) async {
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
        find.byType(MyTextField).first, 'moslem.asaad2000@gmail.com');
    expect(find.text('moslem.asaad2000@gmail.com'), findsOneWidget);

    expect(find.byType(MyTextField).last, findsOneWidget);

    await tester.enterText(find.byType(MyTextField).last, '123456');
    expect(find.text('123456'), findsOneWidget);

    expect(find.byType(MyButton), findsOneWidget);

    await tester.tap(find.byType(MyButton));
    await tester.pumpAndSettle();

    //expect(find.byType(const CustomerProfile() as Type), findsOneWidget);

    expect(find.text('הפרופיל שלי'), findsOneWidget);
  });
}
