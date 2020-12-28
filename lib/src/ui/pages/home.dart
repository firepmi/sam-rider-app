import 'package:flutter/material.dart';
import 'package:sam_rider_app/src/ui/widgets/home_menu_drawer.dart';
import 'package:sam_rider_app/src/util/globals.dart';
import 'package:sam_rider_app/src/util/utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      bottomSheet: Container(
        height: 300,
        decoration: BoxDecoration(color: Colors.black),
        child: Column(),
      ),
      drawer: Drawer(
        child: HomeMenuDrawer(),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(
          "Job Location",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        leading: FlatButton(
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
          child: Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Center(
              child: Padding(
            padding: EdgeInsets.only(top: 30, bottom: 30),
            child: Text(
              "How many stops will this job require?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Padding(
              //   padding:
              //       EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
              //   child: RaisedButton(
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(5.0),
              //         side: BorderSide(color: AppColors.main)),
              //     onPressed: () {
              //       Globals.stops = 1;
              //       Navigator.pushNamed(context, '/joblocation');
              //     },
              //     color: AppColors.main,
              //     textColor: Colors.white,
              //     child: Text("1 Stop", style: TextStyle(fontSize: 16)),
              //   ),
              // ),
              Padding(
                padding:
                    EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: AppColors.main)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/joblocation');
                  },
                  color: AppColors.main,
                  textColor: Colors.white,
                  child: Text("2 Stops", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
