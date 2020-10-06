import 'package:flutter/material.dart';
import 'package:sam_rider_app/src/blocs/data_bloc.dart';

class HomeMenuDrawer extends StatefulWidget {
  HomeMenuDrawer({Key key}) : super(key: key);

  _HomeMenuDrawerState createState() => _HomeMenuDrawerState();
}

class _HomeMenuDrawerState extends State<HomeMenuDrawer> {
  DataBloc dataBloc = DataBloc();
  String name = "Welcome! Customer";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataBloc.getUserProfile((data) {
      name = data["name"];
      if (mounted) {
        setState(() => null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Colors.black),
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
            child: Image.asset(
              "assets/images/user_profile.jpg",
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
          linkMenuDrawer('Your Trips', () {
            Navigator.pushNamed(context, '/your_trip');
          }),
          linkMenuDrawer('Free Rides', () {
            Navigator.pushNamed(context, '/free_rides');
          }),
          linkMenuDrawer('Help', () {
            Navigator.pushNamed(context, '/help');
          }),
          linkMenuDrawer('Settings', () {
            Navigator.pushNamed(context, '/settings');
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
