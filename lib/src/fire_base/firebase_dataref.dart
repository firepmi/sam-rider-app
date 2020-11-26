import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';

class FireDataRef {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void initConfig() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // _showItemDialog(message);
      },
      onBackgroundMessage:
          Platform.isAndroid ? myBackgroundMessageHandler : null,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // _navigateToItemDetail(message);
      },
    );
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  void signUp(String email, String pass, String name, String phone,
      Function onSuccess, Function(String) onRegisterError) {
    _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: pass)
        .then((credentials) {
      //
      _createUser(
          credentials.user.uid, name, phone, onSuccess, onRegisterError);
      print(credentials);
    }).catchError((err) {
      print(err);
      _onSignUpError(err.code, onRegisterError);
    });
  }

  _createUser(String userId, String name, String phone, Function onSuccess,
      Function(String) onRegisterError) {
    var user = {
      "name": name,
      "phone": phone,
    };
    var ref = FirebaseDatabase.instance.reference().child("users");

    ref.child(userId).set(user).then((user) {
      // success
      onSuccess();
    }).catchError((err) {
      onRegisterError(err.toString());
    });
  }

  void verifyPhone(String phone, Function(String) onCodeSent,
      Function(dynamic) onError) async {
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (credential) {
          print(credential);
        },
        verificationFailed: (error) {
          onError(error);
        },
        codeSent: (String verificationId, int resendToken) {
          onCodeSent(verificationId);
          print(resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print(verificationId);
        });
  }

  void connectPhone(String code, String verificationId, Function onCompleted,
      Function(dynamic) onError) async {
    AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: code);
    try {
      await _firebaseAuth.currentUser.linkWithCredential(phoneAuthCredential);
      var ref = FirebaseDatabase.instance.reference().child("users");

      ref
          .child(_firebaseAuth.currentUser.uid)
          .child("is_verified_phone")
          .set(true)
          .then((user) {
        // success
        onCompleted();
      }).catchError((err) {
        onError(err);
      });
    } catch (e) {
      onError(e);
    }
    // _firebaseAuth
    //     .signInWithCredential(phoneAuthCredential)
    //     .then((credentials) {})
    //     .catchError((err) {
    //   print(err);
    // });
  }

  void request(
      List<LatLng> path,
      double startLat,
      double startLon,
      double endLat,
      double endLon,
      Function onSuccess,
      Function(String) onError) {
    var user = FirebaseAuth.instance.currentUser;
    var date = DateTime.now();
    var pathStr = "";
    path.forEach((element) {
      pathStr += "${element.latitude},${element.longitude}";
    });
    var request = {
      "start_lat": startLat,
      "start_lon": startLon,
      "end_lat": endLat,
      "end_lon": endLon,
      "request_date": date.millisecondsSinceEpoch,
      "state": "awaiting",
      "path": pathStr
    };
    var ref = FirebaseDatabase.instance.reference().child("requests");

    ref.child(user.uid).set(request).then((data) {
      // success
      onSuccess();
    }).catchError((err) {
      onError(err.toString());
    });
  }

  void updateAddress(LocationResult location, String addressId) {
    var user = FirebaseAuth.instance.currentUser;
    var request = {
      "address": location.address,
      "lat_long": "${location.latLng.latitude},${location.latLng.longitude}",
      "place_id": location.placeId,
    };
    var ref = FirebaseDatabase.instance.reference().child("users");

    ref.child(user.uid).child(addressId).set(request);
  }

  Future<LocationResult> getAddress(addressId) async {
    var user = FirebaseAuth.instance.currentUser;
    var ref = FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(user.uid)
        .child(addressId);
    DataSnapshot data = await ref.once();
    if (data.value == null) return null;
    List<String> latlonArr = data.value["lat_long"].split(",");
    LatLng latLng =
        LatLng(double.parse(latlonArr[0]), double.parse(latlonArr[1]));
    return LocationResult(
        latLng: latLng,
        address: data.value["address"],
        placeId: data.value["place_id"]);
  }

  void getUserProfile(Function(dynamic) onSuccess) {
    var user = FirebaseAuth.instance.currentUser;
    var ref =
        FirebaseDatabase.instance.reference().child("users").child(user.uid);
    ref.once().then((DataSnapshot data) {
      if (data.value != null) onSuccess(data.value);
    });
  }

  Future getProfileImage(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    final ref =
        FirebaseStorage.instance.ref().child("profile").child(id + ".jpg");
    var profileUrl = "";
    try {
      profileUrl = (await ref.getDownloadURL()).toString();
    } catch (e) {
      print(e.toString());
    }
    return profileUrl;
  }

  Future getDriverList() async {
    var ref = FirebaseDatabase.instance.reference().child("drivers");
    DataSnapshot data = await ref.once();

    return data;
  }

  void uploadImage(Uint8List data, Function onSuccess) async {
    var user = FirebaseAuth.instance.currentUser;

    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child("profile")
        .child(user.uid + ".jpg");

    try {
      await storageReference.putData(data);
      onSuccess();
    } catch (e) {
      print(e);
    }
  }

  void signIn(String email, String pass, Function(String) onSuccess,
      Function(String) onSignInError) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: pass);
      onSuccess("success"); //TODO: enable phone verification
      // checkPhoneVerification(onSuccess);
    } catch (err) {
      onSignInError(err.toString());
    }
  }

  void checkPhoneVerification(Function(String) onSuccess) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    var ref =
        FirebaseDatabase.instance.reference().child("users").child(user.uid);
    DataSnapshot data = await ref.once();
    Map value = data.value;
    if (value == null) {
      await FirebaseAuth.instance.signOut();
      onSuccess("error");
    } else if (value["is_verified_phone"] == null ||
        value["is_verified_phone"] != true) {
      onSuccess(value["phone"]);
    } else {
      onSuccess("success");
    }
  }

  void makeOrder(
      dynamic data, Function onSuccess, Function(String) onError) async {
    var ref = FirebaseDatabase.instance.reference().child("requests");

    final d = DateFormat('yyyyMMddHHmmss').format(DateTime.now());

    var id = d + FirebaseAuth.instance.currentUser.uid;

    try {
      await ref.child(id).set(data);
      onSuccess();
    } catch (error) {
      onError(error.toString());
    }
  }

  void getRequests(Function(dynamic) onSuccess) async {
    var ref = FirebaseDatabase.instance.reference().child("requests");
    var uid = FirebaseAuth.instance.currentUser.uid;
    try {
      var data = await ref
          .orderByChild("client_id")
          .equalTo(uid)
          // .orderByChild("status")
          // .equalTo("waiting")
          .once();
      Map<String, dynamic> mapOfMaps = Map.from(data.value);
      mapOfMaps.forEach((key, value) {
        if (value["status"] == "waiting") {
          value["data_id"] = key;
          onSuccess(value);
          return;
        }
      });
    } catch (error) {
      print(error.toString());
    }
  }

  void getRequestState(String id, Function(dynamic) onSuccess) async {
    var ref = FirebaseDatabase.instance.reference().child("requests");
    try {
      var status = await ref.child(id).child("status").once();
      onSuccess(status.value);
    } catch (error) {
      print(error.toString());
    }
  }

  void _onSignUpError(String code, Function(String) onRegisterError) {
    print(code);
    switch (code) {
      case "ERROR_INVALID_EMAIL":
      case "ERROR_INVALID_CREDENTIAL":
        onRegisterError("Invalid Email");
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "email-already-in-use":
        onRegisterError("Email has existed");
        break;
      case "ERROR_WEAK_PASSWORD":
        onRegisterError("The password is not strong enough");
        break;
      default:
        onRegisterError("Signup fail, please try again");
        break;
    }
  }
}
