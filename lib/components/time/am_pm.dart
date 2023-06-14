 import 'package:flutter/material.dart';

class AmPm extends StatelessWidget {
  final bool isItAm;
  bool isSelected;
  
  AmPm( {super.key, required this.isItAm, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical : 5.0),
      child: Container(
        child : Center(
          child : Text(
            isItAm ? 'am' : 'pm',
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