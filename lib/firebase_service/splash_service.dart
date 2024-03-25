import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:contact_app/contact/contact_Screen.dart';
import 'package:contact_app/auth/Login_Screen.dart';
import 'package:contact_app/utils/FlutterToast.dart';

class SplashService {
  void isLogin(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      Timer(Duration(seconds: 4), () {
        String? userId = FirebaseAuth.instance.currentUser?.email;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ContactScreen(userId!)));
      });
    } else {
      Timer(Duration(seconds: 4), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    }
  }
}
