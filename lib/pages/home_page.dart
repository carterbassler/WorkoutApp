import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'display_workouts_page.dart';
import 'main_page.dart';
import 'profile_page.dart';

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
      DisplayWorkoutsPage(),
      ProfilePage(onTap: allDone,),
    ];
    return Scaffold(
      backgroundColor: Color(0xFF1b1a22),
      bottomNavigationBar: Container(
        height: 90,
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
                icon: Icon(Icons.home, color: selectedIndex == 0 ? Color(0xFFfd6750) : Colors.grey),
                onPressed: () => navigateBottomBar(0),
              ),
              IconButton(
                icon: Icon(Icons.fitness_center, color: selectedIndex == 1 ? Color(0xFFfd6750) : Colors.grey),
                onPressed: () => navigateBottomBar(1),
              ),
              IconButton(
                icon: Icon(Icons.person, color: selectedIndex == 2 ? Color(0xFFfd6750) : Colors.grey),
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