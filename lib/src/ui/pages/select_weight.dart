import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sam_rider_app/src/util/globals.dart';
import 'package:sam_rider_app/src/util/utils.dart';

class SelectWeightPage extends StatefulWidget {
  @override
  _SelectWeightPageState createState() => _SelectWeightPageState();
}

class _SelectWeightPageState extends State<SelectWeightPage> {
  List<LatLng> path = List();
  WeightOptional _weight = WeightOptional.pound1to5;

  String getButtonTitle() {
    switch (_weight) {
      case WeightOptional.pound1to5:
        return "5 pounds + \$5";
      case WeightOptional.pound6to49:
        return "30 pounds + \$30";
      case WeightOptional.pound50more:
        return "50 pounds + \$50";
    }
    return "Please select weight option";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(
          "Weight",
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
                "What is the Weight Lifting Requirements for this job?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: Column(
              children: <Widget>[
                RadioListTile<WeightOptional>(
                  title: const Text('1 - 5 pounds'),
                  value: WeightOptional.pound1to5,
                  groupValue: _weight,
                  onChanged: (WeightOptional value) {
                    setState(() {
                      _weight = value;
                    });
                  },
                ),
                RadioListTile<WeightOptional>(
                  title: const Text('6 - 49 pounds'),
                  value: WeightOptional.pound6to49,
                  groupValue: _weight,
                  onChanged: (WeightOptional value) {
                    setState(() {
                      _weight = value;
                    });
                  },
                ),
                RadioListTile<WeightOptional>(
                  title: const Text('50+ pounds'),
                  value: WeightOptional.pound50more,
                  groupValue: _weight,
                  onChanged: (WeightOptional value) {
                    setState(() {
                      _weight = value;
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
                Globals.weight = _weight;
                Navigator.pushNamed(context, '/driver_list');
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
