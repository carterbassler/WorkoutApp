import 'package:flutter/material.dart';

import '../models/workout.dart';

class ExercisePopupMenu extends StatelessWidget {
  final Workout workout;
  final int exerciseIndex;
  final void Function() onRemoveExercise;
  final void Function(String) onRenameExercise;

  ExercisePopupMenu({
    required this.workout,
    required this.exerciseIndex,
    required this.onRemoveExercise,
    required this.onRenameExercise,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      onSelected: (value) {
        if (value == 'remove') {
          onRemoveExercise();
        } else if (value == 'rename') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController exerciseNameController =
                  TextEditingController();
              exerciseNameController.text =
                  workout.exercises[exerciseIndex].name;
              return AlertDialog(
                backgroundColor: Color(0xFF1b1a22),
                title: const Text(
                  "Rename Exercise",
                  style: TextStyle(color: Colors.white),
                ),
                content: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text(
                          "Enter the new name for the exercise.",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: exerciseNameController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.grey[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      onRenameExercise(exerciseNameController.text);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
      color: Color(0xFF2E2C3A),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))
      ),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'rename',
          child: ListTile(
            title: Text(
              'Rename Exercise',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        PopupMenuItem(
          value: 'remove',
          child: ListTile(
            title: Text(
              'Remove Exercise',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}