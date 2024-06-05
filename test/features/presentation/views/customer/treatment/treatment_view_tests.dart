import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/features/presentation/views/customer/treatment/treatment_view.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AuthService.firebase().initialize();

  testWidgets('treatment view test success', (WidgetTester tester) async {
    //  await tester.pumpWidget(MaterialApp(home: TreatmentView()));
  });
}
