import 'dart:ui';

import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/components/my_text_field.dart';
import 'package:injury_recovery/constants/colors.dart';
import 'package:injury_recovery/constants/routes.dart';
import 'package:injury_recovery/features/presentation/services/service_layer.dart';
import 'package:injury_recovery/features/presentation/widgets/logo_image.dart';
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
    double screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgraound,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                getLogo(context, 0.15),
                SizedBox(height: screen_height / 16.5),

                Text(
                  'שלום',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screen_height / 16.5),

                Text(
                  'ברוך שוב, התגעגענו !',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                SizedBox(height: screen_height / 32),

                // user name textfield
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

                // forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, resetPasswordRout);
                        },
                        child: const Text(
                          'שכחת את הסיסמה שלך ?',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screen_height / 32),

                // sign in button
                MyButton(
                  title: 'כניסה',
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    var response = await Service().logIn(email, password);
                    if (response.errorOccured!) {
                      await showErrorDialog(context, response.errorMessage!);
                    } else {
                      if (email == 'asaadmoslem2000@gmail.com') {
                        // user's email is verified
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            mainRoute, (route) => false);
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            customerProfileRout, (route) => false);
                      }
                    }
                    /*else{
                      print('in else');
                     // if(user?.isEmailVerified?? false){ 
                        if(email== 'asaadmoslem2000@gmail.com'){
                          // user's email is verified 
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            mainRoute, 
                            (route) => false
                          );
                        }else{
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            customerProfileRout, 
                            (route) => false
                          );
                        }
                      /*}else{
                        // user's email is NOT verified
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          verifyEmailRoute, 
                          (route) => false
                        );
                      }*/
                    }*/
                  },
                ),

                SizedBox(height: screen_height / 16.5),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'עדיין לא נרשמת ?',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 4),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            registerRoute,
                            (route) => false,
                          );
                        },
                        child: const Text(
                          'הירשם כעת',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*try {
                      await AuthService.firebase().logIn(email: email, password: password);
                      final user = AuthService.firebase().currentUser;
                      if(user?.isEmailVerified?? false){ 
                        if(email== 'asaadmoslem2000@gmail.com'){
                          // user's email is verified 
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            mainRoute, 
                            (route) => false
                          );
                        }else{
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            customerProfileRout, 
                            (route) => false
                          );
                        }
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
                    }*/
