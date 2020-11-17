import 'dart:math';

import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Globals {
  static int stops = 2;
  static PriceOptional duration = PriceOptional.small;
  static CarSizeOptional carSize = CarSizeOptional.autoMobile;
  static WeightOptional weight = WeightOptional.option1;
  static LocationResult fromLocation;
  static LocationResult toLocation;
  static List<LatLng> path = List();
  static final weight_prices = [0, 5, 7, 25, 50, 75];
  static final car_prices = [0, 5, 7, 25, 50, 75];

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
}

enum PriceOptional { small, medium, large }
enum CarSizeOptional { autoMobile, suv, pickup, van, trailer, truck }
enum WeightOptional { option1, option2, option3, option4, option5, option6 }
