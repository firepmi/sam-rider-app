import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_panel/flip_panel.dart';
import 'package:flutter/material.dart';
import 'package:sam_rider_app/src/blocs/auth_bloc.dart';
import 'package:sam_rider_app/src/ui/widgets/msg_dialog.dart';
import 'package:sam_rider_app/src/util/utils.dart';

// ignore: must_be_immutable
class WelcomePage extends StatelessWidget {
  AuthBloc authBloc = AuthBloc();
  @override
  Widget build(BuildContext context) {
    final logo = Padding(
      padding: EdgeInsets.only(
        bottom: 80,
      ),
      child: Container(
        height: 200.0,
        width: 200.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AvailableImages.appLogo,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    final nextBtn = InkWell(
      onTap: () => {moveToNext(context)},
      child: Container(
        height: 60.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white),
          color: Colors.transparent,
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Text(
                'Welcome',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                  color: Colors.transparent,
                ),
                child: Icon(
                  Icons.arrow_right_alt,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
    final buttons = Padding(
      padding: EdgeInsets.only(
        top: 80.0,
        bottom: 30.0,
        left: 30.0,
        right: 30.0,
      ),
      child: Column(
        children: <Widget>[nextBtn],
      ),
    );

    final digits = [
      'Swift Asset Movement',
      'Safe Asset Movement',
      'Swift Asset Management',
      'Safe Asset Management',
      'Sam Can Do It!',
      'Sam Will Bring It',
      'Sam is for Contractors',
      'Sam is for Busy Moms & Dads',
      'Sam is for Everybody',
    ];
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(34, 178, 76, 1),
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //   image: AvailableImages.bgWelcome,
        //   fit: BoxFit.cover,
        // )),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 70.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  logo,
                  FlipPanel.builder(
                    itemBuilder: (context, index) => Container(
                      color: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      width: 300,
                      child: Center(
                        child: Text(
                          '${digits[index]}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    itemsCount: digits.length,
                    period: const Duration(milliseconds: 1000),
                    loop: -1,
                  ),
                  buttons,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void moveToNext(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushNamed(context, '/intro');
    } else {
      print("check phone number");
      onCheckVerifiedPhone(context);
    }
  }

  void onCheckVerifiedPhone(context) {
    authBloc.checkVerifyPhone((result) {
      if (result == "error") {
        Navigator.pushNamed(context, '/intro');
      } else if (result == "success") {
        Navigator.pushNamed(context, '/joblocation');
      } else {
        print("verifiy phone number");
        onVerifyPhone(context, result);
      }
    });
  }

  void onVerifyPhone(context, String phone) {
    authBloc.verifyPhone("+1$phone", (verificationId) {
      Navigator.pushNamed(context, '/verify_phone', arguments: verificationId);
    }, (error) {
      MsgDialog.showMsgDialog(context, "Verify Phone Number", error.toString());
      FirebaseAuth.instance.signOut();
    });
  }
}
