// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:workout_app/main.dart';
import 'package:workout_app/models/exercise.dart';
import 'package:workout_app/models/set.dart';
import 'package:workout_app/models/workout.dart';
import 'package:workout_app/pages/active_workout_page.dart';

void main() {
  group('ActiveWorkoutPage Tests', () {
    testWidgets('Rendering Test', activeRenderingTest);
    testWidgets('Exercise and Set Addition Test', additionTest);
    testWidgets('Exercise and Set Deletion Test', deletionTest);
    testWidgets('Workout Saving Test', workoutSavingTest);
  });
  group('DisplayWorkoutsPage tests', () {
    testWidgets('Rendering Test', displayRenderingTest);
    testWidgets('Data Fetching Test', dataFetchingTest);
    testWidgets('Data Display Test', dataDisplayTest);
    testWidgets('Workout Overview Dialog Test', workoutOverviewDialogTest);
  });
}

Future<void> activeRenderingTest(WidgetTester tester) async {
  
}

Future<void> dataFetchingTest(WidgetTester tester) async {
  // Your test code for data fetching...
}

Future<void> dataDisplayTest(WidgetTester tester) async {
  // Your test code for data display...
}

Future<void> workoutOverviewDialogTest(WidgetTester tester) async {
  // Your test code for showing Workout Overview dialog...
}

Future<void> displayRenderingTest(WidgetTester tester) async {
  // Your test code for rendering...
}

Future<void> additionTest(WidgetTester tester) async {
  // Your test code for addition...
}

Future<void> deletionTest(WidgetTester tester) async {
  // Your test code for deletion...
}

Future<void> workoutSavingTest(WidgetTester tester) async {
  // Your test code for saving...
}
