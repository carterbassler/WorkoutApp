import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workout_app/components/my_button.dart';

import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final Function()? onTap;
  ProfilePage({super.key, required this.onTap});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? imageUrl;
  bool isLoading = false;

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

  void uploadImage() async {
    setState(() {
      isLoading = true; // start loading
    });
    ImagePicker imagePicker = ImagePicker();
    String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(file!.path));
      String newImageUrl = await referenceImageToUpload.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update({"imageUrl": newImageUrl});

      setState(() {
        imageUrl = newImageUrl;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false; // end loading in case of error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // DateTime? creationTime = user?.metadata.creationTime;
    // DateTime accountCreationDate = DateTime.fromMillisecondsSinceEpoch(
    //     creationTime!.millisecondsSinceEpoch);
    return Scaffold(
        backgroundColor: Color(0xFF1b1a22),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: 494,
                  height: 80,
                  decoration: BoxDecoration(),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.exit_to_app_rounded,
                            color: Colors.transparent,
                            size: 24,
                          ),
                          onPressed: () async {}),
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.exit_to_app_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                          }),
                    ],
                  ),
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
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          child: Container(
                            width: 150,
                            height: 142,
                            decoration: BoxDecoration(),
                            child: Stack(
                              alignment: AlignmentDirectional(0, 0),
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    radius: 70,
                                    backgroundImage: NetworkImage(
                                        'https://via.placeholder.com/150'),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0, 1),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFD6750),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.mode_edit,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          onPressed: uploadImage,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.active) {
                        Map<String, dynamic>? data =
                            snapshot.data?.data() as Map<String, dynamic>?;
                        String? imageUrl = data?['imageUrl'];
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          child: Container(
                            width: 150,
                            height: 142,
                            decoration: BoxDecoration(),
                            child: Stack(
                              alignment: AlignmentDirectional(0, 0),
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    radius: 70,
                                    backgroundImage: imageUrl != null
                                        ? NetworkImage(imageUrl)
                                        : const NetworkImage(
                                            'https://via.placeholder.com/150'),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0, 1),
                                  child: GestureDetector(
                                    onTap: uploadImage,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFD6750),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.mode_edit,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      // When the stream is still loading, show a loading indicator
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Carter Bassler',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'carterbassler101@gmail.com',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              MyButton(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return EditProfilePage();
                    }));
                  },
                  text: "Edit Profile"),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(30, 10, 30, 10),
                child: Container(
                  width: 550,
                  height: 100,
                  decoration: BoxDecoration(),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical : 4.0),
                              child: FaIcon(
                                FontAwesomeIcons.weight,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            Text(
                              '175',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Weight',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical : 4.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.textHeight,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                Text(
                                  '5\'9',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Height',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical : 4.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.pagelines,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                Text(
                                  '21',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Age',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}
