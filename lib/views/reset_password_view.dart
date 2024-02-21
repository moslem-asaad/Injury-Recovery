import 'package:flutter/material.dart';
import 'package:injury_recovery/components/my_text_field.dart';
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
      backgroundColor: Colors.grey[300],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Enter your Email, we will send you a password reset link.',
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
            hintText: 'Email',
            obscureText: false,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
          ),
          
          const SizedBox(height: 15),
          MaterialButton(
            onPressed: () async{
              final email = _email.text;
              try{
                await AuthService.firebase().resetPassword(email: email);
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
              }on InvalidEmailAuthException{
                await showErrorDialog(context, 'Invalid Email');
              } on UserNotFoundAuthException{
                await showErrorDialog(context, 'User Not Found');
              } on GenericAuthException{
                await showErrorDialog(context, 'Authintication Error');
              } on MissingEmailAuthException{
                await showErrorDialog(context, 'Email is Missed');
              }
            }, 
            child: const Text('Reset Password'),
            color: Colors.grey[500],
          ),
        ],
      ),
    );
  }
}