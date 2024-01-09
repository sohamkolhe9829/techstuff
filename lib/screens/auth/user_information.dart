import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:techstuff/constants/colors.dart';
import 'package:techstuff/widgets/custom_appbar.dart';

class UserInformationScreen extends StatefulWidget {
  UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final _contact = TextEditingController();
    final _age = TextEditingController();
    final _state = TextEditingController();
    final _pincode = TextEditingController();
    final _city = TextEditingController();
    final _houseNo = TextEditingController();
    final _roadName = TextEditingController();
    return Scaffold(
      appBar: CustomAppbar(title: 'Information', ctx: context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _contact,
                  maxLength: 10,
                  decoration: InputDecoration(
                    label: Text('Contact'),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  maxLength: 2,
                  controller: _age,
                  decoration: InputDecoration(
                    label: Text('Age'),
                    prefixIcon: Icon(Icons.person_4_outlined),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    Text(
                      "  Address:  ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _state,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('State'),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _pincode,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Pincode'),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _city,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('City'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _houseNo,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('House No., Building Name'),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _roadName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Road Name, Area colony'),
                  ),
                ),
                SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .update({
                      'contact': _contact.text,
                      'age': _age.text,
                      'address':
                          "${_houseNo.text + ' ' + _roadName.text + ', ' + _city.text + ', ' + _state.text + '- ' + _pincode.text}"
                    }).whenComplete(() => Navigator.pushReplacementNamed(
                            context, 'bottomNavBar'));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                      color: customBlack,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "Save & Continue",
                        style: TextStyle(
                          color: customWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
