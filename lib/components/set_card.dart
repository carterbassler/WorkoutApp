import 'package:flutter/material.dart';

import '../models/workout.dart';

class CustomSetWidget extends StatelessWidget {
  final Workout workout;
  final int i;
  final int j;
  final TextEditingController weightController;
  final TextEditingController repsController;
  final Function() onDismissed;
  final Function(String) onWeightChanged;
  final Function(String) onRepsChanged;
  final Function(bool) onCompletedChanged;

  const CustomSetWidget({
    required this.workout,
    required this.i,
    required this.j,
    required this.weightController,
    required this.repsController,
    required this.onDismissed,
    required this.onWeightChanged,
    required this.onRepsChanged,
    required this.onCompletedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            onDismissed();
          },
          background: Container(
            margin: EdgeInsets.fromLTRB(4, 4, 12, 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.delete_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: workout.exercises[i].sets[j].isCompleted
                  ? Color(0xFF6BC3B3)
                  : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Container(
                          child: Text(
                            (j + 1).toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 30,
                        child: TextFormField(
                          controller: weightController,
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            onWeightChanged(value);
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: workout.exercises[i].sets[j].weight.toString(),
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 30,
                        child: TextFormField(
                          controller: repsController,
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            onRepsChanged(value);
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: workout.exercises[i].sets[j].numReps.toString(),
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Theme(
                              data: ThemeData(
                                unselectedWidgetColor: Colors.white,
                              ),
                              child: Checkbox(
                                activeColor: Color(0xFFfd6750),
                                checkColor: Colors.white,
                                value: workout.exercises[i].sets[j].isCompleted,
                                onChanged: (bool? newValue) {
                                  onCompletedChanged(newValue ?? false);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}