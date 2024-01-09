import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techstuff/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage;

  TextEditingController _email = TextEditingController();
  bool isObsecure = true;

  TextEditingController _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // SizedBox(height: 20),
                      Center(
                        child: Text(
                          "LOGIN",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(height: 60),
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
                        obscureText: isObsecure,
                        controller: _password,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Password"),
                          prefixIcon: Icon(Icons.password),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isObsecure = !isObsecure;
                              });
                            },
                            icon: isObsecure
                                ? Icon(Icons.remove_red_eye_outlined)
                                : Icon(Icons.security_rounded),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter password';
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: 50),
                      InkWell(
                        onTap: () async {
                          signIn(_email.text, _password.text, context);
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
                                  "LOG-IN",
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
                      SizedBox(height: 30),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, '/signup');
                            },
                            child: Center(
                              child: Text(
                                "Don\'t have an account?",
                                style: TextStyle(fontSize: 20),
                              ),
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
      ),
    );
  }

  // login function
  void signIn(String email, String password, context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) async {
          final SharedPreferences _pref = await SharedPreferences.getInstance();
          _pref.setString('email', _email.text);
          Fluttertoast.showToast(msg: "Login Successful");
          Navigator.pushReplacementNamed(context, '/bottomNavBar');
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
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
}
