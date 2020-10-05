import 'dart:async';

// ignore: avoid_web_libraries_in_flutter
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sam_rider_app/src/blocs/data_bloc.dart';
import 'package:sam_rider_app/src/ui/widgets/functionalButton.dart';
import 'package:sam_rider_app/src/ui/widgets/home_menu_drawer.dart';
import 'package:sam_rider_app/src/ui/widgets/msg_dialog.dart';
import 'package:sam_rider_app/src/ui/widgets/ride_picker.dart';
import 'package:sam_rider_app/src/util/map_util.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
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
  var state = "select";
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition =
        CameraPosition(zoom: cameraZoom, target: _center);

    if (currentLocation != null && state == "running") {
      print("use current location on widget build");
      initialCameraPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: cameraZoom,
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      bottomSheet: Container(
        height: 300,
        decoration: BoxDecoration(color: Colors.black),
        child: Column(),
      ),
      drawer: Drawer(
        child: HomeMenuDrawer(),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
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
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Column(
              children: <Widget>[
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  leading: FlatButton(
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: RidePicker(_center, onPlaceSelected),
                )
              ],
            ),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FunctionalButton(
                    icon: Icons.work,
                    title: "Work",
                    onPressed: () {
                      request("work");
                    },
                  ),
                  FunctionalButton(
                    icon: Icons.home,
                    title: "Home",
                    onPressed: () {
                      request("home");
                    },
                  ),
                  FunctionalButton(
                    icon: Icons.timer,
                    title: "Zinc Gym",
                    onPressed: () {
                      request("gym");
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void request(String type) {
    if (fromLocation == null || toLocation == null) {
      MsgDialog.showMsgDialog(context, "Request",
          "Please select the starting place and the end place");
      return;
    }
    dataBloc.request(
        type,
        fromLocation.latLng.latitude,
        fromLocation.latLng.longitude,
        toLocation.latLng.latitude,
        toLocation.latLng.longitude, () {
      print("request posted");
    }, (error) => {MsgDialog.showMsgDialog(context, "Request", error)});
  }

  void onPlaceSelected(LocationResult place, bool fromAddress) {
    if (place == null) {
      return;
    }
    var mkId = fromAddress ? "from_address" : "to_address";
    if (fromAddress) {
      fromLocation = place;
    } else {
      toLocation = place;
    }
    print("place selected $mkId");
    _center = place.latLng;
    _addMarker(mkId, place);
    addPolyline();
    moveCamera(_center);
  }

  void moveCamera(LatLng nPos) async {
    final GoogleMapController controller = await _completer.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(zoom: cameraZoom, target: nPos)));
  }

  void _addMarker(String mkId, LocationResult place) async {
    if (place == null) {
      return;
    }
    // remove old
    _markers.remove(mkId);
    //_mapController.clearMarkers();

    Marker marker = Marker(
      markerId: MarkerId(mkId),
      draggable: true,
      position: place.latLng, //LatLng(place.lat, place.lng),
      infoWindow: InfoWindow(title: mkId),
    );

    if (mounted) {
      setState(() {
        if (mkId == "from_address") {
          _markers[0] = (marker);
          List mmmm = _markers;
          print(mmmm);
        } else if (mkId == "to_address") {
          _markers.add(marker);
          List mmmm = _markers;
          print(mmmm);
        }
      });
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
    //routes.clear();
    if (_markers.length > 1) {
      mapUtil
          .getRoutePath(
              LatLng(_markers[0].position.latitude,
                  _markers[0].position.longitude),
              LatLng(_markers[1].position.latitude,
                  _markers[1].position.longitude))
          .then((locations) {
        List<LatLng> path = new List();

        locations.forEach((location) {
          path.add(new LatLng(location.latitude, location.longitude));
        });

        final Polyline polyline = Polyline(
          polylineId: PolylineId(_markers[1].position.latitude.toString() +
              _markers[1].position.longitude.toString()),
          consumeTapEvents: true,
          color: Colors.black,
          width: 2,
          points: path,
        );

        if (mounted) {
          setState(() {
            routes.add(polyline);
          });
        }
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
      });
    }

    _locationService.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = LatLng(cLoc.latitude, cLoc.longitude);
      _center = currentLocation;
      if (fromLocation == null && toLocation == null) {
        moveCamera(_center);
      }
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
