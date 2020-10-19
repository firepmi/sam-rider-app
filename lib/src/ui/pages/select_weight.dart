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
  WeightOptional _weight = WeightOptional.option1;

  String getButtonTitle() {
    switch (_weight) {
      case WeightOptional.option1:
        return "Automobile + \$0";
      case WeightOptional.option2:
        return "SUV + \$7";
      case WeightOptional.option3:
        return "Pickup + \$25";
      case WeightOptional.option4:
        return "Truck + \$50";
      case WeightOptional.option5:
        return "Trailer + \$50";
      case WeightOptional.option6:
        return "Box Truck + \$75";
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
                  title: const Text('1 Small item'),
                  value: WeightOptional.option1,
                  groupValue: _weight,
                  onChanged: (WeightOptional value) {
                    setState(() {
                      _weight = value;
                    });
                  },
                ),
                RadioListTile<WeightOptional>(
                  title: const Text('Multiple small items in car'),
                  value: WeightOptional.option2,
                  groupValue: _weight,
                  onChanged: (WeightOptional value) {
                    setState(() {
                      _weight = value;
                    });
                  },
                ),
                RadioListTile<WeightOptional>(
                  title: const Text('Large item in car'),
                  value: WeightOptional.option3,
                  groupValue: _weight,
                  onChanged: (WeightOptional value) {
                    setState(() {
                      _weight = value;
                    });
                  },
                ),
                RadioListTile<WeightOptional>(
                  title: const Text('Truck Loading'),
                  value: WeightOptional.option4,
                  groupValue: _weight,
                  onChanged: (WeightOptional value) {
                    setState(() {
                      _weight = value;
                    });
                  },
                ),
                RadioListTile<WeightOptional>(
                  title: const Text('Trailer Loading'),
                  value: WeightOptional.option5,
                  groupValue: _weight,
                  onChanged: (WeightOptional value) {
                    setState(() {
                      _weight = value;
                    });
                  },
                ),
                RadioListTile<WeightOptional>(
                  title: const Text('Box Truck Loading'),
                  value: WeightOptional.option6,
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
