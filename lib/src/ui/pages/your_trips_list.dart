import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:sam_rider_app/src/blocs/data_bloc.dart';
import 'package:sam_rider_app/src/ui/pages/your_current_trip.dart';
import 'package:sam_rider_app/src/util/utils.dart';

import 'chat.dart';
import 'home.dart';

class YourTripsList extends StatefulWidget {
  @override
  _YourTripsListPageState createState() => _YourTripsListPageState();
}

class _YourTripsListPageState extends State<YourTripsList> {
  // final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  double _fontSize = 14;
  // List _items;
  final DataBloc dataBloc = DataBloc();

  List<Widget> requests = List<Widget>();
  List<Map> requestsData = [];

  @override
  void initState() {
    super.initState();
    getRequestsList();
  }

  void getRequestsList() async {
    requestsData = [];
    dataBloc.getRequestsList(onRequestResults);
  }

  void onRequestResults(dynamic data) {
    if (data == []) {
      // Navigator.pushNamed(context, '/home');
    } else {
      requestsData = data;
      refreshView();
    }
  }

  // Future<String> getProfileImage(String id) async {
  //   var profileUrl = "";
  //
  //   final ref =
  //       FirebaseStorage.instance.ref().child("profile").child(id + ".jpg");
  //   try {
  //     profileUrl = (await ref.getDownloadURL()).toString();
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //
  //   return profileUrl;
  // }

  void getRequestsInfo(String clientId, dynamic element) {
    // if (clientData != null) return;

    // dataBloc.getDriverProfile(clientId, (client) async {
    // client["profile_url"] = await getProfileImage(clientId);

    requests.add(
      GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => YourCurrentTripPage(
                        data: element,
                      )));
        },
        child: Container(
            child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          // color: Colors.pink,
          elevation: 10,
          margin: const EdgeInsets.all(15.0),
          child: Column(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: element["profile"] != null || element["profile"] != ""
                    ? ClipOval(
                        child: FadeInImage.assetNetwork(
                          image: element["profile"],
                          placeholder: 'assets/images/default_profile.png',
                          // "assets/images/default_profile.png",
                          width: AppConfig.size(context, 30),
                          height: AppConfig.size(context, 30),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        "assets/images/default_profile.png",
                        width: AppConfig.size(context, 30),
                        height: AppConfig.size(context, 30),
                        fit: BoxFit.cover,
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            element["name"] == null ? "Boss" : element["name"],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "\$ ${element["price"]}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ]),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          element["phone"] == null
                              ? "123456"
                              : element["phone"],
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
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
                      child: AppStyle.label(
                        context,
                        "Status: ${element != null && element['status'] != null ? element['status'] : ''} ",
                        size: 6,
                        top: 8,
                        bottom: 8,
                      ),
                    ),
                  ]),
                ),
              ),
            ]),
            AppStyle.borderButton(
              context,
              "Message",
              130,
              130,
              30,
              30,
              onPressed: () {
                onChat(clientId, element["profile"]);
              },
            ),
          ]),
        )),
      ),
    );

    setState(() {});
    // });
  }

  void refreshView() {
    requests = [];
    requestsData.forEach((element) {
      getRequestsInfo(element["driver_id"], element);
    });
  }

  void onChat(String clientId, String clientAvatar) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
                  peerId: clientId,
                  peerAvatar: clientAvatar,
                )));
  }

  void onReject(final String requestID, final int index) {
    // AppConfig.showAlertDialog(context, "Are you sure?", "", () {
    //   dataBloc.rejectOffer(requestID, () {
    //     getRequests();
    //     requests.removeAt(index);
    //     setState(() {});
    //   }, (error) {
    //     AppConfig.showAlertDialog(context, "Order request error", "", () {});
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    // setTag();
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white70,
        title: Text(
          "Requests",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: new ListView.builder(
          itemCount: requests.length,
          itemBuilder: (BuildContext ctxt, int index) => requests[index]),
    );
  }
}
