import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:techstuff/models/user_model.dart';

import '../../constants/colors.dart';

class ProfileEditScreen extends StatefulWidget {
  UserModel userModel;
  ProfileEditScreen({
    required this.userModel,
  });
  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  TextEditingController _name = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _address = TextEditingController();
  @override
  void initState() {
    _name = TextEditingController(text: widget.userModel.name);
    _age = TextEditingController(text: widget.userModel.age);
    _contact = TextEditingController(text: widget.userModel.contact);
    _address = TextEditingController(text: widget.userModel.address);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: customBlack,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: customWhite,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Name"),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _age,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Age"),
                    prefixIcon: Icon(Icons.calendar_view_day_rounded),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Age';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _contact,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Contact"),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Contact';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _address,
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Address"),
                    prefixIcon: Icon(Icons.place_outlined),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Are you sure?"),
                          actions: [
                            TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(customBlack)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "NO",
                                style: TextStyle(color: customWhite),
                              ),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(customBlack)),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.userModel.uid)
                                    .update({
                                  'name': _name.text,
                                  'age': _age.text,
                                  'contact': _contact,
                                  'address': _address,
                                });
                              },
                              child: Text(
                                "YES",
                                style: TextStyle(color: customWhite),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 140,
                    decoration: BoxDecoration(
                      color: customBlack,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload,
                            color: customWhite,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Update",
                            style: TextStyle(
                              fontSize: 18,
                              color: customWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
