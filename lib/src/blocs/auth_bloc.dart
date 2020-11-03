import 'dart:async';

import 'package:sam_rider_app/src/fire_base/firebase_dataref.dart';

class AuthBloc {
  var _fireAuth = FireDataRef();
  StreamController _nameController = StreamController();
  StreamController _emailController = StreamController();
  StreamController _passController = StreamController();
  StreamController _phoneController = StreamController();

  Stream get nameStream => _nameController.stream;
  Stream get emailStram => _emailController.stream;
  Stream get passStream => _passController.stream;
  Stream get phoneStream => _phoneController.stream;

  bool isValid(String name, String email, String pass, String phone) {
    if (name == null || name.length == 0) {
      _nameController.sink.addError("Enter your name");
      return false;
    }
    _nameController.sink.add("");

    if (phone == null || phone.length == 0) {
      _phoneController.sink.addError("Enter your phone number");
      return false;
    }
    _phoneController.sink.add("");

    if (email == null || email.length == 0) {
      _emailController.sink.addError("Enter your email");
      return false;
    }
    _emailController.sink.add("");

    if (pass == null || pass.length < 6) {
      _passController.sink
          .addError("Password must be longer than 6 characters");
      return false;
    }
    _passController.sink.add("");
    return true;
  }

  void signUp(String email, String pass, String phone, String name,
      Function onSuccess, Function(String) onRegisterError) {
    _fireAuth.signUp(email, pass, name, phone, onSuccess, onRegisterError);
  }

  void signIn(String email, String pass, Function onSuccess,
      Function(String) onSignInError) {
    _fireAuth.signIn(email, pass, onSuccess, onSignInError);
  }

  void dispose() {
    _nameController.close();
    _emailController.close();
    _passController.close();
    _phoneController.close();
  }
}
