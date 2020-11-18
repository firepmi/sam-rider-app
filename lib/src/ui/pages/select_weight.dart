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

  var titles = [
    "1 Small item",
    "Multiple small items in car",
    "Large item in car",
    "Truck loading",
    "Trailer loading",
    "Box truck loading",
  ];
  var images = [
    'assets/images/weight_option1.png',
    'assets/images/weight_option2.png',
    'assets/images/weight_option3.png',
    'assets/images/weight_option4.png',
    'assets/images/weight_option5.png',
    'assets/images/weight_option6.png',
  ];

  List<Widget> getMenu() {
    List<Widget> menu = [];
    WeightOptional.values.forEach((weight) {
      menu.add(Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              Globals.weight = weight;
            });
          },
          child: Padding(
            padding: EdgeInsets.all(AppConfig.size(context, 3)),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Globals.weight == weight
                        ? Colors.blue
                        : Colors.grey[200],
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    images[weight.index],
                    // color: Globals.weight == weight ? Colors.blue : Colors.grey,
                    width: AppConfig.size(context, 28),
                    height: AppConfig.size(context, 28),
                  ),
                  Text(
                    titles[weight.index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Globals.weight == weight
                            ? Colors.blue
                            : Colors.grey,
                        fontSize: AppConfig.size(context, 5)),
                  )
                ],
              ),
            ),
          ),
        ),
      ));
    });
    return menu;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Padding(
              padding:
                  EdgeInsets.only(top: 30, bottom: 30, right: 20, left: 20),
              child: Text(
                "What is the Weight Lifting Requirements for this job?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
                )),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  side: BorderSide(color: AppColors.main)),
              onPressed: () {
                Navigator.pushNamed(context, '/driver_list');
              },
              color: AppColors.main,
              textColor: Colors.white,
              child: Text(
                  "${titles[Globals.weight.index]} + \$${Globals.weight_prices[Globals.weight.index]}",
                  style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
