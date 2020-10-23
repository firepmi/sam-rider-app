import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sam_rider_app/src/blocs/data_bloc.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsView();
  }
}

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  DataBloc dataBloc = DataBloc();
  String name = "Welcome! Customer";
  String phone = "";
  String email = "";

  var profileUrl = "";

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
    profileUrl = (await ref.getDownloadURL()).toString();
    setState(() {
      print("get image from firebase storage");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Account Settings",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white70,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: ListView(
          padding: EdgeInsets.only(left: 20, right: 20),
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                CircleAvatar(
                  child: ClipOval(
                    child: (profileUrl != ""
                        ? FadeInImage.assetNetwork(
                            image: profileUrl,
                            placeholder: 'assets/images/default_profile.png',
                            // "assets/images/default_profile.png",
                            width: 80,
                            height: 80,
                            placeholderCacheWidth: 80,
                            placeholderCacheHeight: 80,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/default_profile.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )),
                  ),
                  radius: 40,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 5),
                      Text(phone),
                      SizedBox(height: 3),
                      Text(email,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ))
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Divider(),
            SizedBox(
              height: 40,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Favorites",
                    style: TextStyle(fontSize: 22, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text(
                      "Add Home",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.work),
                    title: Text(
                      "Add Work",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(),
          ],
        ));
  }
}
