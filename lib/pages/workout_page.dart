import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../models/workout.dart';
import '../models/workout_data.dart';

class WorkoutPage extends StatelessWidget {
  WorkoutPage({super.key});

  WorkoutData myWorkout = WorkoutData();

  void addSet() {

  }

  @override
  Widget build(BuildContext context) {
    Workout workout = myWorkout.getWorkout();
    return Scaffold(
      backgroundColor: Color(0xFF1b1a22),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Current Workout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                workout.name + " (" + workout.duration + ")",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < workout.exercises.length; i++)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              workout.exercises[i].name.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: const [
                                Expanded(
                                    child: Text(
                                  'Sets',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )),
                                Expanded(
                                    child: Text(
                                  'Weight',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )),
                                Expanded(
                                    child: Text(
                                  'Reps',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )),
                                Expanded(
                                    child: Text(
                                  'Completed',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )),
                              ],
                            ),
                          ),
                          for (int j = 0;
                              j < workout.exercises[i].sets.length;
                              j++)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(
                                label: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly, // distribute children evenly
                                      children: [
                                        Expanded(
                                            child: Text((j + 1).toString())),
                                        VerticalDivider(),
                                        Expanded(
                                            child: Text(workout
                                                .exercises[i].sets[j].weight
                                                .toString())),
                                        VerticalDivider(),
                                        Expanded(
                                            child: Text(workout
                                                .exercises[i].sets[j].numReps
                                                .toString())),
                                        VerticalDivider(),
                                        Expanded(
                                            child: Text(workout.exercises[i]
                                                .sets[j].isCompleted
                                                .toString())),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          GestureDetector(
                            onTap : addSet,
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Color(0xFFfd6750),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                    child: Text('Add Set',
                                        style:
                                            TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))),
                          ),
                        ],
                      ),
                    const SizedBox(height:10),
                     GestureDetector(
                      onTap: myWorkout.addExercise,
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Color(0xFFfd6750),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                    child: Text('Add Exercise',
                                        style:
                                            TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
