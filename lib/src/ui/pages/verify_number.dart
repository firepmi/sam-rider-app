import 'package:sam_rider_app/src/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:sam_rider_app/src/ui/widgets/loading_dialog.dart';
import 'package:sam_rider_app/src/ui/widgets/msg_dialog.dart';
import 'package:sam_rider_app/src/util/utils.dart';

class VerificationPage extends StatefulWidget {
  VerificationPage({Key key}) : super(key: key);

  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  AuthBloc authBloc = AuthBloc();

  String verificationId = "";

  TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    verificationId = ModalRoute.of(context).settings.arguments;
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
              SizedBox(height: 50),
              Text("Please type verification code sent to your phone."),
              Padding(
                padding:
                    EdgeInsets.fromLTRB(0, AppConfig.size(context, 10), 0, 10),
                child: StreamBuilder(
                  stream: authBloc.nameStream,
                  builder: (context, snapshot) => TextField(
                      controller: _codeController,
                      style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          errorText: snapshot.hasError ? snapshot.error : null,
                          border: InputBorder.none,
                          labelText: "Verification Code",
                          prefixIcon: Container(
                            width: 50,
                            child: Icon(Icons.verified_user_outlined),
                          ),
                          labelStyle: TextStyle(fontSize: 20))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: RawMaterialButton(
                    fillColor: Color.fromRGBO(255, 184, 0, 1),
                    elevation: 5.0,
                    onPressed: () => onVerifyPhone(),
                    child: Text(
                      "Verify",
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(26))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onVerifyPhone() {
    var code = _codeController.text;
    if (code.length != 6) {
      MsgDialog.showMsgDialog(context, "Verify Phone Number", "Invalid code");
      return;
    }
    authBloc.connectPhone(code, verificationId, onCompleted, onError);
  }

  void onCompleted() {
    Navigator.pushNamed(context, '/joblocation');
  }

  void onError(error) {
    MsgDialog.showMsgDialog(context, "Verify Phone Number", error.toString());
  }
}
