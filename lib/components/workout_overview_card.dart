import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../models/workout.dart';
import '../pages/active_workout_page.dart';

class WorkoutOverviewCard extends StatelessWidget {
  final Workout workout;
  const WorkoutOverviewCard({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // rounded corners
      ),
      backgroundColor: Color(0xFF1b1a22), // theme background color
      title: Text(
        "Workout Overview",
        style: TextStyle(color: Colors.white),
      ),
      content: Container(
        height: 300,
        width: 350,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < workout.exercises.length; i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Exercise ${i + 1}: ${workout.exercises[i].name}",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Sets: ${workout.exercises[i].sets.length}",
                        style: TextStyle(color: Colors.white),
                      ),
                      // Add more details about each exercise here
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text("Edit Workout", style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActiveWorkoutPage(first: workout),
              ),
            );
          },
        ),
        // TextButton(
        //   child: Text("Delete Workout", style: TextStyle(color: Colors.white)),
        //   onPressed: () {
        //     //DELETE CURRENT WORKOUT
        //   },
        // ),
        TextButton(
          child: Text("Cancel", style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );;
  }
}