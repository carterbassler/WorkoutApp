import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_app/models/workout.dart';
import 'package:workout_app/models/set.dart';

import 'exercise.dart';

class WorkoutData {

  Workout first = Workout(
    name : "Chest Day",
    exercises : [
      new Exercise(
        name : "Barbell Bench Press",
        sets : [
           new aSet(
            weight : 185,
            numReps : 5,
            isCompleted : false,
          ),
          new aSet(
            weight : 185,
            numReps : 5,
            isCompleted : false,
          ),
          new aSet(
            weight : 185,
            numReps : 5,
            isCompleted : false,
          ),
          new aSet(
            weight : 185,
            numReps : 5,
            isCompleted : false,
          ),
        ]
      ),
      new Exercise (
        name : "Incline Dumbbell Press",
        sets : [
          new aSet(
            weight : 70,
            numReps : 8,
            isCompleted : false,
          ),
          new aSet(
            weight : 70,
            numReps : 8,
            isCompleted : false,
          ),
          new aSet(
            weight : 70,
            numReps : 8,
            isCompleted : false,
          ),
        ]
      )
    ], 
    duration : "1 hour"
  );

  //Get a list of workouts
  Workout getWorkout() {
    return first;
  }
  //Start a Workout

  //Add an Exercise to a Workout 
  void addExercise() {
    print('New Exercise Added');
    first.exercises.add(new Exercise(name: "Ex", sets : []));
  }
  //Check off Exercise

  //Get Length of Workout
}