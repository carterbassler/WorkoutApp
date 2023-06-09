import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/models/set.dart';

import '../components/my_textfield.dart';
import 'exercise.dart';

class Workout {
  String name;
  final List<Exercise> exercises;
  Timestamp? start;
  Timestamp? end;
  String? id;
  Timestamp date;
  bool firstEdit;

  Workout({
    required this.name, 
    required this.exercises,
    this.start,
    this.end,
    this.id,
    required this.date,
    required this.firstEdit,
  });

  //Add an Exercise to a Workout
  Future<void> addExercise(BuildContext context, Function callback) async {
    final exerciseController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1b1a22),
          title: const Text(
            "Add Exercise",
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "Enter the details of the exercise you want to add.",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  MyTextField(controller: exerciseController, hintText: "Exercise Name", hiddenText: false)
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Handle the cancel button (optional)
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              ///NOT WORKING CALL IN ACTIVE WORKOUT
              onPressed: () {
                exercises.add(Exercise(name: exerciseController.text, sets: [
                  new aSet(
                    weight: 0,
                    numReps: 0,
                    isCompleted: false,
                  )
                ]));
                Text('Hello');
                callback();
                Navigator.of(context).pop();
              },
              child: Text(
                "Confirm",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}