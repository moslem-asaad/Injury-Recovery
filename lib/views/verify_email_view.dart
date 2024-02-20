
import 'package:injury_recovery/constants/routes.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify email'),),
      body: Column(
          children: [
            const Text("We'v sent you an email verification. Please open it to verify your account."),
            const Text("if you havn't received email yet, press the button below."),
            TextButton(
              onPressed: () async  {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text ('Send Email Verification'),
             ),
            TextButton(
              onPressed: () async{
                await AuthService.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
              }, 
              child: const Text('Restart'),
            ),
          ],
        ),
    );
  }
}