import 'package:uuid/uuid.dart';

class aSet {
  int weight;
  int numReps;
  bool isCompleted;
  final String id = Uuid().v4();
  aSet({
    required this.weight,
    required this.numReps,
    required this.isCompleted,
  });
}