import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/features/presentation/views/customer/treatments.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AuthService.firebase().initialize();

  testWidgets('treatments succsess', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Treatmants()));

    final ctr5 = find.text('הטיפולים שלי');
    expect(ctr5, findsOneWidget);

    final ctr = find.text('התחלת הטיפול');
    expect(ctr, findsOneWidget);

    final c1 = find.byType(BoxDecoration).first;
    final Container containerWidget = tester.firstWidget(c1) as Container;
    expect((containerWidget.decoration as BoxDecoration).color,
        equals(Colors.grey));

    expect(find.byType(MyButton).at(0), findsOneWidget);

    /*await tester.tap(find.byType(MyButton).at(0));
    await tester.pump();*/
  });
}
