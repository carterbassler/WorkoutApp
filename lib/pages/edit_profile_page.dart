import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/components/my_button.dart';

import '../components/my_textfield.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? value;

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
    DocumentSnapshot doc =
        await db.collection('users').doc(auth.currentUser!.uid).get();

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
      "imageUrl": imageUrl,
    });
    print("Information Saved");
    Navigator.pop(context);
    //NAVIGATE BACK TO MAIN PROFILE PAGE
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
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
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
            //const SizedBox(height: 25),
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
