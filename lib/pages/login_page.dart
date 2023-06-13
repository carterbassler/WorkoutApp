import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/components/my_button.dart';
import 'package:workout_app/components/my_textfield.dart';
import 'package:workout_app/components/square_tile.dart';
import 'package:workout_app/services/auth_service.dart';

import 'forgot_pw_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap} );

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //Function to Sign User in with Firebase Auth
  void signUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

    Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      errorMessage(e.code);
    }
  }

  //If Login Details are Incorrect Tell the User
  errorMessage( String message) {
    showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(title : Text(message),
      );
    },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1b1a22),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  Text("Welcome Back",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      )),
            
                  const SizedBox(height: 25),
                  //Username TextField
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    hiddenText: false,
                  ),
            
                  const SizedBox(height: 25),
                  //Password TextField
                  MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    hiddenText: true,
                  ),
            
                  const SizedBox(height: 25),

                  //Page to Reset Password
                  GestureDetector(
                    onTap : () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                         return ForgotPasswordPage(); 
                      }));
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
            
                  const SizedBox(height: 25),
            
                  MyButton(
                    onTap: signUserIn,
                    text: "Sign In"
                  ),
            
                  const SizedBox(height: 50),
            
                  SquareTile(
                    imagePath: 'lib/images/google.png',
                    onTap: () => AuthService().signInWithGoogle(),
                  ),
            
                  const SizedBox(height: 25),
            
                //Switch to SignUp Page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not a member?',
                          style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Sign Up Now',
                          style: TextStyle(
                              color: Color(0xFFfd6750), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
