import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sam_rider_app/src/util/globals.dart';
import 'package:sam_rider_app/src/util/utils.dart';

class SelectCarSizePage extends StatefulWidget {
  @override
  _SelectCarSizePageState createState() => _SelectCarSizePageState();
}

class _SelectCarSizePageState extends State<SelectCarSizePage> {
  List<LatLng> path = List();

  @override
  void initState() {
    super.initState();
  }

  Widget getMenu(index) {
    var car = CarSizeOptional.values[index];
    return Center(
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
                          ? AppColors.main
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
                        Globals.carImages[car.index],
                        // color: Globals.weight == weight ? Colors.blue : Colors.grey,
                        width: AppConfig.size(context, 30),
                        height: AppConfig.size(context, 30),
                      ),
                    ),
                    Text(
                      Globals.carNames[car.index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Globals.carSize == car
                              ? AppColors.main
                              : Colors.grey,
                          fontSize: AppConfig.size(context, 5)),
                    )
                  ],
                ))),
      ),
    );
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
              padding: EdgeInsets.only(top: 30),
              child: Text(
                "What kind of vehicle",
                textAlign: TextAlign.center,
                style: AppStyle.introStyle1(context),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 5, bottom: 10),
              child: Text(
                "does this job require?",
                textAlign: TextAlign.center,
                style: AppStyle.introStyle2(context),
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 12,
                  itemCount: Globals.carNames.length,
                  itemBuilder: (BuildContext context, int index) =>
                      getMenu(index),
                  staggeredTileBuilder: (int index) => StaggeredTile.count(
                      index == Globals.carNames.length - 1
                          ? 12
                          : AppConfig.width(context) < 768
                              ? 6
                              : 4,
                      AppConfig.width(context) < 768 ? 6 : 4),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                )
                // GridView.count(
                //   crossAxisCount: AppConfig.width(context) < 768 ? 2 : 3,
                //   children: getMenu(),
                // ),
                ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  side: BorderSide(color: AppColors.main)),
              onPressed: () {
                // if (Globals.carSize.index >= 2 && Globals.weight.index < 2) {
                //   Globals.weight = WeightOptional.option3;
                // }
                Globals.weight = WeightOptional.values[Globals.carSize.index];
                Navigator.pushNamed(context, '/select_weight');
              },
              color: AppColors.main,
              textColor: Colors.white,
              child: Text(
                  "${Globals.carNames[Globals.carSize.index]} + \$${Globals.carPrices[Globals.carSize.index]}",
                  style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
