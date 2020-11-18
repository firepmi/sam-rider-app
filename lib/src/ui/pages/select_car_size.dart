import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sam_rider_app/src/util/globals.dart';
import 'package:sam_rider_app/src/util/utils.dart';

class SelectCarSizePage extends StatefulWidget {
  @override
  _SelectCarSizePageState createState() => _SelectCarSizePageState();
}

class _SelectCarSizePageState extends State<SelectCarSizePage> {
  List<LatLng> path = List();
  CarSizeOptional _car = CarSizeOptional.autoMobile;
  var titles = [
    "AUTOMOBILE",
    "SUV",
    "PICKUP",
    "VAN",
    "TRUCK & TRAILER",
    "TRUCK",
  ];
  var icons = [
    'assets/svg/automobile.svg',
    'assets/svg/suv.svg',
    'assets/svg/pickup.svg',
    'assets/svg/van.svg',
    'assets/svg/trailer.svg',
    'assets/svg/truck.svg',
  ];
  var images = [
    'assets/images/car_option1.png',
    'assets/images/car_option2.png',
    'assets/images/car_option3.png',
    'assets/images/car_option4.png',
    'assets/images/car_option5.png',
    'assets/images/car_option6.png',
  ];
  var prices = [0, 5, 7, 25, 50, 75];
  @override
  void initState() {
    super.initState();
  }

  List<Widget> getMenu() {
    List<Widget> menu = [];
    CarSizeOptional.values.forEach((car) {
      menu.add(
        Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                Globals.carSize = car;
              });
            },
            child: Padding(
                padding: EdgeInsets.all(AppConfig.size(context, 3)),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Globals.carSize == car
                              ? Colors.blue
                              : Colors.grey[200],
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset(
                            images[car.index],
                            // color: Globals.weight == weight ? Colors.blue : Colors.grey,
                            width: AppConfig.size(context, 30),
                            height: AppConfig.size(context, 30),
                          ),
                        ),
                        Text(
                          titles[car.index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Globals.carSize == car
                                  ? Colors.blue
                                  : Colors.grey,
                              fontSize: AppConfig.size(context, 5)),
                        )
                      ],
                    ))),
          ),
        ),
      );
    });
    return menu;
  }

  @override
  Widget build(BuildContext context) {
    // var distance = getDistance();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(
          "Car Size",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30, bottom: 30),
              child: Text(
                "What kind of vehicle does this job require?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: Padding(
              padding:
                  EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
              child: GridView.count(
                crossAxisCount: AppConfig.width(context) < 768 ? 2 : 3,
                children: getMenu(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  side: BorderSide(color: AppColors.main)),
              onPressed: () {
                Globals.carSize = _car;
                Navigator.pushNamed(context, '/select_weight');
              },
              color: AppColors.main,
              textColor: Colors.white,
              child: Text(
                  "${titles[Globals.carSize.index]} + \$${prices[Globals.carSize.index]}",
                  style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
