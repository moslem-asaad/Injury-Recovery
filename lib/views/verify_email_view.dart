
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
      appBar: AppBar(
        title: const Text('Verify email'),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: Colors.grey,
      ),
      body: Column(
          children: [
            const Text(
              "We'v sent you an email verification. Please open it to verify your account.",
              textAlign: TextAlign.center,
              textWidthBasis:TextWidthBasis.parent,
              style: TextStyle(
                color: const Color.fromARGB(255, 217, 217, 217),
                fontSize: 20,
                height: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "if you havn't received email yet, press the button below.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color.fromARGB(255, 217, 217, 217),
                fontSize: 15,
                height: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () async  {
                await AuthService.firebase().sendEmailVerification();
              },
              style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal,
              disabledBackgroundColor: Colors.grey,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                ),
              ),
              icon: const Icon(Icons.email),
              label:const Text ('Send Email Verification'),
              //child: const Text ('Send Email Verification'),
             ),
            TextButton.icon(
              onPressed: () async{
                await AuthService.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
              }, 
              style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal,
              disabledBackgroundColor: Colors.grey,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                ),
              ),
              icon: const Icon(Icons.restart_alt),
              label: const Text('Restart'),
            ),
          ],
        ),
    );
  }
}