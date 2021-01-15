import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sam_rider_app/src/util/globals.dart';
import 'package:sam_rider_app/src/util/utils.dart';

class SelectWeightPage extends StatefulWidget {
  @override
  _SelectWeightPageState createState() => _SelectWeightPageState();
}

class _SelectWeightPageState extends State<SelectWeightPage> {
  List<LatLng> path = List();

  Widget getMenu(index) {
    // List<Widget> menu = [];
    // WeightOptional.values.forEach((weight) {
    var weight = WeightOptional.values[index];
    var enabled = Globals.carSize.index < 2 || index >= 2;
    return Center(
      child: GestureDetector(
        onTap: () {
          if (enabled) {
            setState(() {
              Globals.weight = weight;
            });
          }
        },
        child: Padding(
          padding: EdgeInsets.all(AppConfig.size(context, 3)),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Globals.weight == weight
                          ? AppColors.main
                          : Colors.grey[200],
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      Globals.weightImages[weight.index],
                      // color: Globals.weight == weight ? Colors.blue : Colors.grey,
                      width: AppConfig.size(context, 28),
                      height: AppConfig.size(context, 28),
                    ),
                    Text(
                      Globals.weightTitles[weight.index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Globals.weight == weight
                              ? AppColors.main
                              : Colors.grey,
                          fontSize: AppConfig.size(context, 5)),
                    )
                  ],
                ),
              ),
              if (!enabled)
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                )
            ],
          ),
        ),
      ),
    );
    // });
    // return menu;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(
          "Loading Requirements",
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
              ),
            ),

            // GridView.count(
            //   crossAxisCount: AppConfig.width(context) < 768 ? 2 : 3,
            //   children: getMenu(),
            // )),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                    side: BorderSide(color: AppColors.main)),
                onPressed: () {
                  Navigator.pushNamed(context, '/driver_list');
                },
                color: AppColors.main,
                textColor: Colors.white,
                child: Text("\$0 Self Load"),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding:
                  EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
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
                    "${Globals.weightTitles[Globals.weight.index]} + \$${Globals.weightPrices[Globals.weight.index]}",
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
