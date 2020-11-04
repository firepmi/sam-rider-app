import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marquee/marquee.dart';
import 'package:sam_rider_app/src/blocs/data_bloc.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DataBloc dataBloc = DataBloc();
  String name = "Welcome! Customer";
  String phone = "";
  String email = "";

  File _image;
  final picker = ImagePicker();
  var profileUrl = "";

  void onProfileUpdate() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Image from..."),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    onCamera();
                  },
                  child: Text("Camera"),
                ),
                FlatButton(
                  onPressed: () {
                    onGallery();
                  },
                  child: Text("Gallery"),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context, "cancel");
                  },
                  child: Text("Cancel"),
                )
              ],
            ));
  }

  void onCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    setState(() {
      Navigator.pop(context, "camera");
    });
    uploadProfileImage();
  }

  void onGallery() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
      setState(() {
        Navigator.pop(context, "gallery");
      });
      uploadProfileImage();
    } catch (e) {
      print(e.toString());
    }
  }

  void uploadProfileImage() {
    dataBloc.uploadProfile(_image.readAsBytesSync(), () {
      print("image upload completed");
      Fluttertoast.showToast(
          msg: "Profile image uploaded successfully.",
          toastLength: Toast.LENGTH_LONG);
    });
  }

  @override
  void initState() {
    super.initState();
    email = FirebaseAuth.instance.currentUser.email;
    dataBloc.getUserProfile((data) {
      setState(() {
        name = data["name"];
        phone = data["phone"];
      });
    });
    getProfileImage();
  }

  void getProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    final ref = FirebaseStorage.instance
        .ref()
        .child("profile")
        .child(user.uid + ".jpg");
    try {
      profileUrl = (await ref.getDownloadURL()).toString();
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      print("get image from firebase storage");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white70,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                onProfileUpdate();
              },
              child: CircleAvatar(
                child: ClipOval(
                  child: _image == null
                      ? (profileUrl != ""
                          ? FadeInImage.assetNetwork(
                              image: profileUrl,
                              placeholder: 'assets/images/default_profile.png',
                              // "assets/images/default_profile.png",
                              width: 120,
                              height: 120,
                              placeholderCacheWidth: 120,
                              placeholderCacheHeight: 120,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/default_profile.png',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ))
                      : Image.file(
                          _image,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                ),
                radius: 60,
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 30, bottom: 30),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(),
            Container(
              padding:
                  EdgeInsets.only(left: 40, right: 40, bottom: 15, top: 15),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Account",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        email,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  // Text(
                  //   email,
                  //   style: TextStyle(fontSize: 16),
                  // ),
                ],
              ),
            ),
            Divider(),
            Container(
              padding:
                  EdgeInsets.only(left: 40, right: 40, bottom: 15, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Phone",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    phone,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              padding:
                  EdgeInsets.only(left: 40, right: 40, bottom: 15, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Change Password",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            Divider(),
            GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/login');
              },
              child: Container(
                padding:
                    EdgeInsets.only(left: 40, right: 40, bottom: 15, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Log Out",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Icon(
                      Icons.logout,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
          ],
        ));
  }
}
