import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/components/my_text_field.dart';
import 'package:injury_recovery/features/presentation/views/customer/customer_profile.dart';
import 'package:injury_recovery/features/presentation/views/login_view.dart';
import 'package:injury_recovery/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'app test',
    () {
      testWidgets(
        'login senarios',
        (tester) async {
          app.main();

          /*final ctr = find.text('דואר אלקטרוני');
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
*/
          await tester.pumpAndSettle();
         // await tester.tap(find.byType(TextButton).first);
         // await tester.pumpAndSettle();
         // expect(find.text('דואר אלקטרוני'), findsOneWidget);
          await tester.enterText(
              find.byType(MyTextField).first, 'moslem.asaad2000@gmail.com');

          await tester.pumpAndSettle();

          await tester.enterText(find.byType(MyTextField).last, '123456');

          await tester.pumpAndSettle();

          expect(find.byType(MyButton), findsOneWidget);

          await tester.tap(find.byType(MyButton));
          /*await tester.pumpAndSettle();
          expect(find.byType(CustomerProfile), findsOneWidget);*/
          await tester.pumpAndSettle();

          /*await Future.delayed(const Duration(seconds: 2));
          await tester.enterText(find.byType(MyTextField).at(0), 'moslem.asaad2000@gmail.com');
          await Future.delayed(const Duration(seconds: 3));
          await tester.enterText(find.byType(MyTextField).at(1), '123456');
          await Future.delayed(const Duration(seconds: 3));
          await tester.tap(find.byType(ElevatedButton));*/
          //await Future.delayed(const Duration(seconds: 3));
          //await tester.pumpAndSettle();
        },
      );
    },
  );
}
