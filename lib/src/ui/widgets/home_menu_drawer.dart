import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sam_rider_app/src/blocs/data_bloc.dart';
import 'package:sam_rider_app/src/util/utils.dart';

class HomeMenuDrawer extends StatefulWidget {
  HomeMenuDrawer({Key key}) : super(key: key);

  _HomeMenuDrawerState createState() => _HomeMenuDrawerState();
}

class _HomeMenuDrawerState extends State<HomeMenuDrawer> {
  DataBloc dataBloc = DataBloc();
  String name = "Welcome! Customer";
  var profileUrl = "";
  @override
  void initState() {
    super.initState();
    dataBloc.getUserProfile((data) {
      name = data["name"];
      if (mounted) {
        setState(() => null);
      }
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
    if (mounted) {
      setState(() {
        print("get image from firebase storage");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: AppColors.main),
          accountName: Text(name),
          accountEmail: Row(
            children: <Widget>[
              Text("5.0"),
              Icon(
                Icons.star,
                color: Colors.white,
                size: 12,
              )
            ],
          ),
          currentAccountPicture: ClipOval(
            child: profileUrl != ""
                ? FadeInImage.assetNetwork(
                    image: profileUrl,
                    placeholder: 'assets/images/default_profile.png',
                    // "assets/images/default_profile.png",
                    width: 10,
                    height: 10,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/images/default_profile.png",
                    width: 10,
                    height: 10,
                    fit: BoxFit.cover,
                  ),
          ),
          onDetailsPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          linkMenuDrawer('Payment', () {
            Navigator.pushNamed(context, '/payment');
          }),
          linkMenuDrawer('Your Past Jobs', () {
            Navigator.pushNamed(context, '/your_trip');
          }),
          linkMenuDrawer('Help', () {
            Navigator.pushNamed(context, '/help');
          }),
          linkMenuDrawer('FAQ', () {
            Navigator.pushNamed(context, '/faq');
          }),
          linkMenuDrawer('Settings', () {
            Navigator.pushNamed(context, '/settings');
          }),
          linkMenuDrawer('Privacy Policy', () {
            Navigator.pushNamed(context, '/privacy');
          }),
          linkMenuDrawer('Terms of service', () {
            Navigator.pushNamed(context, '/termsofservice');
          }),
          linkMenuDrawer('Logout', () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushNamed(context, '/login');
          }),
        ]),
      ],
    );
  }
}

Widget linkMenuDrawer(String title, Function onPressed) {
  return InkWell(
    onTap: onPressed,
    splashColor: Colors.black,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
      width: double.infinity,
      child: Text(
        title,
        style: TextStyle(fontSize: 15.0),
      ),
    ),
  );
}
