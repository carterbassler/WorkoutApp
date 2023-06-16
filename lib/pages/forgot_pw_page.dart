import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

final emailController = TextEditingController();

  void sendPasswordReset() async {
     try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      showMessage("Password reset link sent! Please check your email");
     } on FirebaseAuthException catch(e) {
       showMessage("Account with Email not Found");
     }
  }

  showMessage( String message) {
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
      body : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [  
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Color(0xFF1b1a22),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                ],
              ),
              SizedBox(height : 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:25),
                child: Text(
                  "Enter your email and we will send you a new password",
                  textAlign: TextAlign.center,
                  style : TextStyle(fontSize: 20, color : Colors.white),
                  ),
              ),
              const SizedBox(height:25),
              MyTextField(
                        controller: emailController,
                        hintText: "Email",
                        hiddenText: false,
                      ),
              
              const SizedBox(height:25),
              MyButton(
                        onTap: sendPasswordReset,
                        text: "Send Reset Link"
                      ),
            ],
          ),
        ),
      ),
    ); 
  }
}