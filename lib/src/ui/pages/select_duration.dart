import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sam_rider_app/src/util/globals.dart';
import 'package:sam_rider_app/src/util/utils.dart';

class SelectDurationPage extends StatefulWidget {
  @override
  _SelectDurationPageState createState() => _SelectDurationPageState();
}

class _SelectDurationPageState extends State<SelectDurationPage> {
  List<LatLng> path = List();
  PriceOptional _price = PriceOptional.small;

  double getDistance() {
    if (path == null || path.length < 2) return 0;
    var distance = 0.0;
    for (int i = 0; i < path.length - 1; i++) {
      distance += getDistanceFromLatLonInKm(path[i].latitude, path[i].longitude,
          path[i + 1].latitude, path[i + 1].longitude);
    }
    return distance;
  }

  double getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
    var R = 6371;
    var dLat = deg2rad(lat2 - lat1);
    var dlon = deg2rad(lon2 - lon1);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dlon / 2) * sin(dlon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c; // * 0.621371 for mi
    return d;
  }

  double deg2rad(deg) {
    return deg * (pi / 180);
  }

  String getButtonTitle() {
    switch (_price) {
      case PriceOptional.small:
        return "Small + \$10";
      case PriceOptional.medium:
        return "Medium + \$30";
      case PriceOptional.large:
        return "Large + \$50";
    }
  }

  @override
  Widget build(BuildContext context) {
    // var distance = getDistance();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(
          "Task Size",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, bottom: 30),
              child: Text(
                "What is your estimated size of your task?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: Column(
              children: <Widget>[
                RadioListTile<PriceOptional>(
                  title: const Text('Small - Est. 1 hr'),
                  value: PriceOptional.small,
                  groupValue: _price,
                  onChanged: (PriceOptional value) {
                    setState(() {
                      _price = value;
                    });
                  },
                ),
                RadioListTile<PriceOptional>(
                  title: const Text('Medium - Est. 2-3 hrs'),
                  value: PriceOptional.medium,
                  groupValue: _price,
                  onChanged: (PriceOptional value) {
                    setState(() {
                      _price = value;
                    });
                  },
                ),
                RadioListTile<PriceOptional>(
                  title: const Text('Large - Est. 4+ hrs'),
                  value: PriceOptional.large,
                  groupValue: _price,
                  onChanged: (PriceOptional value) {
                    setState(() {
                      _price = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  side: BorderSide(color: AppColors.main)),
              onPressed: () {
                Navigator.pushNamed(context, '/select_car_size');
              },
              color: AppColors.main,
              textColor: Colors.white,
              child: Text(getButtonTitle(), style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
