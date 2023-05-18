import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'main_page.dart';
import 'profile_page.dart';
import 'workout_page.dart';

class HomePage extends StatefulWidget {
   HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0; 
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex  = index;
    });
  }

  void allDone() {

  }

  @override
    Widget build(BuildContext context) {
    final List<Widget> pages = [
      MainPage(),
      WorkoutPage(),
      ProfilePage(onTap: allDone,),
    ];
    return Scaffold(
      backgroundColor: Color(0xFF1b1a22),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF111111),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home, color: selectedIndex == 0 ? Colors.blue : Colors.grey),
                onPressed: () => navigateBottomBar(0),
              ),
              IconButton(
                icon: Icon(Icons.fitness_center, color: selectedIndex == 1 ? Colors.blue : Colors.grey),
                onPressed: () => navigateBottomBar(1),
              ),
              IconButton(
                icon: Icon(Icons.person, color: selectedIndex == 2 ? Colors.blue : Colors.grey),
                onPressed: () => navigateBottomBar(2),
              ),
            ],
          ),
        ),
      ),
      body: pages[selectedIndex],
    );
  }
}