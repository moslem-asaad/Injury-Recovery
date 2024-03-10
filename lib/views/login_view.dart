import 'dart:ui';

import 'package:injury_recovery/components/my_button.dart';
import 'package:injury_recovery/components/my_text_field.dart';
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
  Widget build(BuildContext context){
    double screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screen_height/32),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'images/ball_cure.png',
                    width: 200,
                  ),
                ),
                SizedBox(height: screen_height/16.5),
                
                Text(
                  'Hello Again',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 60,
                    fontWeight: FontWeight.bold, 
                  ),
                ),
                SizedBox(height: screen_height/16.5),

                Text(
                  'Welcome back, you\'v been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
            
                SizedBox(height: screen_height/32),
            
                // user name textfield
                MyTextField(
                  controller: _email,
                  hintText: 'Email',
                  obscureText: false,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                ),
            
                SizedBox(height: screen_height/82),
            
                // password text field
                MyTextField(
                  controller: _password,
                  hintText: 'Password',
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.visiblePassword,
                ),
                        
                // forgot password
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: (){
                          Navigator.pushNamed(context, resetPasswordRout);
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,  
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
            
                SizedBox(height: screen_height/32),
            
                // sign in button
                MyButton(
                    title: 'Sign In',
                    onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
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
                            gallaryRout, 
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
                    }
                  },
                ),
            
                SizedBox(height: screen_height/16.5),
            
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not registerd?',
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
                          'Register Now',
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


