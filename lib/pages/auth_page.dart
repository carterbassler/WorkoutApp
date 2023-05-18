import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:workout_app/pages/login_page.dart';
import 'package:workout_app/pages/profile_page.dart';

import 'home_page.dart';
import 'login_or_register_page.dart';

class  AuthPage extends StatelessWidget {
  const  AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    void temp() {

    }
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
           if(snapshot.hasData) {
             return HomePage();
           } else {
             return LoginOrRegisterPage();
           }
        },
      )
    );
  }
}