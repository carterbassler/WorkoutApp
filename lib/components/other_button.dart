import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class OtherButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const OtherButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Color(0xFFfd6750),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
              child: Text(text,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)))),
    );
  }
}
