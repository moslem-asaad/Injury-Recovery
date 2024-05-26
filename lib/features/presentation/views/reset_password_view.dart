import 'package:flutter/material.dart';
import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/components/my_text_field.dart';
import 'package:injury_recovery/constants/colors.dart';
import 'package:injury_recovery/constants/routes.dart';
import 'package:injury_recovery/services/auth/auth_exceptions.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';
import 'package:injury_recovery/utilities/show_error_dialog.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: backgraound,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'הזן את כתובת הדואר האלקטרוני שלך, אנו נשלח לך קישור לאיפוס סיסמה.',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 15),
          MyTextField(
            controller: _email,
            hintText: 'דואר אלקטרוני',
            obscureText: false,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
          ),
          const SizedBox(height: 15),
          MyButton(
            title: 'איפוס סיסמה',
            onPressed: () async {
              final email = _email.text;
              try {
                await AuthService.firebase().resetPassword(email: email);
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              } on InvalidEmailAuthException {
                await showErrorDialog(context, 'דואר אלקטרוני לא חוקי');
              } on UserNotFoundAuthException {
                await showErrorDialog(context, 'משתמש לא נמצא');
              } on GenericAuthException {
                await showErrorDialog(context, 'שגיה, נסה עוד פעם');
              } on MissingEmailAuthException {
                await showErrorDialog(context, 'לא נמצה דואר כזה');
              }
            },
          )
        ],
      ),
    );
  }
}
