import 'package:flutter/material.dart';
import 'package:injury_recovery/constants/routes.dart';
import 'package:injury_recovery/features/presentation/views/customer_profile.dart';
import 'package:injury_recovery/features/presentation/views/treatment_view.dart';
import 'package:injury_recovery/features/presentation/views/treatments.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';
import 'package:injury_recovery/features/presentation/views/gallary_view.dart';
import 'package:injury_recovery/features/presentation/views/login_view.dart';
import 'package:injury_recovery/features/presentation/views/main_view.dart';
import 'package:injury_recovery/features/presentation/views/register_view.dart';
import 'package:injury_recovery/features/presentation/views/reset_password_view.dart';
import 'package:injury_recovery/features/presentation/views/upload_video_view.dart';
import 'package:injury_recovery/features/presentation/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Color.fromARGB(87, 155, 155, 155),
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        mainRoute: (context) => const MainView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        resetPasswordRout: (context) => const ResetPasswordView(),
        uploadVideoRout: (context) => const UploadVideoView(),
        gallaryRout: (context) => const GallaryView(),
        customerProfileRout: (context) => const CustomerProfile(),
        treatmentsRout: (context) => const Treatmants(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                if (user.toString() == 'asaadmoslem2000@gmail.com')
                  return const MainView();
                else
                  return const TreatmentView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
