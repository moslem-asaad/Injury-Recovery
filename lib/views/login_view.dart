import 'package:injury_recovery/constants/routes.dart';
import 'package:injury_recovery/services/auth/auth_exceptions.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';
import 'package:injury_recovery/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
   late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (title: const Text('Login'),),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().logIn(email: email, password: password);
                final user = AuthService.firebase().currentUser;
                if(user?.isEmailVerified?? false){ 
                  // user's email is verified 
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    mainRoute, 
                    (route) => false
                  );
                }else{
                  // user's email is NOT verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute, 
                    (route) => false
                  );
                }
              } on UserNotFoundAuthException{
                await showErrorDialog(context, 'User not found');
              } on WrongPasswordAuthException{
                await showErrorDialog(context, 'Wrong Password');
              } on GenericAuthException{
                await showErrorDialog(context, 'Authintication Error');
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
              registerRoute,
              (route) => false,
            );
          }, 
          child: const Text('Not Registered yet? Register here!'),
          ),
        ],
      ),
    );
  } 
}


