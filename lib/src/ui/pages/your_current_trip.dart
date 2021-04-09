import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'dart:async';

import 'package:sam_rider_app/src/blocs/data_bloc.dart';
import 'package:sam_rider_app/src/util/globals.dart';
import 'package:sam_rider_app/src/util/map_util.dart';
import 'package:sam_rider_app/src/util/utils.dart';

import 'chat.dart';

class YourCurrentTripPage extends StatefulWidget {
  YourCurrentTripPage({Key key, this.data}) : super(key: key);
  dynamic data;
  @override
  _YourCurrentTripPageState createState() =>
      _YourCurrentTripPageState(data: data);
}

class _YourCurrentTripPageState extends State<YourCurrentTripPage> {
  dynamic data;

  _YourCurrentTripPageState({Key key, @required this.data});

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
  double cameraZoom = 15;
  List<LatLng> path = List();
  BitmapDescriptor destinationTargetPinIcon;
  BitmapDescriptor destinationDriverPinIcon;
  Timer timer;
  var isDone = false;
  var isInited = false;
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  // dynamic driverData;
  var isLoadedDriverDetails = false;

  StreamSubscription subscription;
  static final databaseReference = FirebaseDatabase.instance.reference();

  static double currentLatitude = 0.0;
  static double currentLongitude = 0.0;

  @override
  void initState() {
    super.initState();

    initPlatformState();
    setCustomTargetPin();
    setCustomDriverPin();

    subscription = databaseReference
        .child("drivers")
        .child(data["driver_id"])
        .onValue
        .listen((event) async {
      if (!isLoadedDriverDetails) {
        isLoadedDriverDetails = true;
        // driverData = Map<String, String>();
        // driverData["make"] = event.snapshot.value['make'];
        // driverData["color"] = event.snapshot.value['color'];
        // driverData["phone"] = event.snapshot.value['phone'];
        // driverData["model"] = event.snapshot.value['model'];
        // driverData["tag"] = event.snapshot.value['tag'];
        // driverData["year"] = event.snapshot.value['year'];
        // driverData["name"] = event.snapshot.value['name'];
        // driverData["profile"] =
        //     await dataBloc.getProfileImage(event.snapshot.key);
      }
      setState(() {
        currentLatitude = event.snapshot.value['lat'] == null
            ? 0
            : event.snapshot.value['lat'];
        currentLongitude = event.snapshot.value['long'] == null
            ? 0
            : event.snapshot.value['long'];
      });
      moveCamera(LatLng(currentLatitude, currentLongitude));

      _addMarker("is_driver", LatLng(currentLatitude, currentLongitude));
    });
  }

  @override
  void deactivate() {
    // timer.cancel();
    super.deactivate();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void setCustomTargetPin() async {
    destinationTargetPinIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 25),
        'assets/images/destination_icon.png');
  }

  void setCustomDriverPin() async {
    destinationDriverPinIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 25),
        'assets/images/driving_pin.png');
  }

  void initMap() async {
    if (isInited || data["from_lat"] == null) {
      return;
    }
    isInited = true;
    destinationTargetPinIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 25),
        'assets/images/destination_icon.png');
    destinationDriverPinIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 25),
        'assets/images/driving_pin.png');

    moveCamera(LatLng(data["from_lat"], data["from_lon"]));
    _addMarker("from_address", LatLng(data["from_lat"], data["from_lon"]));
    _addMarker("to_address", LatLng(data["to_lat"], data["to_lon"]));
    _addMarker("is_driver", LatLng(currentLatitude, currentLongitude));

    addPolyline();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition =
        CameraPosition(zoom: cameraZoom, target: _center);

    if (data["from_lat"] != null) {
      initialCameraPosition = CameraPosition(
        target: LatLng(currentLatitude, currentLongitude),
        zoom: cameraZoom,
      );
      initMap();
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white70,
        title: Text(
          "Current Job",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _completer.complete(controller);
            },
            markers: Set<Marker>.of(_markers),
            polylines: Set<Polyline>.of(routes),
          ),
          Positioned(
              child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                      width: 350,
                      height: 240,
                      child: AppStyle.requestCard(context, data, onMessage: () {
                        onChat(data["driver_id"], data["profile"]);
                      }))))
        ],
      ),
    );
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
        icon: destinationTargetPinIcon,
        anchor: const Offset(0.1, 1),
      );
      _markers.add(marker);
    } else if (mkId == "is_driver") {
      Marker marker = Marker(
        markerId: MarkerId(mkId),
        draggable: true,
        position: place, //LatLng(place.lat, place.lng),
        infoWindow: InfoWindow(title: mkId),
        icon: destinationDriverPinIcon,
        anchor: const Offset(0.1, 1),
      );
      _markers.add(marker);
    }
    if (mounted) {
      setState(() {});
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
    Globals.path = path;
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
    _locationService.requestPermission().then((value) {
      print(value);
      if (value == null) {
        _locationService.requestPermission().then((value2) {
          _permission = value2;
          if (_permission == PermissionStatus.granted) {
            // getLocation();
          }
        });
      }
      _permission = value;
      if (_permission == PermissionStatus.granted) {
        // getLocation();
      }
      return null;
    });
  }

  requestPermissions(serviceStatus) async {
    try {
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission == PermissionStatus.granted) {
          // getLocation();
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
