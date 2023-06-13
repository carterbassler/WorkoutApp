import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/exercise_popup.dart';
import '../components/other_button.dart';
import '../components/set_card.dart';
import '../models/workout.dart';

class ActiveWorkoutPage extends StatefulWidget {
  final Workout first;
  ActiveWorkoutPage({super.key, required this.first});

  @override
  State<ActiveWorkoutPage> createState() => _ActiveWorkoutPageState();
}

class _ActiveWorkoutPageState extends State<ActiveWorkoutPage> {
  List<List<TextEditingController>> weightControllers = [];
  List<List<TextEditingController>> repsControllers = [];
  bool isEditing = false;
  TextEditingController workoutNameController = TextEditingController();
  StreamController<int> _durationStreamController = StreamController<int>();
  int durationInSeconds = 0;

  @override
  void initState() {
    super.initState();
    if(widget.first.firstEdit == true) {
      startDurationCounter();
    } else {
      _durationStreamController.add(widget.first.duration);
    }
    // Initialize a controller for each aSet in each exercise
    for (var exercise in widget.first.exercises) {
      List<TextEditingController> weightControllersInExercise = [];
      List<TextEditingController> repsControllersInExercise = [];
      for (var aSet in exercise.sets) {
        TextEditingController weightController =
            TextEditingController(text: aSet.weight.toString());
        TextEditingController repsController =
            TextEditingController(text: aSet.numReps.toString());
        weightControllersInExercise.add(weightController);
        repsControllersInExercise.add(repsController);
      }
      weightControllers.add(weightControllersInExercise);
      repsControllers.add(repsControllersInExercise);
    }
  }

  @override
  void dispose() {
    _durationStreamController.close();
    super.dispose();
  }

  void startDurationCounter() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        durationInSeconds++; // Increment the duration by 1 second
      });
      _durationStreamController.add(durationInSeconds);
    });
  }

  String formatDuration(int durationInSeconds) {
    int minutes = durationInSeconds ~/ 60;
    int seconds = durationInSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}'; // Format the duration as "mm:ss"
  }

  @override
  Widget build(BuildContext context) {
    Workout workout = widget.first;

    void addExercise() {
      widget.first.addExercise(context, () {
        setState(() {
          workout = widget.first;
        });
      });
      weightControllers.add([TextEditingController()]);
      repsControllers.add([TextEditingController()]);
    }

    void addSet(int i) {
      widget.first.exercises[i].addSet();

      weightControllers[i].add(TextEditingController());
      repsControllers[i].add(TextEditingController());

      setState(() {
        workout = widget.first;
      });
    }

    void removeSet(int exerciseIndex, int setIndex) {
      setState(() {
        widget.first.exercises[exerciseIndex].sets.removeAt(setIndex);
        weightControllers[exerciseIndex].removeAt(setIndex);
        repsControllers[exerciseIndex].removeAt(setIndex);
      });
    }

    void removeExercise(int exerciseIndex) {
      setState(() {
        widget.first.exercises.removeAt(exerciseIndex);
        weightControllers.removeAt(exerciseIndex);
        repsControllers.removeAt(exerciseIndex);
      });
    }

    void saveWorkoutData() async {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;
      Workout workout = widget.first; // Getting the workout

      // Create a map representing the workout
      Map<String, dynamic> workoutMap = {
        'name': workout.name,
        'duration': durationInSeconds,
        'exercises': workout.exercises
            .map((e) => {
                  'name': e.name,
                  'sets': e.sets
                      .map((s) => {
                            'weight': s.weight,
                            'numReps': s.numReps,
                            'isCompleted': s.isCompleted,
                          })
                      .toList(),
                })
            .toList(),
          'date' : workout.date,
          'firstEdit' : false,
      };

      String workoutId = widget.first.id ?? '';
      if (workoutId.isEmpty) {
        // If workout does not already have an id, create a unique one
        workoutId = db
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('workouts')
            .doc()
            .id;
        widget.first.id = workoutId;
      }

      // Save the map to Firestore in a 'workouts' subcollection
      await db
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('workouts')
          .doc(workoutId)
          .set(workoutMap);

      print("Workout information saved");
      setState(() {
        workout = widget.first;
      });
      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: Color(0xFF1b1a22),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Current Workout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      saveWorkoutData();
                    },
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isEditing = true;
                  workoutNameController.text = workout.name;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isEditing
                      ? Expanded(
                          child: TextFormField(
                            controller: workoutNameController,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'Workout Name',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        )
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              workout.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isEditing) {
                          isEditing = false;
                          workout.name = workoutNameController.text;
                        } else {
                          isEditing = true;
                          workoutNameController.text = workout.name;
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isEditing ? Colors.transparent : Colors.transparent,
                      ),
                      child: Icon(
                        isEditing ? Icons.done : Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<int>(
                stream: _durationStreamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'Duration: ${formatDuration(snapshot.data!)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  } else {
                    return Text(
                      'Duration: 0:00',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }
                },
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  workout.exercises[i].name.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                ExercisePopupMenu(
                                  workout: workout,
                                  exerciseIndex: i,
                                  onRemoveExercise: () {
                                    setState(() {
                                      removeExercise(i);
                                      //workout.exercises.removeAt(i);
                                    });
                                  },
                                  onRenameExercise: (newName) {
                                    setState(() {
                                      workout.exercises[i].name = newName;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // Center align the items vertically
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Center(
                                      child: Text(
                                        'Sets',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Center(
                                      child: Transform.scale(
                                        scale:
                                            1.0, // Adjust the scale factor as desired
                                        child: Text(
                                          'Weight',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Center(
                                      child: Transform.scale(
                                        scale:
                                            1.0, // Adjust the scale factor as desired
                                        child: Text(
                                          'Reps',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Center(
                                      child: Text(
                                        'Completed',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          for (int j = 0;
                              j < workout.exercises[i].sets.length;
                              j++)
                            CustomSetWidget(
                              workout: workout,
                              i: i,
                              j: j,
                              weightController: weightControllers[i][j],
                              repsController: repsControllers[i][j],
                              onDismissed: () {
                                setState(() {
                                  removeSet(i, j);
                                });
                              },
                              onWeightChanged: (value) {
                                setState(() {
                                  workout.exercises[i].sets[j].weight =
                                      int.parse(value);
                                });
                              },
                              onRepsChanged: (value) {
                                setState(() {
                                  workout.exercises[i].sets[j].numReps =
                                      int.parse(value);
                                });
                              },
                              onCompletedChanged: (newValue) {
                                setState(() {
                                  workout.exercises[i].sets[j].isCompleted =
                                      newValue;
                                });
                              },
                            ),
                          OtherButton(onTap: () => addSet(i), text: 'Add Set'),
                        ],
                      ),
                    const SizedBox(height: 10),
                    OtherButton(onTap: addExercise, text: 'Add Exercise'),
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
