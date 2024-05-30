import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:injury_recovery/constants/routes.dart';
import 'package:injury_recovery/features/presentation/services/service_layer.dart';
import 'package:injury_recovery/features/presentation/views/customer/customer_profile.dart';
import 'package:injury_recovery/features/presentation/views/customer/treatments.dart';
import 'package:injury_recovery/features/presentation/views/system_manager/create_treatment.dart';
import 'package:injury_recovery/features/presentation/views/system_manager/upload_video_view.dart';
import 'package:injury_recovery/features/presentation/views/system_manager/users_feedbacks.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';
import 'package:injury_recovery/features/presentation/views/gallary_view.dart';
import 'package:injury_recovery/features/presentation/views/login_view.dart';
import 'package:injury_recovery/features/presentation/views/system_manager/main_view.dart';
import 'package:injury_recovery/features/presentation/views/register_view.dart';
import 'package:injury_recovery/features/presentation/views/reset_password_view.dart';
import 'package:injury_recovery/features/presentation/views/verify_email_view.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        //scaffoldBackgroundColor: Color.fromARGB(87, 155, 155, 155),
      ),
      home: const HomePage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('he'), Locale('en')],
      locale: Locale('he', ''),
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
        createTreatmentRoute: (context) => const CreateTreatments(),
        usersFeedbacksRout:(context) => const UsersFeedbacksView(),
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
            return FutureBuilder(
              future: Service().getLoggedInUser(),
              builder: (context, userSnapshot) {
                switch (userSnapshot.connectionState) {
                  case ConnectionState.done:
                    var response = userSnapshot.data!;
                    if(response.errorOccured!){
                      print('asassa ${response.errorMessage}');
                      //showErrorDialog(context, response.errorMessage!);
                      return const LoginView();
                    }else{
                      var user = response.val!;
                      print('asassa ${user.email}');
                      if(user.isSystemManager){
                        return const MainView();
                      }else{
                        return const CustomerProfile();
                      }
                    }
                  default:return const CircularProgressIndicator();
                }
              },
            );

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

 /*final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                if (user.toString() == 'asaadmoslem2000@gmail.com')
                  return const MainView();
                else
                  return const CustomerProfile();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }*/
