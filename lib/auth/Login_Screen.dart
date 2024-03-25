import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:contact_app/contact/contact_Screen.dart';
import 'package:contact_app/auth/ForgotPass_Screen.dart';
import 'package:contact_app/auth/SignUp_Screen.dart';
import 'package:contact_app/auth/login_with_phone_screen.dart';
import 'package:contact_app/widget/round_button.dart';

import '../../utils/FlutterToast.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _validateemail = false;
  bool _validatepassword = false;
  bool loading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              "LogIn",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          backgroundColor: Colors.deepPurple.shade400,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 70.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  //label: Text("Enter Email"),
                                  labelText: 'Enter Email',
                                  errorText:
                                      _validateemail ? 'Enter Email' : null,
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
                    child: RoundButton('LogIn', () async {
                      setState(() {
                        loading = true;
                      });
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
                              .signInWithEmailAndPassword(
                                  email: email.text.toString(),
                                  password: password.text.toString())
                              .then((value) {

                            FlutterToast().toast(email.text.toString());
                            setState(() {
                              loading = false;
                            });
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ContactScreen(email.text.toString())));
                          }).onError((error, stackTrace) {
                            FlutterToast().toast(error.toString());
                            setState(() {
                              loading = false;
                            });
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
                    }, loading)),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupScreen()));
                        },
                        child: Text("Sign Up"))
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen()));
                      },
                      child: Text("Forgot Password")),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: InkWell(
                    onTap: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => LoginPhone()));
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.call),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPhone()));
                                },
                                child: Text("LogIn With Phone")),
                          ],
                        ),
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
