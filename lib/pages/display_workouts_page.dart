import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_app/models/exercise.dart';

import '../components/workout_overview_card.dart';
import '../models/set.dart';
import '../models/workout.dart';

class DisplayWorkoutsPage extends StatefulWidget {
  DisplayWorkoutsPage({super.key});

  @override
  State<DisplayWorkoutsPage> createState() => _DisplayWorkoutsPageState();
}

class _DisplayWorkoutsPageState extends State<DisplayWorkoutsPage> {
  void showWorkoutOverviewDialog(BuildContext context, Workout workout) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WorkoutOverviewCard(workout: workout);
      },
    );
  }

  void removeWorkout(Workout workout) {
    // Delete the document from the 'workouts' collection of the current user
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('workouts')
        .doc(workout.id)
        .delete()
        .then((_) {
      print('Workout removed successfully');
      // Remove workout from local state if needed and refresh UI
      setState(() {});
    }).catchError((error) {
      print('Failed to remove workout: $error');
    });
  }

  String formatDuration(int durationInSeconds) {
    int minutes = durationInSeconds ~/ 60;
    int seconds = durationInSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}'; // Format the duration as "mm:ss"
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();

    var dayFormat = DateFormat('EEEE MMMM d').format(date);
    String daySuffix = 'th';

    int dayNum = date.day;
    if (!(dayNum >= 10 && dayNum <= 20)) {
      if (dayNum % 10 == 1) {
        daySuffix = 'st';
      } else if (dayNum % 10 == 2) {
        daySuffix = 'nd';
      } else if (dayNum % 10 == 3) {
        daySuffix = 'rd';
      }
    }

    return '${dayFormat}${daySuffix}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1b1a22),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                        date: data['date'],
                        firstEdit: data['firstEdit'],
                      );
                    }).toList();

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // Display the retrieved workouts
                          Container(
                            width: 720,
                            height: 80,
                            decoration: BoxDecoration(),
                            child: Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Text(
                                "Workout History",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          for (Workout workout in workouts)
                            GestureDetector(
                              onTap: () => {
                                showWorkoutOverviewDialog(context, workout),
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  width: 400,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFD6750),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Align(
                                                alignment:
                                                    AlignmentDirectional(-1, 0),
                                                child: Text(
                                                    formatTimestamp(
                                                        workout.date),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    )),
                                              ),
                                            ),
                                            Align(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: PopupMenuButton(
                                                  icon: Icon(
                                                    Icons.more_vert,
                                                    color: Colors.white,
                                                  ),
                                                  color: Color(0xFF2E2C3A),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15.0))),
                                                  itemBuilder:
                                                      (BuildContext context) =>
                                                          [
                                                    // PopupMenuItem(
                                                    //   child: ListTile(
                                                    //     title: Text(
                                                    //       'Save as Template',
                                                    //       style: TextStyle(
                                                    //         color: Colors.white,
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    PopupMenuItem(
                                                      value: 'delete',
                                                      child: ListTile(
                                                        title: Text(
                                                          'Delete Workout',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  onSelected: (value) {
                                                    switch (value) {
                                                      case 'delete':
                                                        removeWorkout(workout);
                                                        break;
                                                      case 'save':
                                                        // Handle save action
                                                        break;
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(-1, 0),
                                            child: Text(workout.name,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                )),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                  child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.timer,
                                                    color: Colors.white,
                                                    size: 24,
                                                  ),
                                                  Text(
                                                      formatDuration(
                                                          workout.duration),
                                                      style: TextStyle(
                                                          color: Colors.white))
                                                ],
                                              )),
                                              Container(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.center_focus_strong,
                                                      color: Colors.white,
                                                      size: 24,
                                                    ),
                                                    Text(
                                                        workout.exercises.length
                                                                .toString() +
                                                            " Exercises",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white))
                                                  ],
                                                ),
                                              ))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
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
