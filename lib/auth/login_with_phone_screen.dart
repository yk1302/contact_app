import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contact_app/auth/verify_otp_screen.dart';
import 'package:contact_app/utils/FlutterToast.dart';
import 'package:contact_app/widget/round_button.dart';

class LoginPhone extends StatefulWidget {
  @override
  State<LoginPhone> createState() => _LoginPhoneState();
}

class _LoginPhoneState extends State<LoginPhone> {
  final phoneNumberController = TextEditingController();
  bool _validatephone = false;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade400,
        title: Center(
            child: Text(
          "Login with phone",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        )),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
                controller: phoneNumberController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    //label: Text("Enter Email"),
                    labelText: 'Enter Phone Number',
                    errorText: _validatephone
                        ? 'Enter Valid Phone Number exactly  10 digit'
                        : null,
                    prefixIcon: Icon(
                      Icons.call_outlined,
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
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: RoundButton("Send OTP", () async {
              setState(() {
                loading = true;
              });
              phoneNumberController.text.isEmpty
                  ? _validatephone = true
                  : _validatephone = false;

              if (_validatephone == true ||
                  phoneNumberController.text.length != 13) {
                setState(() {
                  loading = false;
                });
              } else {

                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: phoneNumberController.text.toString(),
                  verificationCompleted: (PhoneAuthCredential credential) {},
                  verificationFailed: (FirebaseAuthException e) {
                    FlutterToast().toast("failed");

                    FlutterToast().toast(e.code);
                    setState(() {
                      loading = false;
                    });
                  },
                  codeSent: (String verificationId, int? resendToken) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerifyOtp(verificationId)));
                    setState(() {
                      loading = false;
                    });
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {
                    FlutterToast().toast("failed");

                    FlutterToast().toast(verificationId.toString());
                    setState(() {
                      loading = false;
                    });
                  },
                );
              }
            }, loading),
          )
        ],
      ),
    );
  }
}
