import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injury_recovery/features/presentation/services/service_layer.dart';
import 'package:injury_recovery/firebase_options.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';
import 'package:integration_test/integration_test.dart';
import 'package:injury_recovery/main.dart' as app;

late Service service;

void main() async{
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await AuthService.firebase().initialize();
  Service service = Service();
   service.setIsTestExecution(true);
  setUpAll(() async {
    
   
  });

  testWidgets('Simulate multiple users', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Simulate 50 users logging in concurrently
    List<Future> loginFutures = [];
    for (int i = 0; i < 50; i++) {
      loginFutures.add(service.logIn('testuser$i@example.com', 'testpassword'));
    }

    await Future.wait(loginFutures);
  });
}

