import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workout_app/components/my_button.dart';
import 'package:workout_app/pages/profile_page.dart';

import '../components/my_textfield.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  String? imageUrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  //Function to Load the User Data from PreExisting Values
  Future<void> loadUserData() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot doc = await db.collection('users').doc(auth.currentUser!.uid).get();

    if (doc.exists) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      nameController.text = data?["first-last-name"] ?? "";
      ageController.text = data?["age"] ?? "";
      heightController.text = data?["height"] ?? "";
      weightController.text = data?["weight"] ?? "";
      imageUrl = data?["imageUrl"];
      setState(() {});
    }
  }

  //Upload the New User Data to Firebase
  void finishProfileSetup() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    await db.collection('users').doc(auth.currentUser!.uid).set({
      "first-last-name": nameController.text,
      "age": ageController.text,
      "height": heightController.text,
      "weight": weightController.text,
      "imageUrl" : imageUrl,
    });
    print("Information Saved");
    Navigator.pop(context);
    //NAVIGATE BACK TO MAIN PROFILE PAGE
  }

  //Function to Upload the Image
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

      await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).update({
        "imageUrl": newImageUrl
      });

      setState(() {
        imageUrl = newImageUrl;
        isLoading = false;
      });
    } catch(error) {
      setState(() {
        isLoading = false; // end loading in case of error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  icon: Icon(Icons.arrow_back, color: Colors.white,),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                SizedBox(width: 48),
              ],
            ),
          ),
          GestureDetector(
            onTap: uploadImage,
            child: isLoading
                ? CircularProgressIndicator()
                : StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(auth.currentUser!.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const CircleAvatar(
                          radius: 75,
                          backgroundImage: NetworkImage(
                              'https://via.placeholder.com/150'),
                        );
                      }

                      if (snapshot.connectionState ==
                          ConnectionState.active) {
                        Map<String, dynamic>? data = snapshot.data?.data()
                            as Map<String, dynamic>?;
                        String? imageUrl = data?['imageUrl'];
                        return CircleAvatar(
                          radius: 75,
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
          const SizedBox(height: 25),
          MyTextField(
            controller: nameController,
            hintText: "First & Last Name",
            hiddenText: false,
          ),
          const SizedBox(height: 25),
          MyTextField(
            controller: ageController,
            hintText: "Age",
            hiddenText: false,
          ),
          const SizedBox(height: 25),
          MyTextField(
            controller: heightController,
            hintText: "Height",
            hiddenText: false,
          ),
          const SizedBox(height: 25),
          MyTextField(
            controller: weightController,
            hintText: "Weight",
            hiddenText: false,
          ),
          const SizedBox(height: 25),
          MyButton(onTap: finishProfileSetup, text: "Save Changes"),
        ],
      ),
    ),
  );
}
}
