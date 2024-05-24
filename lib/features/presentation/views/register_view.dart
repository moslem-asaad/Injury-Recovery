import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/components/my_text_field.dart';
import 'package:injury_recovery/constants/routes.dart';
import 'package:injury_recovery/services/auth/auth_exceptions.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';
import 'package:injury_recovery/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';

import '../widgets/row_line_with_button.dart';

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
    double screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Center(child: Text('Register')),
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screen_height / 32),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'images/ball_cure.png',
                    width: 200,
                  ),
                ),
                SizedBox(height: screen_height / 16.5),

                MyTextField(
                  controller: _email,
                  hintText: 'Email',
                  obscureText: false,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                ),

                SizedBox(height: screen_height / 82),

                // password text field
                MyTextField(
                  controller: _password,
                  hintText: 'Password',
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.visiblePassword,
                  maxLines: 1,
                ),

                SizedBox(
                  height: screen_height / 82,
                ),

                MyTextField(
                    controller: _confermed_password,
                    hintText: 'Confirm Password',
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.visiblePassword,
                    maxLines: 1,
                    ),

                SizedBox(
                  height: screen_height / 16.5,
                ),
                MyButton(
                  onPressed: () async {
                    _register();
                  },
                  title: 'Register',
                ),

                SizedBox(height: screen_height / 16.5),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: RowTextTextButtun(
                    text1: 'Already registered ?',
                    onPresses: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            loginRoute,
                            (route) => false,
                          );
                        },
                    button_text: 'Login Here',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _register() async {
    final email = _email.text;
    final password = _password.text;
    final confermed_password = _confermed_password.text;
    try {
      if (password == confermed_password) {
        await AuthService.firebase()
            .createUser(email: email, password: password);
        //final user = AuthService.firebase().currentUser;
        await AuthService.firebase().sendEmailVerification();
        Navigator.of(context).pushNamed(verifyEmailRoute);
      } else {
        await showErrorDialog(context, 'Passwords don\'t match');
      }
    } on WeakPasswordAuthException {
      await showErrorDialog(context, 'Weak Password');
    } on EmailAlreadyInUseAuthException {
      await showErrorDialog(context, 'email is already in use');
    } on InvalidEmailAuthException {
      await showErrorDialog(context, 'Invalid Email address');
    } on GenericAuthException {
      await showErrorDialog(context, 'Failed to register');
    }
  }
}
