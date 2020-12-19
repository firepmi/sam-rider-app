import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:sam_rider_app/src/util/globals.dart';
import 'package:sam_rider_app/src/util/utils.dart';

class RidePicker extends StatefulWidget {
  final Function(LocationResult, bool) onSelected;
  final LatLng _center;
  RidePicker(this._center, this.onSelected);

  _RidePickerState createState() => _RidePickerState();
}

class _RidePickerState extends State<RidePicker> {
  LocationResult fromLocation;
  LocationResult toLocation;

  Widget secondLocation() {
    if (Globals.stops == 2) {
      return Column(
        children: [
          Divider(),
          Container(
            width: double.infinity,
            height: 50,
            child: FlatButton(
              onPressed: () async {
                print("to location init location:");
                print(fromLocation.latLng);
                toLocation = await showLocationPicker(
                  context, AppConfig.apiKey,
                  initialCenter: fromLocation == null
                      ? widget._center
                      : fromLocation.latLng,
                  automaticallyAnimateToCurrentLocation: true,
//                      mapStylePath: 'assets/mapStyle.json',
                  myLocationButtonEnabled: true,
                  layersButtonEnabled: true,
                );
                setState(() {
                  print("refresh ui");
                  widget.onSelected(toLocation, false);
                });
              },
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: <Widget>[
                    SizedBox(
                      height: 40.0,
                      width: 50.0,
                      child: Center(
                        child: Container(
                            margin: EdgeInsets.only(top: 2),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(color: AppColors.main)),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      width: 40,
                      height: 50,
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40.0, right: 50.0),
                      child: Text(
                        toLocation == null
                            ? "Dropoff location"
                            : (toLocation.address == null
                                ? "Address not found"
                                : toLocation.address),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            color: toLocation == null
                                ? Colors.grey
                                : Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Color(0x88999999), offset: Offset(0, 5), blurRadius: 5.0)
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 50,
            child: FlatButton(
              onPressed: () async {
                print("from location init location:");
                print(widget._center);
                fromLocation = await showLocationPicker(
                  context, AppConfig.apiKey,
                  initialCenter: widget._center,
                  automaticallyAnimateToCurrentLocation: true,
//                      mapStylePath: 'assets/mapStyle.json',
                  myLocationButtonEnabled: true,
                  layersButtonEnabled: true,
                  // countries: ['AE', 'NG']

//                      resultCardAlignment: Alignment.bottomCenter,
                );
                setState(() {
                  print("refresh ui");
                  widget.onSelected(fromLocation, true);
                });
              },
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: <Widget>[
                    SizedBox(
                      height: 40.0,
                      width: 50.0,
                      child: Center(
                        child: Container(
                            margin: EdgeInsets.only(top: 2),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(color: Colors.black)),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      width: 40,
                      height: 50,
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40.0, right: 50.0),
                      child: Text(
                        fromLocation == null
                            ? "Pick up location"
                            : (fromLocation.address ?? "Address not found"),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            color: fromLocation == null
                                ? Colors.grey
                                : Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          secondLocation()
        ],
      ),
    );
  }
}
