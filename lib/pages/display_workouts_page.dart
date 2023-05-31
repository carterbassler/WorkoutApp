import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/models/exercise.dart';

import '../components/workout_overview_card.dart';
import '../models/set.dart';
import '../models/workout.dart';

class DisplayWorkoutsPage extends StatelessWidget {
  DisplayWorkoutsPage({super.key});

  void showWorkoutOverviewDialog(BuildContext context, Workout workout) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return WorkoutOverviewCard(workout: workout);
    },
  );

  void removeWorkout() {
    
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1b1a22),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('workouts')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.active) {
                    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                        snapshot.data?.docs ?? [];
                    List<Workout> workouts = docs.map((doc) {
                      Map<String, dynamic> data = doc.data();
                      // Extract exercises data
                      List<dynamic> exercisesData = data['exercises'] ?? [];
                      List<Exercise> exercises =
                          exercisesData.map((exerciseData) {
                        // Extract sets data
                        List<dynamic> setsData = exerciseData['sets'] ?? [];
                        List<aSet> sets = setsData.map((setData) {
                          // Create a Set object based on the retrieved data
                          return aSet(
                            weight: setData['weight'],
                            numReps: setData['numReps'],
                            isCompleted: setData['isCompleted'],
                          );
                        }).toList();

                        // Create an Exercise object based on the retrieved data
                        return Exercise(
                          name: exerciseData['name'],
                          sets: sets,
                        );
                      }).toList();

                      // Create a Workout object based on the retrieved data
                      return Workout(
                        name: data['name'],
                        duration: data['duration'],
                        exercises: exercises,
                        id: doc.id,
                      );
                    }).toList();

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // Display the retrieved workouts
                          Text('Workout History',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                          for (Workout workout in workouts)
                            GestureDetector(
                              onTap: () {
                                showWorkoutOverviewDialog(context, workout);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: Color(0xFFfd6750),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20), // Modify this to increase/decrease the border radius.
                                  ),
                                  child: ListTile(
                                    title: Text(workout.name,
                                        style: TextStyle(color: Colors.white)),
                                    subtitle: Text(
                                        'Duration: ${workout.duration}',
                                        style: TextStyle(color: Colors.white)),
                                    trailing: Text(
                                        '${workout.exercises.length} Exercises',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }

                  // When the stream is still loading, show a loading indicator
                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
