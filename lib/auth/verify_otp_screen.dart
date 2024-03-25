import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contact_app/contact/contact_Screen.dart';

import '../../utils/FlutterToast.dart';
import '../../widget/round_button.dart';

class VerifyOtp extends StatefulWidget {
  final String verificationId1;

  VerifyOtp(this.verificationId1);

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  @override
  final otpController = TextEditingController();
  bool _validateotp = false;
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade400,
        title: Center(
            child: Text(
          "Verify Otp",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                controller: otpController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    //label: Text("Enter Email"),
                    labelText: 'Enter Phone Number',
                    errorText: _validateotp ? 'Enter Valid otp' : null,
                    prefixIcon: Icon(
                      Icons.numbers_outlined,
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
            child: RoundButton("Verify", () async {
              setState(() {
                loading = true;
              });
              otpController.text.isEmpty
                  ? _validateotp = true
                  : _validateotp = false;

              if (_validateotp == true) {
                setState(() {});
              } else {
                final credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId1.toString(),
                    smsCode: otpController.text.toString());
                try {
                  await FirebaseAuth.instance.signInWithCredential(credential);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactScreen("")));
                  setState(() {
                    loading = false;
                  });
                } catch (e) {
                  FlutterToast().toast(e.toString());
                  setState(() {
                    loading = false;
                  });
                }
              }
            }, loading),
          )
        ],
      ),
    );
  }
}
