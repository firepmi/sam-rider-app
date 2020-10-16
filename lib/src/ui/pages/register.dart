import 'package:sam_rider_app/src/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:sam_rider_app/src/ui/widgets/loading_dialog.dart';
import 'package:sam_rider_app/src/ui/widgets/msg_dialog.dart';
import 'package:sam_rider_app/src/util/utils.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthBloc authBloc = AuthBloc();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
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
                height: 130.0,
                width: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AvailableImages.appLogo1,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 80, 0, 10),
                child: StreamBuilder(
                  stream: authBloc.nameStream,
                  builder: (context, snapshot) => TextField(
                      controller: _nameController,
                      style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          errorText: snapshot.hasError ? snapshot.error : null,
                          border: InputBorder.none,
                          labelText: "Name",
                          prefixIcon: Container(
                            width: 50,
                            child: Icon(Icons.person),
                          ),
                          labelStyle: TextStyle(fontSize: 20))),
                ),
              ),
              StreamBuilder(
                stream: authBloc.phoneStream,
                builder: (context, snapshot) => TextField(
                    controller: _phoneController,
                    style: TextStyle(fontSize: 18),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        errorText: snapshot.hasError ? snapshot.error : null,
                        border: InputBorder.none,
                        labelText: "Phone Number",
                        prefixIcon: Container(
                          width: 50,
                          child: Icon(Icons.phone),
                        ),
                        labelStyle: TextStyle(fontSize: 20))),
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
                    onPressed: () => _onSignupClicked(),
                    child: Text(
                      "Signup",
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
                    onPressed: () => _onSignupClicked(),
                    child: Text(
                      "Signup with Facebook",
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
                      'Already a User?',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Login now',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onSignupClicked() {
    var isValid = authBloc.isValid(_nameController.text, _emailController.text,
        _passController.text, _phoneController.text);
    print(isValid);
    if (isValid) {
      // create user
      //loading dialog
      LoadgingDialog.showLoadingDialog(context, "Loading...");
      return authBloc.signUp(_emailController.text, _passController.text,
          _phoneController.text, _nameController.text, () {
        LoadgingDialog.hideLoadingDialog(context);
        Navigator.pushNamed(context, '/home');
      }, (msg) {
        print(msg);
        //show msg dialog
        LoadgingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, "SignUp", msg);
      });
    }
    return;
  }
}
