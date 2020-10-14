import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sam_rider_app/src/util/utils.dart';

enum PriceOptional { l25, l50, l75, g75 }

class SelectDriversPage extends StatefulWidget {
  @override
  _SelectDriversPageState createState() => _SelectDriversPageState();
}

class _SelectDriversPageState extends State<SelectDriversPage> {
  List<LatLng> path = List();
  PriceOptional _price = PriceOptional.l25;

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

  @override
  Widget build(BuildContext context) {
    path = ModalRoute.of(context).settings.arguments;
    var distance = getDistance();
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
          Container(
            padding: EdgeInsets.only(left: 40, right: 40, bottom: 15, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Estimated Distance",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                Text(
                  "${distance.toStringAsFixed(2)} km",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: Column(
              children: <Widget>[
                RadioListTile<PriceOptional>(
                  title: const Text('Less than 25\$/hr'),
                  value: PriceOptional.l25,
                  groupValue: _price,
                  onChanged: (PriceOptional value) {
                    setState(() {
                      _price = value;
                    });
                  },
                ),
                RadioListTile<PriceOptional>(
                  title: const Text('25\$/hr to 50\$/hr'),
                  value: PriceOptional.l50,
                  groupValue: _price,
                  onChanged: (PriceOptional value) {
                    setState(() {
                      _price = value;
                    });
                  },
                ),
                RadioListTile<PriceOptional>(
                  title: const Text('50\$/hr to 75\$/hr'),
                  value: PriceOptional.l75,
                  groupValue: _price,
                  onChanged: (PriceOptional value) {
                    setState(() {
                      _price = value;
                    });
                  },
                ),
                RadioListTile<PriceOptional>(
                  title: const Text('Higher than 75\$/hr'),
                  value: PriceOptional.g75,
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
                Navigator.pushNamed(context, '/driver_list', arguments: _price);
              },
              color: AppColors.main,
              textColor: Colors.white,
              child: Text("See Drivers and prices",
                  style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
