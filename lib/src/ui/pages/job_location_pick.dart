import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sam_rider_app/src/blocs/data_bloc.dart';
import 'package:sam_rider_app/src/ui/widgets/home_menu_drawer.dart';
import 'package:sam_rider_app/src/ui/widgets/ride_picker.dart';
import 'package:sam_rider_app/src/util/globals.dart';
import 'package:sam_rider_app/src/util/map_util.dart';

class JobLocationPickPage extends StatefulWidget {
  JobLocationPickPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _JobLocationPickPageState createState() => _JobLocationPickPageState();
}

class _JobLocationPickPageState extends State<JobLocationPickPage> {
  _JobLocationPickPageState();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  Completer<GoogleMapController> _completer = Completer();
  MapUtil mapUtil = MapUtil();
  Location _locationService = new Location();
  LatLng currentLocation;
  LatLng _center = LatLng(45.1975844, -122.9598339);
  PermissionStatus _permission = PermissionStatus.denied;
  List<Marker> _markers = List();
  List<Polyline> routes = List();
  bool done = false;
  String error;
  DataBloc dataBloc = DataBloc();
  LocationResult fromLocation, toLocation;
  List<LocationResult> middleLocations = [];
  double cameraZoom = 13;
  var state = "select";
  List<LatLng> path = List();
  BitmapDescriptor destinationPinIcon;
  Timer timer;
  @override
  void initState() {
    super.initState();
    initPlatformState();
    setCustomMapPin();
  }

  void checkMyRequests() {
    if (timer == null || !timer.isActive) {
      timer = Timer.periodic(Duration(seconds: 5), (timer) {
        // print("is Waiting : ${Globals.isWaiting}");
        if (!Globals.isWaiting)
          timer.cancel();
        else {
          dataBloc.getRequests(onRequestResults);
          Globals.isWaiting = false;
        }
      });
    }
  }

  void onRequestResults(dynamic data) {
    print("get request results");
    Globals.isWaiting = false;
    Navigator.pushNamed(context, '/request_details', arguments: data);
  }

  void setCustomMapPin() async {
    destinationPinIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 25),
        'assets/images/destination_icon.png');
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition =
        CameraPosition(zoom: cameraZoom, target: _center);

    // checkMyRequests();

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
                        // Navigator.pop(context);
                        _scaffoldKey.currentState.openDrawer();
                      },
                      child: Icon(
                        Icons.menu,
                        // Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: RidePicker(_center, onPlaceSelected, Globals.stops),
                  )
                ],
              ),
            ),
            Positioned(
                bottom: 40,
                left: 20,
                child: RawMaterialButton(
                  onPressed: () {
                    setState(() {
                      Globals.stops++;
                    });
                    print(Globals.stops);
                  },
                  elevation: 2.0,
                  fillColor: Colors.white,
                  child: Icon(
                    Icons.add,
                    size: 35.0,
                  ),
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                ))
          ],
        ));
  }

  void request() {
    if (fromLocation == null || toLocation == null) {
      print("from location or to location is null");
      // MsgDialog.showMsgDialog(context, "Request",
      //     "Please select the starting place and the end place");
      return;
    }
    print("request");
    if (path == null || path.length < 2) {
      // MsgDialog.showMsgDialog(context, "Request", "Path not found");
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Request"),
                content: Text("Path not found"),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop("cancel");
                    },
                    child: Text("Select Again"),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop("go");
                      onRequest();
                    },
                    child: Text("Go anyway"),
                  ),
                ],
              ));
      return;
    }
    onRequest();
  }

  void onRequest() {
    Globals.fromLocation = fromLocation;
    Globals.toLocation = toLocation;
    Globals.path = path;
    Navigator.pushNamed(context, '/select_car_size');
  }

  void onPlaceSelected(LocationResult place, int locationIndex) {
    if (place == null) {
      print("place is null");
      return;
    }
    var mkId = locationIndex == 0
        ? "from_address"
        : locationIndex == -1
            ? "to_address"
            : "middle_address$locationIndex";
    if (locationIndex == 0) {
      fromLocation = place;
    } else if (locationIndex == -1) {
      toLocation = place;
    } else {
      while (middleLocations.length < locationIndex) {
        middleLocations.add(null);
      }
      middleLocations.add(place);
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

    if (mounted) {
      setState(() {
        if (mkId == "from_address") {
          Marker marker = Marker(
            markerId: MarkerId(mkId),
            draggable: true,
            position: place.latLng, //LatLng(place.lat, place.lng),
            infoWindow: InfoWindow(title: mkId),
          );
          if (_markers.isNotEmpty)
            _markers[0] = (marker);
          else {
            _markers = [];
            _markers.add(marker);
          }
          List mmmm = _markers;
          print(mmmm);
        } else if (mkId == "to_address") {
          Marker marker = Marker(
            markerId: MarkerId(mkId),
            draggable: true,
            position: place.latLng, //LatLng(place.lat, place.lng),
            infoWindow: InfoWindow(title: mkId),
            icon: destinationPinIcon,
            anchor: const Offset(0.1, 1),
          );
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
    // if (Globals.stops == 1) {
    //   request();
    // }
    if (_markers.length > 1) {
      mapUtil
          .getRoutePath(
              LatLng(_markers[0].position.latitude,
                  _markers[0].position.longitude),
              LatLng(_markers[1].position.latitude,
                  _markers[1].position.longitude))
          .then((locations) {
        path = new List();

        if (locations != null) {
          locations.forEach((location) {
            path.add(new LatLng(location.latitude, location.longitude));
          });
        } else {
          print("location is null");
        }

        final Polyline polyline = Polyline(
          polylineId: PolylineId(_markers[1].position.latitude.toString() +
              _markers[1].position.longitude.toString()),
          consumeTapEvents: true,
          color: Colors.black,
          width: 2,
          points: path,
        );

        if (mounted) {
          routes.add(polyline);
          request();
          setState(() {
            print("add polyline");
          });
        }
      });
    } else {
      print("makers length is ${_markers.length}");
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
        moveCamera(_center);
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
