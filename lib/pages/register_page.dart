import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/components/my_button.dart';
import 'package:workout_app/components/my_textfield.dart';
import 'package:workout_app/components/square_tile.dart';
import 'package:workout_app/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Function to Sign Users Up Using Firebase Auth
  void signUserUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
         errorMessage("Passwords Don't Match");
      }

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      errorMessage(e.code);
    }
  }

  //If Fields are Incorrect then Display Error Message to User
  errorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
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
                  Text("Sign Up Here",
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
                  //Confirm Password TextField
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    hiddenText: true,
                  ),

                  const SizedBox(height: 25),

                  MyButton(onTap: signUserUp, text: 'Sign Up'),

                  const SizedBox(height: 50),
                  //Sign In with Google
                  SquareTile(
                    imagePath: 'lib/images/google.png',
                    onTap: () => AuthService().signInWithGoogle(),
                  ),

                  const SizedBox(height: 25),

                  //Switch to Login Page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already a member?',
                          style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Sign In',
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
