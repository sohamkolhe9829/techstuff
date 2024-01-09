import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techstuff/screens/profile/aboutus_screen.dart';
import 'package:techstuff/screens/profile/myorders_screen.dart';
import 'package:techstuff/screens/profile/profileEdit_screen.dart';

import '../../constants/colors.dart';
import '../../models/user_model.dart';
import 'contact_us.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customBlack,
        title: Text(
          "Profile",
          style: TextStyle(
            color: customWhite,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                Container(
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset('assets/img/icon.png'),
                  ),
                ),
                Text(
                  "${loggedInUser.name}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text("${loggedInUser.email}"),
                SizedBox(height: 20),
                personalInfoWidget(context),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: customGrey,
                    border: Border.all(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Feedback & Information",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyOrderScreen(),
                                  ));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.backpack_outlined),
                                    Text("My orders"),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ContactUS(),
                                  ));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.contact_page_outlined),
                                    Text("Contact & Feedback"),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AboutUsScreen(),
                                  ));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.info_outline),
                                    Text("About us"),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: ElevatedButton.icon(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(customBlack)),
                                onPressed: () async {
                                  final SharedPreferences _pref =
                                      await SharedPreferences.getInstance();
                                  _pref.remove('email');
                                  Navigator.pushReplacementNamed(
                                      context, '/login');
                                },
                                icon: Icon(Icons.logout_outlined),
                                label: Text("Logout")),
                          )
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  personalInfoWidget(context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: customGrey,
        border: Border.all(),
      ),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Personal Information",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(customBlack)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileEditScreen(userModel: loggedInUser),
                        ),
                      );
                    },
                    icon: Icon(Icons.edit),
                    label: Text("Edit"))
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Age: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: customBlack,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' ${loggedInUser.age == null ? '' : loggedInUser.age}',
                        style: TextStyle(
                          fontSize: 16,
                          color: customBlack,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Contact: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: customBlack,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' ${loggedInUser.contact == null ? '' : loggedInUser.contact}',
                        style: TextStyle(
                          fontSize: 16,
                          color: customBlack,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              // height: 60,
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Address: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: customBlack,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' ${loggedInUser.address == null ? '' : loggedInUser.address}',
                        style: TextStyle(
                          fontSize: 16,
                          color: customBlack,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
