import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool hiddenText;
  
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.hiddenText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller, 
        obscureText: hiddenText,
        style: TextStyle(color: Colors.black), // Text color
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black), // Border color
            borderRadius: BorderRadius.circular(10), // Rounded edges
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black), // Border color
            borderRadius: BorderRadius.circular(10), // Rounded edges
          ),
          fillColor: Colors.white, // Fill color
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]), // Hint text color
        ),
      ),
    );
  }







}
