import 'package:workout_app/models/set.dart';

class Exercise {
  String name;
  final List<aSet> sets;

  Exercise({
    required this.name,
    required this.sets,
  });

  void addSet() {
    print('Set Saved');
    sets.add(aSet(
      weight: 0,
      numReps: 0,
      isCompleted: false,
    ));
  }
}
