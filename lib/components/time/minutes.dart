import 'package:flutter/material.dart';

class MyMinutes extends StatelessWidget {
  final int mins;
  final bool isSelected;
  
  MyMinutes({super.key, required this.mins, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical : 5.0),
      child: Container(
        child : Center(
          child : Text(
            mins < 10 ? '0' + mins.toString() : mins.toString(),
            style : TextStyle(
              fontSize: 20,
              color : isSelected ? Color(0xFFfd6750) : Colors.white,
              fontWeight: FontWeight.bold,
            )
          )
        )
      ),
    );
  }
}