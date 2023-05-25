import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workout_app/components/my_button.dart';

import '../components/my_textfield.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  final Function()? onTap;
  ProfilePage({super.key, required this.onTap});

  final FirebaseAuth auth = FirebaseAuth.instance;
  DateTime today = DateTime.now();
  User? user = FirebaseAuth.instance.currentUser;

  Future<String?> getFieldValue(String docId, String fieldName) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot doc = await db.collection('users').doc(docId).get();

    if (doc.exists) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      return data?[fieldName]
          as String?; // if the field doesn't exist, this will be null
    }
    return null; // if the document doesn't exist
  }

  @override
  Widget build(BuildContext context) {
    DateTime? creationTime = user?.metadata.creationTime;
    DateTime accountCreationDate = DateTime.fromMillisecondsSinceEpoch(creationTime!.millisecondsSinceEpoch);
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
                      Icons.edit,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return EditProfilePage();
                      }));
                    },
                  ),
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(auth.currentUser!.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const CircleAvatar(
                        radius: 70,
                        backgroundImage:
                            NetworkImage('https://via.placeholder.com/150'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.active) {
                      Map<String, dynamic>? data =
                          snapshot.data?.data() as Map<String, dynamic>?;
                      String? imageUrl = data?['imageUrl'];
                      return CircleAvatar(
                        radius: 70,
                        backgroundImage: imageUrl != null
                            ? NetworkImage(imageUrl)
                            : const NetworkImage(
                                'https://via.placeholder.com/150'),
                      );
                    }

                    // When the stream is still loading, show a loading indicator
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(auth.currentUser!.uid)
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
                  String? age = data?['age'];
                  String? height = data?['height'];
                  String? weight = data?['weight'];
                  return Column(
                    children: [
                      Text(
                        (name ?? ''),
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              profileInfo('Age', (age ?? '')),
                              Container(
                                  height: 50,
                                  width: 1,
                                  color: Colors.white), // Vertical Divider
                              profileInfo('Height', (height ?? '')),
                              Container(
                                  height: 50,
                                  width: 1,
                                  color: Colors.white), // Vertical Divider
                              profileInfo('Weight', (weight ?? '')),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "Workout History",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xFFfd6750),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TableCalendar(
                                locale: "en_US",
                                rowHeight: 36,
                                headerStyle: HeaderStyle(
                                  formatButtonVisible: false,
                                  titleCentered: true,
                                  titleTextStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                  headerMargin: EdgeInsets.all(0),
                                  leftChevronIcon: Icon(
                                    Icons.chevron_left,
                                    color: Colors.white,
                                  ),
                                  rightChevronIcon: Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  ),
                                ),
                                calendarStyle: CalendarStyle(
                                  todayDecoration: BoxDecoration(
                                    color: Color(0xFF1b1a22),
                                    shape: BoxShape.circle,
                                  ),
                                  defaultTextStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  weekendTextStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                availableGestures: AvailableGestures.all,
                                focusedDay: DateTime.now(),
                                firstDay: creationTime,
                                lastDay: DateTime.utc(2030, 12, 31),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }

                // When the stream is still loading, show a loading indicator
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget profileInfo(String title, String value) {
    List<String> valueParts =
        value.split(' '); // Assuming your value comes in the form "100 kg"

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xFF2a2933),
      ),
      child: Column(
        children: [
          Text(
            title,
            style:
                TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              text: valueParts[0],
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: valueParts.length > 1 ? ' ${valueParts[1]}' : '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
