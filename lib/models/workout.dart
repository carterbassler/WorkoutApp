import 'exercise.dart';

class Workout {
  final String name;
  final List<Exercise> exercises;
  final String duration;

  Workout({
    required this.name, 
    required this.exercises,
    required this.duration,
  });
}