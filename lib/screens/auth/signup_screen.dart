import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techstuff/constants/colors.dart';

import '../../models/user_model.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  String? errorMessage;
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customBlack,
        centerTitle: true,
        title: Text(
          "Tech Stuff",
          style: TextStyle(
            color: customWhite,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Text(
                    "SIGNUP",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 60),
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
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Email"),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email address';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _password,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Password"),
                      prefixIcon: Icon(Icons.password),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter password';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _confPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Confirm Password"),
                      prefixIcon: Icon(Icons.password),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Confirmation password';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 50),
                  InkWell(
                    onTap: () {
                      signUp(_email.text, _password.text, context);
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
                              Icons.login,
                              color: customWhite,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "SIGN-UP",
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
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Center(
                      child: Text(
                        "Have an account?",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password, context) async {
    if (_formKey.currentState!.validate()) {
      if (_password.text == _confPassword.text) {
        try {
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password)
              .then((value) async {
            final SharedPreferences _pref =
                await SharedPreferences.getInstance();
            _pref.setString('email', _email.text);
            postDetailsToFirestore(context);
          }).catchError((e) {
            Fluttertoast.showToast(msg: e!.message);
          });
        } on FirebaseAuthException catch (error) {
          switch (error.code) {
            case "invalid-email":
              errorMessage = "Your email address appears to be malformed.";
              break;
            case "wrong-password":
              errorMessage = "Your password is wrong.";
              break;
            case "user-not-found":
              errorMessage = "User with this email doesn't exist.";
              break;
            case "user-disabled":
              errorMessage = "User with this email has been disabled.";
              break;
            case "too-many-requests":
              errorMessage = "Too many requests";
              break;
            case "operation-not-allowed":
              errorMessage =
                  "Signing in with Email and Password is not enabled.";
              break;
            default:
              errorMessage = "An undefined Error happened.";
          }
          Fluttertoast.showToast(msg: errorMessage!);
          print(error.code);
        }
      } else {
        Fluttertoast.showToast(msg: 'Password Dosn\'t match!');
      }
    }
  }

  postDetailsToFirestore(context) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    UserModel userModel = UserModel();

    // writing all the values.
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = _name.text;

    //Specifying the path to store user info in Database.
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    //Navigate to Dashboard after signup success.\

    Navigator.pushReplacementNamed(context, '/userInformationScreen');
  }
}
