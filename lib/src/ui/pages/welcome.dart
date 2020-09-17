import 'package:flutter/material.dart';
import 'package:sam_rider_app/src/util/utils.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logo = Container(
      height: 100.0,
      width: 200.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AvailableImages.appLogo,
          fit: BoxFit.cover,
        ),
      ),
    );

    final appName = Column(
      children: <Widget>[
        Text(
          AppConfig.appName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 30.0,
          ),
        ),
      ],
    );

    final nextBtn = InkWell(
      onTap: () => Navigator.pushNamed(context, '/intro'),
      child: Container(
        height: 60.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black),
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
                  color: Colors.black,
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
                  border: Border.all(color: Colors.black),
                  color: Colors.transparent,
                ),
                child: Icon(
                  Icons.arrow_right_alt,
                  color: Colors.black,
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
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 70.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[logo, appName, buttons],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
