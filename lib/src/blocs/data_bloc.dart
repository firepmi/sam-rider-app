import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sam_rider_app/src/fire_base/firebase_dataref.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';

class DataBloc {
  var _fireData = FireDataRef();

  void request(List<LatLng> path, startLat, startLon, endLat, endLon, onSuccess,
      onError) {
    _fireData.request(
        path, startLat, startLon, endLat, endLon, onSuccess, onError);
  }

  void getUserProfile(Function(dynamic) onSuccess) {
    _fireData.getUserProfile(onSuccess);
  }

  void getDriverProfile(String uid, Function(dynamic) onSuccess) {
    _fireData.getDriverProfile(uid, onSuccess);
  }

  void updateAddress(LocationResult location, String addressId) {
    _fireData.updateAddress(location, addressId);
  }

  Future getAddress(String addressId) async {
    var address = await _fireData.getAddress(addressId);
    return address;
  }

  void uploadProfile(Uint8List data, Function onSuccess) {
    _fireData.uploadImage(data, onSuccess);
  }

  void makeOrder(dynamic data, Function onSuccess, Function(String) onError) {
    _fireData.makeOrder(data, onSuccess, onError);
  }

  Future getProfileImage(String id) async {
    var profileUrl = "";
    profileUrl = await _fireData.getProfileImage(id);
    return profileUrl;
  }

  Future getDrivers() async {
    var value = await _fireData.getDriverList();
    return value;
  }

  void getRequests(Function(dynamic) onSuccess) async {
    _fireData.getRequests(onSuccess);
  }

  void getRequestsList(Function(dynamic) onSuccess) async {
    _fireData.getRequestsList(onSuccess);
  }

  void getCurrentRequest(Function(dynamic) onSuccess, Function onEmpty) async {
    _fireData.getCurrentRequest(onSuccess, onEmpty);
  }

  void getRequestStatus(String id, Function(dynamic) onSuccess) {
    _fireData.getRequestState(id, onSuccess);
  }
}
