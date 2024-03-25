import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contact_app/auth/Login_Screen.dart';
import 'package:contact_app/utils/FlutterToast.dart';

import '../../widget/round_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool _validateemail = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "Forgot Password",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          backgroundColor: Colors.deepPurple.shade400,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      //label: Text("Enter Email"),
                      labelText: 'Enter Email',
                      errorText: _validateemail ? 'Enter Email' : null,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.deepPurpleAccent,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2))),
                  autofocus: true),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: RoundButton('Send Link', () async {
                  setState(() {
                    loading = true;
                  });
                  emailController.text.isEmpty
                      ? _validateemail = true
                      : _validateemail = false;

                  if (_validateemail == true) {
                    setState(() {});

                  } else {
                    FirebaseAuth.instance
                        .sendPasswordResetEmail(
                            email: emailController.text.toString())
                        .then((value) {
                      setState(() {
                        loading = false;
                      });
                      FlutterToast().toast("Recovering Password.");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    }).onError((error, stackTrace) {
                      setState(() {
                        loading = false;
                      });
                      FlutterToast().toast(error.toString());
                    });
                  }
                }, loading)),
          ],
        ));
  }
}
