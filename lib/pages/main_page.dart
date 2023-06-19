import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../components/my_button.dart';
import '../models/workout.dart';
import 'active_workout_page.dart';
import 'package:lottie/lottie.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  String timeOfDay() {
    var hour = DateTime.now().hour;
    if (hour < 6) {
      return "Night";
    } else if (hour < 12) {
      return "Morning";
    } else if (hour < 17) {
      return "Afternoon";
    } else if (hour < 20) {
      return "Evening";
    } else {
      return "Night";
    }
  }

  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = Timestamp.fromDate(DateTime.now());
    Workout newWorkout =
        Workout(name: "", exercises: [], date: timestamp, firstEdit: true);
    return Scaffold(
      backgroundColor: Color(0xFF1B1A22),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.active) {
                  Map<String, dynamic>? data =
                      snapshot.data?.data() as Map<String, dynamic>?;
                  String? name = data?['first-last-name'];
                  String? imageUrl = data?['imageUrl'];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                          child: Container(
                            width: 521,
                            height: 80,
                            decoration: BoxDecoration(),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 200,
                                  height: 100,
                                  decoration: BoxDecoration(),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 200,
                                        height: 100,
                                        decoration: BoxDecoration(),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Hello ' + (name ?? '') + "!",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              'Good ' + timeOfDay(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(),
                                  child: imageUrl != null
                                      ? CircleAvatar(
                                          radius: 70,
                                          backgroundImage:
                                              NetworkImage(imageUrl),
                                        )
                                      : const CircleAvatar(
                                          radius: 70,
                                          backgroundImage: NetworkImage(
                                              'https://via.placeholder.com/150'),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.04),
                          child: Container(
                            width: MediaQuery.of(context).size.width *
                                0.9, // adjust as needed
                            height: MediaQuery.of(context).size.height *
                                0.5, // adjust as needed
                            child: Lottie.network(
                                'https://assets4.lottiefiles.com/packages/lf20_JkRdsa6Exx.json'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                          child: Container(
                            //width: 315,
                            //height: 49,
                            decoration: BoxDecoration(),
                            child: MyButton(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ActiveWorkoutPage(
                                      first: newWorkout,
                                    ),
                                  ),
                                );
                              },
                              text: 'Start New Workout',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return CircularProgressIndicator();
              },
            )
          ],
        ),
      ),
    );
  }
}
