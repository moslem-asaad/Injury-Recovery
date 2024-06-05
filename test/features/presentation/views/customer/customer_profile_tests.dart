import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/constants/colors.dart';
import 'package:injury_recovery/features/presentation/views/customer/customer_profile.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AuthService.firebase().initialize();

  testWidgets('customer profile Test succses', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CustomerProfile()));

    final ctr5 = find.text('ברוך הבא');
    expect(ctr5, findsOneWidget);

    final ctr = find.text('הבקשות שלי');
    expect(ctr, findsOneWidget);

    final ctr1 = find.text('1הבקשות שלי');
    expect(ctr1, findsNothing);

    final ctr2 = find.text('הטיפולים שלי');
    expect(ctr2, findsOneWidget);

    final ctr3 = find.text('1הטיפולים שלי');
    expect(ctr3, findsOneWidget);

    final c1 = find.byType(MyButton).first;
    final Container containerWidget = tester.firstWidget(c1) as Container;
    expect(
        (containerWidget.decoration as BoxDecoration).color, equals(my_blue));

    final c2 = find.byType(MyButton).first;
    final Container containerWidget2 = tester.firstWidget(c2) as Container;
    expect(
        (containerWidget2.decoration as BoxDecoration).color, equals(my_green));
  });
}
