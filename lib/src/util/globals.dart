import 'dart:math';

import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Globals {
  static PriceOptional duration = PriceOptional.small;
  static CarSizeOptional carSize = CarSizeOptional.autoMobile;
  static WeightOptional weight = WeightOptional.option1;
  static LocationResult fromLocation;
  static LocationResult toLocation;
  static int stops = 2;
  static bool isSelfLoading = false;
  static List<LatLng> path = List();

  static double getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
    var R = 6371;
    var dLat = deg2rad(lat2 - lat1);
    var dlon = deg2rad(lon2 - lon1);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dlon / 2) * sin(dlon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c; // * 0.621371 for mi
    return d;
  }

  static double getDistanceFromLatLonInMi(lat1, lon1, lat2, lon2) {
    var R = 6371;
    var dLat = deg2rad(lat2 - lat1);
    var dlon = deg2rad(lon2 - lon1);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dlon / 2) * sin(dlon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c * 0.621371; // for mi
    return d;
  }

  static double deg2rad(deg) {
    return deg * (pi / 180);
  }

  static final carPrices = [0, 10, 35, 150, 80];
  static final carNames = [
    "Automobile",
    "SUV",
    "Pickup Truck",
    "Box Truck",
    "Truck & Trailer",
  ];
  static final carImages = [
    'assets/images/car_option1.png',
    'assets/images/car_option2.png',
    'assets/images/car_option3.png',
    'assets/images/car_option4.png',
    'assets/images/car_option5.png',
  ];
  static final weightTitles = [
    "ONE SMALL ITEM",
    "MULTIPLE SMALL ITEMS",
    "TRUCK LOADING",
    "BOX TRUCK LOADING",
    "TRUCK & TRAILER LOADING",
  ];
  static final weightPrices = [0, 5, 25, 200, 100];
  static final weightImages = [
    'assets/images/weight_option1.png',
    'assets/images/weight_option2.png',
    'assets/images/weight_option4.png',
    'assets/images/weight_option5.png',
    'assets/images/weight_option6.png',
  ];
  static bool isWaiting = true;

  static int getDistance() {
    if (path == null || path.length < 2) return 0;
    var distance = 0.0;
    for (int i = 0; i < path.length - 1; i++) {
      distance += Globals.getDistanceFromLatLonInMi(path[i].latitude,
          path[i].longitude, path[i + 1].latitude, path[i + 1].longitude);
    }

    var meter_dis = (1609.344 * distance).round();

    return meter_dis;
  }
}

enum PriceOptional { small, medium, large }
enum CarSizeOptional { autoMobile, suv, pickup, van, truck_trailer }
enum WeightOptional { option1, option2, option3, option4, option5 }
