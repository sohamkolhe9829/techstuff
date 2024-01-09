import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techstuff/constants/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? finalEmail;

  @override
  void initState() {
    super.initState();
    getValidation().whenComplete(() {
      Timer(Duration(seconds: 2), () {
        finalEmail == null
            ? Navigator.pushReplacementNamed(context, '/login')
            : Navigator.pushReplacementNamed(context, '/bottomNavBar');
      });
    });
  }

  Future getValidation() async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    var email = _pref.getString('email');
    setState(() {
      finalEmail = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customGreen,
      body: SafeArea(
        child: Center(
          child: Image.asset('assets/img/logo.png'),
        ),
      ),
    );
  }
}
