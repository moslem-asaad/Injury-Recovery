import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/features/presentation/views/customer/customer_profile.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';

void main() {
  /*setUpAll(() async {
    // Ensure Firebase is initialized before running tests
    TestWidgetsFlutterBinding.ensureInitialized();
    await AuthService.firebase().initialize();
  });*/
  testWidgets('customer profile Test succses', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CustomerProfile()));

    final ctr = find.text('הבקשות שלי');
    expect(ctr, findsOneWidget);

    final ctr1 = find.text('1הבקשות שלי');
    expect(ctr1, findsNothing);

    final ctr2 = find.text('הטיפולים שלי');
    expect(ctr2, findsOneWidget);

    final ctr3 = find.text('1הטיפולים שלי');
    expect(ctr3, findsOneWidget);

    expect(find.byType(MyButton).first, findsOneWidget);

    expect(find.byType(MyButton).last, findsOneWidget);
  });
}
