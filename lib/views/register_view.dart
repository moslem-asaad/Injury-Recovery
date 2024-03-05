
import 'package:injury_recovery/constants/routes.dart';
import 'package:injury_recovery/services/auth/auth_exceptions.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';
import 'package:injury_recovery/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confermed_password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _confermed_password = TextEditingController();
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
        appBar: AppBar(title: const Text('Register'),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Email',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            cursorColor: Colors.white,
            style: TextStyle(color: const Color.fromARGB(255, 217, 217, 217)),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            cursorColor: Colors.white,
            style: TextStyle(color: const Color.fromARGB(255, 217, 217, 217)),
          ),
          TextField(
            controller: _confermed_password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Confirm Password',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            cursorColor: Colors.white,
            style: TextStyle(color: const Color.fromARGB(255, 217, 217, 217)),
          ),
          TextButton.icon(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              final confermed_password = _confermed_password.text;
              try {
                if(password == confermed_password){
                await AuthService.firebase().createUser(email: email, password: password);
                //final user = AuthService.firebase().currentUser;
                await AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
                }else{
                  await showErrorDialog(context, 'Passwords don\'t match');
                }
              } on WeakPasswordAuthException{
                await showErrorDialog(context, 'Weak Password');
              } on EmailAlreadyInUseAuthException{
                await showErrorDialog(context, 'email is already in use'); 
              } on InvalidEmailAuthException{
                await showErrorDialog(context, 'Invalid Email address');
              } on GenericAuthException{
                await showErrorDialog(context, 'Failed to register');
              }
            },
            style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal,
            disabledBackgroundColor: Colors.grey,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              )
            ),
            icon: const Icon(Icons.app_registration),
            label: const Text('Register'),
            //child: const Text('Register'),
          ),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamedAndRemoveUntil(loginRoute,
            (route) => false,
            );
          },
          child: const Text('Already Registered? Login here!'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal,
            disabledBackgroundColor: Colors.grey,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              )
            ),
          )
        ],
      ),
    );
  }
}
