import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:sam_rider_app/src/blocs/data_bloc.dart';
import 'package:sam_rider_app/src/util/globals.dart';
import 'package:sam_rider_app/src/util/utils.dart';

class DriverListPage extends StatefulWidget {
  @override
  _DriverListPageState createState() => _DriverListPageState();
}

class _DriverListPageState extends State<DriverListPage> {
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  double _fontSize = 14;
  List _items;
  DataBloc dataBloc = DataBloc();
  // Allows you to get a list of all the ItemTags
  void _getAllItem() {
    List<Item> lst = _tagStateKey.currentState?.getAllItem;
    if (lst != null)
      lst.where((a) => a.active == true).forEach((a) => print(a.title));
  }

  void setTag() {
    _items = List();

    switch (Globals.carSize) {
      case CarSizeOptional.trailer:
        _items.add("Truck & Trailer");
        break;
      case CarSizeOptional.autoMobile:
        _items.add("Automobile");
        break;
      case CarSizeOptional.suv:
        _items.add("SUV");
        break;
      case CarSizeOptional.pickup:
        _items.add("Pickup");
        break;
      case CarSizeOptional.van:
        _items.add("VAN");
        break;
      case CarSizeOptional.truck:
        _items.add("Truck");
        break;
    }
    switch (Globals.weight) {
      case WeightOptional.option1:
        _items.add("1 smll item");
        break;
      case WeightOptional.option2:
        _items.add("Multiple small items in car");
        break;
      case WeightOptional.option3:
        _items.add("Large items in car");
        break;
      case WeightOptional.option4:
        _items.add("Truck loading");
        break;
      case WeightOptional.option5:
        _items.add("Trailer loading:");
        break;
      case WeightOptional.option6:
        _items.add("Box truck loading");
        break;
    }
  }

  List<Widget> drivers = List<Widget>();
  List<Map> driverData = [];
  @override
  void initState() {
    super.initState();
    getDrivers();
  }

  void getDrivers() async {
    driverData = [];

    DataSnapshot data = await dataBloc.getDrivers();
    Map<String, dynamic> mapOfMaps = Map.from(data.value);

    mapOfMaps.forEach((key, value) async {
      print(key);
      print(value);
      value["driver_id"] = key;
      value["rate"] = 47.5;
      value["star"] = 4.6;
      value["reviews"] = 96;
      value["jobs"] = 149;
      value["id"] = key;
      value["aboutme"] =
          "Hello Client, I have been driving for over 8 years now. It nothing to small or big for me.";
      value["profile"] = await dataBloc.getProfileImage(key);
      driverData.add(value);
      refreshView();
    });

    //
    // print(data.value);
    //
    // dynamic d = Map();
    // d["name"] = "Dejuante E.";
    // d["rate"] = 47.5;
    // d["star"] = 4.6;
    // d["reviews"] = 96;
    // d["jobs"] = 149;
    // d["aboutme"] =
    //     "Hello Client, I have been driving for over 8 years now. It nothing to small or big for me.";
    // driverData.add(d);
    // d = Map();
    // d["name"] = "Andrew A.";
    // d["rate"] = 35.29;
    // d["star"] = 4.9;
    // d["reviews"] = 49;
    // d["jobs"] = 60;
    // d["aboutme"] = "Professional driver experience";
    // driverData.add(d);
  }

  void refreshView() {
    drivers = [];
    driverData.forEach((element) {
      print(element);
      drivers.add(
        GestureDetector(
          onTap: () {
            print(element);
            Navigator.pushNamed(context, '/driver_profile', arguments: element);
          },
          child: Column(children: [
            Row(children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: element["profile"] != null
                    ? ClipOval(
                        child: FadeInImage.assetNetwork(
                          image: element["profile"],
                          placeholder: 'assets/images/default_profile.png',
                          // "assets/images/default_profile.png",
                          width: AppConfig.size(context, 35),
                          height: AppConfig.size(context, 35),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        "assets/images/default_profile.png",
                        width: AppConfig.size(context, 35),
                        height: AppConfig.size(context, 35),
                        fit: BoxFit.cover,
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            element["name"],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "\$${element["rate"]}/hr",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ]),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        Text(
                          "${element["star"]}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "(${element["reviews"]} reviews)",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${element["jobs"]} Furniture Assembly jobs",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ]),
                ),
              ),
            ]),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  element["aboutme"],
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),
            Divider()
          ]),
        ),
      );
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    setTag();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white70,
          title: Text(
            "Select a Driver",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Tags(
                  key: _tagStateKey,
                  // textField: TagsTextField(
                  //   textStyle: TextStyle(fontSize: _fontSize),
                  //   constraintSuggestion: false, suggestions: [],
                  //   //width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 10),
                  //   // onSubmitted: (String str) {
                  //   //   // Add item to the data source.
                  //   //   setState(() {
                  //   //     // required
                  //   //     _items.add(str);
                  //   //   });
                  //   // },
                  // ),
                  itemCount: _items.length, // required
                  itemBuilder: (int index) {
                    final String item = _items[index];

                    return ItemTags(
                      // Each ItemTags must contain a Key. Keys allow Flutter to
                      // uniquely identify widgets.
                      key: Key(index.toString()),
                      index: index, // required
                      title: item,
                      active: true,
                      // customData: item.customData,
                      textStyle: TextStyle(
                        fontSize: _fontSize,
                      ),
                      combine: ItemTagsCombine.withTextBefore,
                      // icon: ItemTagsIcon(
                      //   icon: Icons.add,
                      // ), // OR null,
                      // removeButton: ItemTagsRemoveButton(
                      //   onRemoved: () {
                      //     // Remove the item from the data source.
                      //     setState(() {
                      //       // required
                      //       _items.removeAt(index);
                      //     });
                      //     //required
                      //     return true;
                      //   },
                      // ), // OR null,
                      onPressed: (item) => print(item),
                      onLongPressed: (item) => print(item),
                      activeColor: AppColors.main,
                      color: AppColors.main,
                    );
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    width: 50,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text("Sorted by Recommended"),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    width: 50,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Column(children: drivers),
          ],
        ));
  }
}
