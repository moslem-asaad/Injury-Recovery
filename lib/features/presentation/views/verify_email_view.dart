import 'package:injury_recovery/constants/colors.dart';
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
      backgroundColor: backgraound,
      appBar: AppBar(
          title: const Center(
        child: Text('אימות דואר אלקטרוני',
            style: TextStyle(
              fontSize: 30,
              height: 1.5,
            )),
      )),
      body: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          Text(
            "שלחנו לך אימות דואר אלקטרוני. אנא פתח אותו כדי לאמת את החשבון שלך.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 20,
              height: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "אם עדיין לא קיבלת את הדואר האלקטרוני, לחץ על הלחצן שלהלן.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          TextButton.icon(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: my_green,
              disabledBackgroundColor: Colors.grey,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: const Icon(Icons.email),
            label: const Text(
              'שלח אימות דואר אלקטרוני',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            //child: const Text ('Send Email Verification'),
          ),
          const SizedBox(height: 50.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'הדואר האלקטרוני מאומת?',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 4),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'להתחבר',
                    style: TextStyle(
                        color: my_blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
