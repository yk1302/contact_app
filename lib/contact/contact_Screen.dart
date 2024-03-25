import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:contact_app/contact/add_contact_Screen.dart';
import 'package:contact_app/auth/Login_Screen.dart';
import 'package:contact_app/utils/FlutterToast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class ContactScreen extends StatefulWidget {
  final String userId;

  ContactScreen(this.userId);

  @override
  State<ContactScreen> createState() => _ContactScreenState(this.userId);
}

class _ContactScreenState extends State<ContactScreen> {
  final String userName;

  _ContactScreenState(this.userName);
  final filterController = TextEditingController();
  final nameUpdateController = TextEditingController();
  final numberUpdateController = TextEditingController();

  void makePhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void sendTextMessage(String phoneNumber) async {
    final url = 'sms:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade400,
          title: Center(
              child: Text(
            "Contact",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          )),
          actions: [
            InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                )),
            SizedBox(
              width: 15,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddContactScreen(userName)));
          },
          child: Icon(Icons.add),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                controller: filterController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    //label: Text("Enter Email"),
                    labelText: 'Search',
                    prefixIcon: Icon(
                      Icons.search,
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
                autofocus: true,
                onChanged: (String value) {
                  setState(() {});
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection(userName).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text("Some Error");
                  }

                  return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final name =
                                snapshot.data!.docs[index]['Name'].toString();
                            if (filterController.text.isEmpty) {
                              return ListTile(
                                  onTap: () {
                                    showUpdateDialog(
                                        snapshot.data!.docs[index]['Name']
                                            .toString(),
                                        snapshot.data!.docs[index]['Contact']
                                            .toString(),
                                        snapshot.data!.docs[index]['id']
                                            .toString());
                                  },
                                  onLongPress: () {
                                    showDeleteDialogue(
                                        snapshot.data!.docs[index]['Name']
                                            .toString(),
                                        snapshot.data!.docs[index]['Contact']
                                            .toString(),
                                        snapshot.data!.docs[index]['id']
                                            .toString());
                                  },
                                  leading: snapshot.data!.docs[index]
                                              ['imageUrl'] ==
                                          ""
                                      ? Image.asset(
                                          'images/user.png',
                                          height: 80,
                                          width: 80,
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            snapshot.data!.docs[index]
                                                ['imageUrl'],
                                            height: 80,
                                            width: 80,
                                          ),
                                        ),
                                  title: Text(snapshot.data!.docs[index]['Name']
                                      .toString()),
                                  subtitle: Text(snapshot
                                      .data!.docs[index]['Contact']
                                      .toString()),
                                  trailing: PopupMenuButton(
                                      icon: Icon(Icons.more_vert_outlined),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                                value: 1,
                                                child: ListTile(
                                                  onTap: () {
                                                    //  calling func
                                                    makePhoneCall(snapshot.data!
                                                        .docs[index]['Contact']
                                                        .toString());
                                                  },
                                                  leading: Image.asset(
                                                    'images/call.png',
                                                    width: 25,
                                                  ),
                                                  title: Text("Call"),
                                                )),
                                            PopupMenuItem(
                                                value: 2,
                                                child: ListTile(
                                                  onTap: () {
                                                    sendTextMessage(snapshot
                                                        .data!
                                                        .docs[index]['Contact']
                                                        .toString()); //  message func
                                                  },
                                                  leading: Icon(
                                                      Icons.message_outlined),
                                                  title: Text("Message"),
                                                )),
                                            PopupMenuItem(
                                                value: 3,
                                                child: ListTile(
                                                  onTap: () {
                                                    showUpdateDialog(
                                                        snapshot.data!
                                                            .docs[index]['Name']
                                                            .toString(),
                                                        snapshot
                                                            .data!
                                                            .docs[index]
                                                                ['Contact']
                                                            .toString(),
                                                        snapshot.data!
                                                            .docs[index]['id']
                                                            .toString());
                                                  },
                                                  leading: Icon(
                                                      Icons.update_outlined),
                                                  title: Text("Update"),
                                                )),
                                            PopupMenuItem(
                                                value: 4,
                                                child: ListTile(
                                                  onTap: () {
                                                    showDeleteDialogue(
                                                        snapshot.data!
                                                            .docs[index]['Name']
                                                            .toString(),
                                                        snapshot
                                                            .data!
                                                            .docs[index]
                                                                ['Contact']
                                                            .toString(),
                                                        snapshot.data!
                                                            .docs[index]['id']
                                                            .toString());
                                                  },
                                                  leading: Icon(Icons.delete),
                                                  title: Text("Delete"),
                                                ))
                                          ]));
                            } else if ((name.toLowerCase().contains(
                                filterController.text
                                    .toLowerCase()
                                    .toString()))) {
                              return ListTile(
                                  onTap: () {
                                    showUpdateDialog(
                                        snapshot.data!.docs[index]['Name']
                                            .toString(),
                                        snapshot.data!.docs[index]['Contact']
                                            .toString(),
                                        snapshot.data!.docs[index]['id']
                                            .toString());
                                  },
                                  onLongPress: () {
                                    showDeleteDialogue(
                                        snapshot.data!.docs[index]['Name']
                                            .toString(),
                                        snapshot.data!.docs[index]['Contact']
                                            .toString(),
                                        snapshot.data!.docs[index]['id']
                                            .toString());
                                  },
                                  leading: Image.asset('images/user.png'),
                                  title: Text(snapshot.data!.docs[index]['Name']
                                      .toString()),
                                  subtitle: Text(snapshot
                                      .data!.docs[index]['Contact']
                                      .toString()),
                                  trailing: PopupMenuButton(
                                      icon: Icon(Icons.more_vert_outlined),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                                value: 1,
                                                child: ListTile(
                                                  onTap: () {
                                                    //  calling func
                                                  },
                                                  leading: Image.asset(
                                                    'images/call.png',
                                                    width: 25,
                                                  ),
                                                  title: InkWell(
                                                      onTap: () {
                                                        makePhoneCall(snapshot
                                                            .data!
                                                            .docs[index]
                                                                ['Contact']
                                                            .toString());
                                                      },
                                                      child: Text("Call")),
                                                )),
                                            PopupMenuItem(
                                                value: 2,
                                                child: ListTile(
                                                  onTap: () {
                                                    sendTextMessage(snapshot
                                                        .data!
                                                        .docs[index]['Contact']
                                                        .toString()); //  message func
                                                  },
                                                  leading: Icon(
                                                      Icons.message_outlined),
                                                  title: Text("Message"),
                                                )),
                                            PopupMenuItem(
                                                value: 3,
                                                child: ListTile(
                                                  onTap: () {
                                                    showUpdateDialog(
                                                        snapshot.data!
                                                            .docs[index]['Name']
                                                            .toString(),
                                                        snapshot
                                                            .data!
                                                            .docs[index]
                                                                ['Contact']
                                                            .toString(),
                                                        snapshot.data!
                                                            .docs[index]['id']
                                                            .toString());
                                                  },
                                                  leading: Icon(
                                                      Icons.update_outlined),
                                                  title: Text("Update"),
                                                )),
                                            PopupMenuItem(
                                                value: 4,
                                                child: ListTile(
                                                  onTap: () {
                                                    showDeleteDialogue(
                                                        snapshot.data!
                                                            .docs[index]['Name']
                                                            .toString(),
                                                        snapshot
                                                            .data!
                                                            .docs[index]
                                                                ['Contact']
                                                            .toString(),
                                                        snapshot.data!
                                                            .docs[index]['id']
                                                            .toString());
                                                  },
                                                  leading: Icon(Icons.delete),
                                                  title: Text("Delete"),
                                                ))
                                          ]));
                            } else {
                              return Container();
                            }
                          }));
                }),
          ],
        ));
  }

  Future<void> showDeleteDialogue(String name, String number, String id) async {
    nameUpdateController.text = name;
    numberUpdateController.text = number;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.delete),
                Text('Confirm Delete?'),
              ],
            ),
            content: Column(
              children: [
                TextField(
                    enabled: false,
                    maxLength: 50,
                    controller: nameUpdateController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      //label: Text("Enter Email"),
                      labelText: 'Enter New Name',
                      prefixIcon: Icon(
                        Icons.text_fields,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    autofocus: true),
                TextField(
                    enabled: false,
                    maxLength: 50,
                    controller: numberUpdateController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        //label: Text("Enter Email"),
                        labelText: 'Enter New Number',
                        prefixIcon: Icon(
                          Icons.contact_phone,
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
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    FirebaseFirestore.instance
                        .collection(userName)
                        .doc(id)
                        .delete()
                        .then((value) {
                      FlutterToast().toast("Contact Deleted");
                    }).onError((error, stackTrace) {
                      FlutterToast().toast(error.toString());
                    });
                  },
                  child: Text('Delete')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'))
            ],
          );
        });
  }

  Future<void> showUpdateDialog(String name, String number, String id) async {
    nameUpdateController.text = name;
    numberUpdateController.text = number;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update'),
            content: Column(
              children: [
                TextField(
                    maxLength: 50,
                    controller: nameUpdateController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        //label: Text("Enter Email"),
                        labelText: 'Enter New Name',
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
                TextField(
                    maxLength: 50,
                    controller: numberUpdateController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        //label: Text("Enter Email"),
                        labelText: 'Enter New Number',
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
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    FirebaseFirestore.instance
                        .collection(userName)
                        .doc(id)
                        .update({
                      'Name': nameUpdateController.text.toString(),
                      'Contact': numberUpdateController.text.toString(),
                    }).then((value) {
                      FlutterToast().toast("Contact Updated");
                    }).onError((error, stackTrace) {
                      FlutterToast().toast(error.toString());
                    });
                  },
                  child: Text('Update')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'))
            ],
          );
        });
  }
}
