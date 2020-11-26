import 'dart:async';

// ignore: avoid_web_libraries_in_flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:sam_rider_app/src/blocs/data_bloc.dart';
import 'package:sam_rider_app/src/util/globals.dart';
import 'package:sam_rider_app/src/util/map_util.dart';
import 'package:sam_rider_app/src/util/utils.dart';

class RequestDetailsPage extends StatefulWidget {
  RequestDetailsPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _RequestDetailsPageState createState() => _RequestDetailsPageState();
}

class _RequestDetailsPageState extends State<RequestDetailsPage> {
  _RequestDetailsPageState();
  Completer<GoogleMapController> _completer = Completer();
  MapUtil mapUtil = MapUtil();
  Location _locationService = new Location();
  LatLng currentLocation;
  LatLng _center = LatLng(45.1975844, -122.9598339);
  PermissionStatus _permission = PermissionStatus.denied;
  List<Marker> _markers = List();
  List<Polyline> routes = new List();
  bool done = false;
  String error;
  DataBloc dataBloc = DataBloc();
  LocationResult fromLocation, toLocation;
  double cameraZoom = 13;
  List<LatLng> path = List();
  BitmapDescriptor destinationPinIcon;
  Timer timer;
  dynamic data;
  var isDone = false;
  var isInited = false;
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  @override
  void initState() {
    super.initState();
    initPlatformState();
    setCustomMapPin();

    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (isDone)
        timer.cancel();
      else {
        getRequestDetails();
      }
    });
  }

  @override
  void deactivate() {
    timer.cancel();
    super.deactivate();
  }

  void getRequestDetails() {
    if (data == null) return;
    var id = data["data_id"];
    print(id);
    dataBloc.getRequestStatus(id, (status) {
      print(status);
      data["status"] = status;
      if (status == "done") {
        isDone = true;
      }
      setState(() {});
    });
  }

  void setCustomMapPin() async {
    destinationPinIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 25),
        'assets/images/destination_icon.png');
  }

  void initMap() async {
    if (isInited || data["from_lat"] == null) {
      return;
    }
    isInited = true;
    destinationPinIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 25),
        'assets/images/destination_icon.png');
    moveCamera(LatLng(data["from_lat"], data["from_lon"]));
    _addMarker("from_address", LatLng(data["from_lat"], data["from_lon"]));
    _addMarker("to_address", LatLng(data["to_lat"], data["to_lon"]));
    addPolyline();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    CameraPosition initialCameraPosition =
        CameraPosition(zoom: cameraZoom, target: _center);

    if (data["from_lat"] != null) {
      initialCameraPosition = CameraPosition(
        target: LatLng(data["from_lat"], data["from_lon"]),
        zoom: cameraZoom,
      );
      initMap();
    }
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColors.main,
          elevation: 0.0,
          title: Text("Request"),
          leading: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.keyboard_arrow_left,
              // Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: AppConfig.size(context, 100),
              child: GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _completer.complete(controller);
                },
                markers: Set<Marker>.of(_markers),
                polylines: Set<Polyline>.of(routes),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: [
                    AppStyle.label(
                      context,
                      "Status: ${data != null ? data['status'] : ''} ",
                      top: 20,
                      bottom: 20,
                    ),
                    Divider(),
                    AppStyle.label(context, "Driver Info:",
                        size: 7, bottom: 10),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    data["name"],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${data["phone"]}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
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
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        data["aboutme"],
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                    AppStyle.label(context,
                        "Price: \$${oCcy.format(double.parse(data != null ? data['price'] : '0'))} ",
                        top: 0, bottom: 20, left: 20, right: 20),
                    AppStyle.label(context,
                        "Car Size: ${Globals.carNames[data != null ? data['car_size'] : 0]} ",
                        top: 0, bottom: 20, left: 20, right: 20),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  // void onPlaceSelected(LocationResult place, bool fromAddress) {
  //   if (place == null) {
  //     return;
  //   }
  //   var mkId = fromAddress ? "from_address" : "to_address";
  //   if (fromAddress) {
  //     fromLocation = place;
  //   } else {
  //     toLocation = place;
  //   }
  //   print("place selected $mkId");
  //   _center = place.latLng;
  //   _addMarker(mkId, place);
  //   addPolyline();
  //   moveCamera(_center);
  // }

  void moveCamera(LatLng nPos) async {
    final GoogleMapController controller = await _completer.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(zoom: cameraZoom, target: nPos)));
  }

  void _addMarker(String mkId, LatLng place) async {
    if (place == null) {
      return;
    }
    // remove old
    _markers.remove(mkId);
    //_mapController.clearMarkers();

    if (mkId == "from_address") {
      Marker marker = Marker(
        markerId: MarkerId(mkId),
        draggable: true,
        position: place, //LatLng(place.lat, place.lng),
        infoWindow: InfoWindow(title: mkId),
      );
      if (_markers.length == 0) {
        _markers.add(marker);
      } else {
        _markers[0] = (marker);
      }
      List mmmm = _markers;
      print(mmmm);
    } else if (mkId == "to_address") {
      Marker marker = Marker(
        markerId: MarkerId(mkId),
        draggable: true,
        position: place, //LatLng(place.lat, place.lng),
        infoWindow: InfoWindow(title: mkId),
        icon: destinationPinIcon,
        anchor: const Offset(0.1, 1),
      );
      _markers.add(marker);
      List mmmm = _markers;
      print(mmmm);
    }
    if (mounted) {
      setState(() {});
    }
  }

  getCurrentLocation() async {
    currentLocation = await mapUtil.getCurrentLocation();
    _center = LatLng(currentLocation.latitude, currentLocation.longitude);
    Marker marker = Marker(
      markerId: MarkerId('location'),
      position: _center,
      infoWindow: InfoWindow(title: 'My Location'),
    );
    if (mounted) {
      setState(() {
        print("set current location");
        _markers.add(marker);
      });
    }
  }

  addPolyline() async {
    if (data["path"] == null) return;

    path = new List();

    var points = data["path"].toString().split(",");
    for (int i = 0; i < points.length - 1; i += 2) {
      path.add(
          new LatLng(double.parse(points[i]), double.parse(points[i + 1])));
    }
    final Polyline polyline = Polyline(
      polylineId: PolylineId(_markers[1].position.latitude.toString() +
          _markers[1].position.longitude.toString()),
      consumeTapEvents: true,
      color: Colors.black,
      width: 2,
      points: path,
    );
    routes.add(polyline);
    if (mounted) {
      setState(() {
        print("add polyline");
      });
    }
  }

  initPlatformState() async {
    // await _locationService.changeSettings(
    //     accuracy: LocationAccuracy.high, interval: 1000);

    // LocationData location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // _locationService.serviceEnabled().then((serviceStatus) {
    //   requestPermissions(serviceStatus);
    //   return null;
    // });

    _locationService.requestPermission().then((value) {
      print(value);
      if (value == null) {
        _locationService.requestPermission().then((value2) {
          _permission = value2;
          if (_permission == PermissionStatus.granted) {
            getLocation();
          }
        });
      }
      _permission = value;
      if (_permission == PermissionStatus.granted) {
        getLocation();
      }
      return null;
    });
  }

  getLocation() async {
    LocationData location;
    location = await _locationService.getLocation();
    Marker marker = Marker(
      markerId: MarkerId('from_address'),
      position: LatLng(location.latitude, location.longitude),
      infoWindow: InfoWindow(title: 'My location'),
    );
    if (mounted) {
      setState(() {
        currentLocation = LatLng(location.latitude, location.longitude);
        _center = LatLng(currentLocation.latitude, currentLocation.longitude);
        _markers.add(marker);
        done = true;
        // moveCamera(_center);
      });
    }

    _locationService.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = LatLng(cLoc.latitude, cLoc.longitude);
      _center = currentLocation;
      // if (fromLocation == null && toLocation == null) {
      //   moveCamera(_center);
      // }
    });
  }

  requestPermissions(serviceStatus) async {
    try {
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission == PermissionStatus.granted) {
          getLocation();
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      //location = null;
    }
  }
}
