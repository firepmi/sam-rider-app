import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sam_rider_app/src/util/utils.dart';

class DriverProfilePage extends StatefulWidget {
  @override
  _DriverProfilePageState createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends State<DriverProfilePage> {
  dynamic data;
  List<num> percentData = [0.9, 0.1, 0.0, 0.0, 0.03];
  List<num> reviewData = [45, 3, 0, 0, 1];

  @override
  void initState() {

    super.initState();
  }

  void goNext(){
    Navigator.pushNamed(context, '/checkout', arguments: data);
  }
  Widget starRatingPercentItemView(int star) {
    return Row(
      children: [
        Text("$star", style: TextStyle(color: Colors.grey, fontSize: 16)),
        Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Icon(Icons.star, color: Colors.yellow),
        ),
        Expanded(
          child: LinearPercentIndicator(
            lineHeight: 14,
            percent: percentData[5 - star].toDouble(),
            backgroundColor: Colors.blueGrey[100],
            progressColor: AppColors.main,
          ),
        ),
        Text("(${reviewData[5 - star]})"),
      ],
    );
  }

  Widget feedbackDetails() {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              child: ClipOval(
                child: data["profile"] != null
                    ? FadeInImage.assetNetwork(
                        image: data["profile"],
                        placeholder: 'assets/images/default_profile.png',
                        // "assets/images/default_profile.png",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/images/default_profile.png",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
              ),
              radius: 25,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Clarence",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Mon, Oct 05, 2020",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            RatingBar.builder(
              onRatingUpdate: (value) {},
              minRating: 1,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 30,
              itemBuilder: (context, _) =>
                  Icon(Icons.star, color: Colors.yellow),
              initialRating: 1,
              tapOnlyMode: false,
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Why are you charing me?",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    // goNext();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white70,
          title: Text(
            "Driver Profile",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: ListView(children: [
                  Row(children: [
                    data["profile"] != null
                        ? FadeInImage.assetNetwork(
                            image: data["profile"],
                            placeholder: 'assets/images/default_profile.png',
                            // "assets/images/default_profile.png",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/images/default_profile.png",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data["name"],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              Text(
                                "${data["star"]}",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "(${data["reviews"]} reviews)",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${data["jobs"]} Furniture Assembly jobs",
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        ]),
                      ),
                    ),
                  ]),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 10),
                  Text(
                    "How I can Help",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      data["aboutme"] == null
                          ? "No Information"
                          : data["aboutme"],
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Driver Reviews",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Colors.yellow),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Text(
                        "${data["star"]}",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "(${data["reviews"]} reviews)",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  starRatingPercentItemView(5),
                  starRatingPercentItemView(4),
                  starRatingPercentItemView(3),
                  starRatingPercentItemView(2),
                  starRatingPercentItemView(1),
                  SizedBox(height: 30),
                  feedbackDetails()
                ]),
              ),
            ),
            Column(
              children: [
                Divider(),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${data["rate"]}/hr",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ButtonTheme(
                        minWidth: 200,
                        height: 60,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/checkout',
                                arguments: data);
                          },
                          color: AppColors.main,
                          textColor: Colors.white,
                          child: Text("Select", style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
