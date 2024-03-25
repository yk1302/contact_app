import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contact_app/utils/FlutterToast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../widget/round_button.dart';

class AddContactScreen extends StatefulWidget {
  final String userName;

  AddContactScreen(this.userName);

  @override
  State<AddContactScreen> createState() =>
      _AddContactScreenState(this.userName);
}

class _AddContactScreenState extends State<AddContactScreen> {
  final String userId;

  _AddContactScreenState(this.userId);

  final nameController = TextEditingController();
  final numberController = TextEditingController();
  bool _validatename = false;
  bool _validatenumber = false;
  bool loading = false;

  bool _validateImage = false;
  File? _image;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  Future getGalleryImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _validateImage = true;
      } else {
        _validateImage = false;
        _image = File("");

        FlutterToast().toast("No Image Picked");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade400,
          title: Center(
              child: Text(
            "Add Contact",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                      maxLength: 50,
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          //label: Text("Enter Email"),
                          labelText: 'Enter Name',
                          errorText: _validatename ? 'Name is Nessary.' : null,
                          prefixIcon: Icon(
                            Icons.text_fields,
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
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextField(
                      controller: numberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          //label: Text("Enter Email"),
                          labelText: 'Enter Contact Number',
                          errorText: _validatenumber
                              ? 'Please Enter 10 digit number.'
                              : null,
                          prefixIcon: Icon(
                            Icons.numbers_rounded,
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
                  height: 50,
                ),
                InkWell(
                  onTap: () {
                    getGalleryImage();
                  },
                  child: Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.deepPurple.shade400,
                    )),
                    child: _image != null
                        ? Image.file(_image!.absolute)
                        : Icon(
                            Icons.image,
                            color: Colors.deepPurple.shade400,
                          ),
                  ),
                ),
                SizedBox(
                  height: 90,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: RoundButton("Submit", () async {
                    setState(() {
                      loading = true;
                    });
                    nameController.text.isEmpty
                        ? _validatename = true
                        : _validatename = false;
                    numberController.text.isEmpty
                        ? _validatenumber = true
                        : _validatenumber = false;
                    if (numberController.text.length != 10) {
                      _validatenumber = true;
                    } else {
                      _validatenumber = false;
                    }
                    if (_validatename == true || _validatenumber == true) {
                      setState(() {
                        loading = false;
                      });
                    } else {
                      var newUrl;
                      if (_validateImage == false) {
                        newUrl = "";
                      } else {
                        firebase_storage.Reference ref = firebase_storage
                            .FirebaseStorage.instance
                            .ref('/images' +
                                '${nameController.text.toString()}');
                        firebase_storage.UploadTask uploadTask =
                            ref.putFile(_image!.absolute);

                        await Future.value(uploadTask)
                            .then((value) {})
                            .onError((error, stackTrace) {
                          FlutterToast().toast("Error in uploading image");
                          FlutterToast().toast(error.toString());
                        });
                        newUrl = await ref.getDownloadURL();
                      }
                      String id =
                          DateTime.now().millisecondsSinceEpoch.toString();

                      FirebaseFirestore.instance
                          .collection(userId)
                          .doc(id)
                          .set({
                        'Name': nameController.text.toString(),
                        'Contact': numberController.text.toString(),
                        'id': id,
                        'imageUrl': newUrl.toString(),
                      }).then((value) {
                        FlutterToast().toast("Contact Added");
                        loading = false;
                      }).onError((error, stackTrace) {
                        FlutterToast().toast(error.toString());
                        loading = false;
                      });
                    }
                  }, loading),
                )
              ],
            ),
          ),
        ));
  }
}
