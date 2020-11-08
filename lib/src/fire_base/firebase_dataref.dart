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
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
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
      checkPhoneVerification(onSuccess);
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
    if (value["is_verified_phone"] != true) {
      onSuccess(value["phone"]);
    } else {
      onSuccess("success");
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
