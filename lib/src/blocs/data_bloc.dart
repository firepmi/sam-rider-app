import 'dart:async';
import 'dart:typed_data';

import 'package:sam_rider_app/src/fire_base/firebase_dataref.dart';

class DataBloc {
  var _fireData = FireDataRef();

  void request(type, startLat, startLon, endLat, endLon, onSuccess, onError) {
    _fireData.request(
        type, startLat, startLon, endLat, endLon, onSuccess, onError);
  }

  void getUserProfile(Function(dynamic) onSuccess) {
    _fireData.getUserProfile(onSuccess);
  }

  void uploadProfile(Uint8List data, Function onSuccess) {
    _fireData.uploadImage(data, onSuccess);
  }
}
