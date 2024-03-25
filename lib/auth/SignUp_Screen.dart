import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contact_app/auth/Login_Screen.dart';
import 'package:contact_app/utils/FlutterToast.dart';

import '../../widget/round_button.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _validateemail = false;
  bool _validatepassword = false;
  bool loading = false;
  void validate() {
    email.text.isEmpty ? _validateemail = true : _validateemail = false;
    password.text.isEmpty
        ? _validatepassword = true
        : _validatepassword = false;
    if (_validatepassword == true || _validateemail == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "SignUp",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        backgroundColor: Colors.deepPurple.shade400,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
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
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 2))),
                        autofocus: true),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                          // label: Text("Enter Password"),
                          labelText: 'Enter Password',
                          errorText:
                              _validatepassword ? 'Enter password' : null,
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.deepPurpleAccent,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: BorderSide(
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 2))),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: RoundButton('SignUp', () async {
              setState(() {
                loading = true;
              });
              // validate();
              email.text.isEmpty
                  ? _validateemail = true
                  : _validateemail = false;
              password.text.isEmpty
                  ? _validatepassword = true
                  : _validatepassword = false;
              if (_validatepassword == true || _validateemail == true) {
                setState(() {});
              } else {
                try {
                  final credential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email.text.toString(),
                          password: password.text.toString())
                      .then((value) {
                    setState(() {
                      loading = false;
                    });
                    FlutterToast().toast(value.toString());
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    FlutterToast().toast(error.toString());
                  });
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                  }
                } catch (e) {
                  print(e);
                }
              }
            }, loading),
          ),
          SizedBox(
            height: 80,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Already have an account?"),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text("Login"))
            ],
          ),
        ],
      ),
    );
  }
}
