import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:techstuff/constants/colors.dart';

import '../../widgets/custom_appbar.dart';

class ContactUS extends StatelessWidget {
  const ContactUS({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final feedback = TextEditingController();
    return Scaffold(
      appBar: CustomAppbar(title: 'Contact & Feedback', ctx: context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.asset('assets/img/logo.png'),
                ),
                Center(
                  child: Text(
                    "Contact Information",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    "We are here for helping you 24X7.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone,
                      size: 30,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "+91 7470379829",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email,
                      size: 30,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "techstuff2023@gmail.com",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 30,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "102 Street 2714 Don",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(height: 20),
                Text(
                  "Feedback",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: feedback,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Feedback"),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(customBlack)),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('admin')
                        .doc('feedback')
                        .collection('feedbacks')
                        .add({
                      'feedback': feedback.text,
                      'userID': user!.uid,
                      'isRead': false,
                    }).whenComplete(() {
                      feedback.clear();
                      Fluttertoast.showToast(
                          msg: 'Thanks for you contribution..❤');
                    });
                  },
                  icon: Icon(Icons.upload_rounded),
                  label: Text("Upload Feedback"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
