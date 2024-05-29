import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/components/my_text_field.dart';
import 'package:injury_recovery/constants/routes.dart';
import 'package:injury_recovery/features/presentation/widgets/logo_image.dart';
import 'package:injury_recovery/services/auth/auth_exceptions.dart';
import 'package:injury_recovery/services/auth/auth_service.dart';
import 'package:injury_recovery/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';

import '../services/service_layer.dart';
import '../widgets/row_line_with_button.dart';
import 'package:injury_recovery/constants/colors.dart' as co;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _phoneNumber;
  late final TextEditingController _confermed_password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _phoneNumber = TextEditingController();
    _confermed_password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confermed_password.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: co.backgraound,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                getLogo(context, 0.15),
                const Text(
                  'יצירת החשבון שלך ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                SizedBox(height: screen_height / 32),
                MyTextField(
                  controller: _firstName,
                  hintText: 'שם פרטי ',
                  obscureText: false,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  maxLines: 1,
                ),
                SizedBox(height: screen_height / 82),

                MyTextField(
                  controller: _lastName,
                  hintText: 'שם משפחה',
                  obscureText: false,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  maxLines: 1,
                ),
                SizedBox(height: screen_height / 82),

                MyTextField(
                  controller: _phoneNumber,
                  hintText: 'מספר טלפון',
                  obscureText: false,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.phone,
                  maxLines: 1,
                ),
                SizedBox(height: screen_height / 82),

                MyTextField(
                  controller: _email,
                  hintText: 'דואר אלקטרוני',
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
                  hintText: 'סיסמה',
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
                  hintText: 'אישור סיסמה',
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.visiblePassword,
                  maxLines: 1,
                ),

                SizedBox(
                  height: screen_height * 0.02,
                ),
                MyButton(
                  onPressed: () async {
                    await _register();
                  },
                  title: 'הרשמה',
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: RowTextTextButtun(
                    text1: 'כבר רשום ?',
                    onPresses: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (route) => false,
                      );
                    },
                    button_text: 'להתחבר',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    final email = _email.text;
    final password = _password.text;
    final confermed_password = _confermed_password.text;
    final firstName = _firstName.text;
    final lastName = _lastName.text;
    final phoneNumber = _phoneNumber.text;
    var response = await Service().register(
      email,
      password,
      confermed_password,
      firstName,
      lastName,
      phoneNumber,
    );
    if (response.errorOccured!) {
      await showErrorDialog(context, response.errorMessage!);
    } else {
      //await AuthService.firebase().sendEmailVerification();
      Navigator.pushNamed(context, loginRoute);
    }
  }
  /*try {
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
  }*/
}
