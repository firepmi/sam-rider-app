import 'package:flutter/material.dart';
import 'package:sam_rider_app/src/blocs/auth_bloc.dart';
import 'package:sam_rider_app/src/ui/widgets/loading_dialog.dart';
import 'package:sam_rider_app/src/ui/widgets/msg_dialog.dart';
import 'package:sam_rider_app/src/util/utils.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginView();
  }
}

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  AuthBloc authBloc = AuthBloc();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Container(
                height: AppConfig.size(context, 60),
                width: AppConfig.size(context, 200),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AvailableImages.appLogo1,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: StreamBuilder(
                  stream: authBloc.emailStram,
                  builder: (context, snapshot) => TextField(
                      controller: _emailController,
                      style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          errorText: snapshot.hasError ? snapshot.error : null,
                          border: InputBorder.none,
                          labelText: "Email",
                          prefixIcon: Container(
                            width: 50,
                            child: Icon(Icons.email),
                          ),
                          labelStyle: TextStyle(fontSize: 20))),
                ),
              ),
              StreamBuilder(
                stream: authBloc.passStream,
                builder: (context, snapshot) => TextField(
                    controller: _passController,
                    style: TextStyle(fontSize: 18),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        errorText: snapshot.hasError ? snapshot.error : null,
                        border: InputBorder.none,
                        labelText: "Password",
                        prefixIcon: Container(
                          width: 50,
                          child: Icon(Icons.security),
                        ),
                        labelStyle: TextStyle(fontSize: 20))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: RawMaterialButton(
                    fillColor: Color.fromRGBO(255, 184, 0, 1),
                    elevation: 5.0,
                    onPressed: () => _onLoginClicked(),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(26))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 50),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: RawMaterialButton(
                    fillColor: Color.fromRGBO(59, 89, 152, 1),
                    elevation: 5.0,
                    onPressed: () => _onLoginClicked(),
                    child: Text(
                      "LOGIN WITH FACEBOOK",
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(26))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Do not have account?',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text(
                        'Signup now',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLoginClicked() {
    LoadgingDialog.showLoadingDialog(context, "Loading...");
    authBloc.signIn(_emailController.text, _passController.text, (result) {
      LoadgingDialog.hideLoadingDialog(context);
      if (result == "success") {
        Navigator.pushNamed(context, '/joblocation');
      } else {
        onCheckVerifiedPhone(context);
      }
    }, (msg) {
      print(msg);
      LoadgingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, "Login", msg);
    });

    return;
  }

  void onCheckVerifiedPhone(context) {
    authBloc.checkVerifyPhone((result) {
      if (result == "success") {
        Navigator.pushNamed(context, '/joblocation');
      } else {
        // onVerifyPhone(context, result);
        AlertDialog(
          title: Text("Phone Verification"),
          content: Text("Phone verification is not working on dev mode"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                // Navigator.of(context).pop("cancel");
                Navigator.pop(context);
                Navigator.pushNamed(context, '/joblocation');
              },
              child: Text("Ok"),
            ),
          ],
        );
      }
    });
  }

  void onVerifyPhone(context, String phone) {
    authBloc.verifyPhone("+1$phone", (verificationId) {
      Navigator.pushNamed(context, '/verify_phone', arguments: verificationId);
    }, (error) {
      MsgDialog.showMsgDialog(context, "Verify Phone Number", error.toString());
    });
  }
}
