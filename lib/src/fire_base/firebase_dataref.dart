import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FireDataRef {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

  void getUserProfile(Function(dynamic) onSuccess) {
    var user = FirebaseAuth.instance.currentUser;
    var ref =
        FirebaseDatabase.instance.reference().child("users").child(user.uid);
    ref.once().then((DataSnapshot data) {
      onSuccess(data.value);
    });
  }

  void uploadImage(Uint8List data, Function onSuccess) async {
    var user = FirebaseAuth.instance.currentUser;
    final StorageReference storageReference =
        FirebaseStorage().ref().child("profile").child(user.uid + ".jpg");

    final StorageUploadTask uploadTask = storageReference.putData(data);

    final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      // You can use this to notify yourself or your user in any kind of way.
      // For example: you could use the uploadTask.events stream in a StreamBuilder instead
      // to show your user what the current status is. In that case, you would not need to cancel any
      // subscription as StreamBuilder handles this automatically.

      // Here, every StorageTaskEvent concerning the upload is printed to the logs.
      print('EVENT ${event.type}');
      if (event.type == StorageTaskEventType.success) {
        onSuccess();
      }
    });

// Cancel your subscription when done.
    await uploadTask.onComplete;
    streamSubscription.cancel();
  }

  void signIn(String email, String pass, Function onSuccess,
      Function(String) onSignInError) {
    _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) {
      print("on SignIn in success");
      onSuccess();
    }).catchError((err) {
      print(err);
      onSignInError("SignIn fail, please try again");
    });
  }

  void _onSignUpError(String code, Function(String) onRegisterError) {
    switch (code) {
      case "ERROR_INVALID_EMAIL":
      case "ERROR_INVALID_CREDENTIAL":
        onRegisterError("Invalid Email");
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
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
