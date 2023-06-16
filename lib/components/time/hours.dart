import 'package:flutter/material.dart';

class MyHours extends StatelessWidget {
  final int hours;
  final bool isSelected;
  
  MyHours( {super.key, required this.hours, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical : 5.0),
      child: Container(
        child : Center(
          child : Text(
            hours.toString(),
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