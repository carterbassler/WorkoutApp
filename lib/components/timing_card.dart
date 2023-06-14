import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:workout_app/components/my_button.dart';
import 'package:workout_app/components/time/time_selector.dart';

import '../models/workout.dart';
import '../pages/active_workout_page.dart';

class TimingCard extends StatefulWidget {
  final Workout workout;
  final FirebaseAuth auth = FirebaseAuth.instance;

  TimingCard({
    super.key,
    required this.workout,
  });

  @override
  _TimingCardState createState() => _TimingCardState();
}

class _TimingCardState extends State<TimingCard> {
  String endTime = '';
  String startTime = '';

  @override
  void initState() {
    super.initState();
    Timestamp tempStart = widget.workout.start;
    final DateTime date = tempStart.toDate();
    final format = DateFormat.jm();
    final formattedDate = format.format(date);
    startTime = formattedDate;

    Timestamp? tempEnd = widget.workout.end;
    final DateTime date2 = tempEnd!.toDate();
    final format2 = DateFormat.jm();
    final formattedDate2 = format2.format(date2);
    endTime = formattedDate2;
  }

  @override
  Widget build(BuildContext context) {
    //String startTime = formattedDate;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // rounded corners
      ),
      backgroundColor: Color(0xFF2E2C3A), // theme background color
      title: Column(
        children: [
          Center(
            child: Text(
              "Change Workout Duration",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ExpansionTile(
            title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Start Time', style: TextStyle(color: Colors.white)),
                    Text(startTime,
                        style: TextStyle(color: Colors.white)) // use variable
                  ],
                )),
            children: <Widget>[
              TimeSelect(
                  onTimeChanged: (selectedTime) =>
                      setState(() => startTime = selectedTime))
            ], // use callback
          ),
          ExpansionTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('End Time', style: TextStyle(color: Colors.white)),
                  Text(endTime,
                      style: TextStyle(color: Colors.white)) // use variable
                ],
              ),
            ),
            children: <Widget>[
              TimeSelect(
                  onTimeChanged: (selectedTime) =>
                      setState(() => endTime = selectedTime))
            ], // use callback
          ),
          SizedBox(height:10),
          GestureDetector(
            onTap: () => {
              print("WORKING"),
            },
            child: Container(
              height: 40, // Set the height
              padding: const EdgeInsets.symmetric(
                  horizontal: 5, vertical: 10), // Adjust padding
              margin:
                  const EdgeInsets.symmetric(horizontal: 20), // Adjust margin
              decoration: BoxDecoration(
                color: Color(0xFFfd6750),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text('Save',
                    style: TextStyle(
                        color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
