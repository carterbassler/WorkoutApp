import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const MyButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60, // Set the height
        padding: const EdgeInsets.symmetric(
            horizontal: 5, vertical: 15), // Adjust padding
        margin: const EdgeInsets.symmetric(horizontal: 20), // Adjust margin
        decoration: BoxDecoration(
          color: Color(0xFFfd6750),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(text,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
