import 'package:flutter/material.dart';
import 'package:sam_rider_app/src/util/globals.dart';

class AppConfig {
  static const appName = "Sam Will Do It";
  static const apiKey = 'AIzaSyB94toBjU5Ne7fz3xfjjS1PsgwaCabFKXg';

  static double size(BuildContext context, double s) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    if (height / width > 812 / 375) {
      return MediaQuery.of(context).size.width / 812 * s;
    } else {
      return MediaQuery.of(context).size.height / 375 * s;
    }
  }

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}

class AppStyle {
  static Widget label(
    BuildContext context,
    String text, {
    double size = 8,
    double top = 0,
    double bottom = 0,
    double right = 0,
    double left = 0,
    Color color = Colors.black,
    TextAlign align,
  }) {
    return Padding(
      padding:
          EdgeInsets.only(top: top, bottom: bottom, right: right, left: left),
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppConfig.size(context, size),
          color: color,
        ),
        textAlign: align,
      ),
    );
  }

  static Widget titleLabel(
    BuildContext context,
    String text, {
    double size = 8,
    Color color = Colors.black,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: AppConfig.size(context, size),
        color: color,
      ),
    );
  }

  static Widget button(BuildContext context, String title,
      {Function onPressed}) {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
            side: BorderSide(color: AppColors.main)),
        onPressed: onPressed,
        color: AppColors.main,
        textColor: Colors.white,
        child: Text(title, style: TextStyle(fontSize: 16)),
      ),
    );
  }

  static TextStyle introStyle1(BuildContext context) {
    return TextStyle(
        color: Color(0xff29ba50),
        fontSize: AppConfig.size(context, 12),
        fontWeight: FontWeight.w900,
        fontFamily: 'RobotoMono');
  }

  static TextStyle introStyle2(BuildContext context) {
    return TextStyle(
        color: Color(0xfff111111),
        fontSize: AppConfig.size(context, 12),
        fontWeight: FontWeight.w900,
        fontFamily: 'RobotoMono');
  }

  static Widget borderButton(
    BuildContext context,
    String text,
    double left,
    double right,
    double top,
    double bottom, {
    Function onPressed,
    Color borderColor = AppColors.main,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: SizedBox(
        width: double.infinity,
        height: AppConfig.size(context, 15),
        child: RawMaterialButton(
          // fillColor: borderColor,
          elevation: 5.0,
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
                color: borderColor, fontSize: AppConfig.size(context, 6)),
          ),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: borderColor, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(
                  Radius.circular(AppConfig.size(context, 10)))),
        ),
      ),
    );
  }

  static Widget requestCard(BuildContext context, dynamic info,
      {Function onMessage}) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        // color: Colors.pink,
        elevation: 16,
        child: Column(children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: info != null && info["profile"] != null
                  ? ClipOval(
                      child: FadeInImage.assetNetwork(
                        image: info["profile"],
                        placeholder: 'assets/images/default_profile.png',
                        // "assets/images/default_profile.png",
                        width: AppConfig.size(context, 25),
                        height: AppConfig.size(context, 25),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      "assets/images/default_profile.png",
                      width: AppConfig.size(context, 25),
                      height: AppConfig.size(context, 25),
                      fit: BoxFit.cover,
                    ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info["color"] == null ? "Boss" : info["color"],
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              info["name"] == null ? "Boss" : info["name"],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ]),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            info["phone"] == null ? "123456" : info["phone"],
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          Text(
                            "${info["star"]}",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            " (${info["reviews"]} reviews)",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Image.asset(
                  Globals.carImages[info["car_size"]],
                  width: 50,
                  height: 50,
                ),
                label(
                  context,
                  "${Globals.carNames[info["car_size"]]} \nwith loading\n${Globals.weightTitles[info["weight"]]}",
                  size: 3,
                  align: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "\$ ${info["price"]}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text("${Globals.getDistance()} m"),
              ],
            ),
            SizedBox(width: 10),
          ]),
          Text(
            info["tag"],
            style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: AppColors.main),
          ),
          AppStyle.borderButton(context, "Message", 30, 30, 10, 10,
              onPressed: onMessage),
        ]),
      ),
    );
  }
}

class AvailableFonts {
  static const primaryFont = "Quicksand";
}

class AppColors {
  static const main = Color.fromRGBO(81, 175, 51, 1);
  static const greyColor2 = Color(0xffE8E8E8);
  static const themeColor = Color(0xfff5a623);
  static const greyColor = Color(0xffaeaeae);
}

class AvailableImages {
  static const emptyState = {
    'assetImage': AssetImage('assets/images/empty.png'),
    'assetPath': 'assets/images/empty.png',
  };
  static const intro1 = const AssetImage('assets/images/img_intro1.png');
  static const intro2 = const AssetImage('assets/images/img_intro2.png');
  static const intro3 = const AssetImage('assets/images/img_intro3.png');
  static const intro4 = const AssetImage('assets/images/img_intro4.png');
  static const intro5 = const AssetImage('assets/images/img_intro5.png');
  static const introImageList = [
    AvailableImages.intro1,
    AvailableImages.intro2,
    AvailableImages.intro3,
    AvailableImages.intro4,
    AvailableImages.intro5,
  ];

  static const homePage = const AssetImage('assets/images/home_page.png');
  static const appLogo = const AssetImage('assets/images/sam_logo.png');
  static const appLogo1 =
      const AssetImage('assets/images/sam_logo_transparent.png');
  static const bgWelcome = const AssetImage('assets/images/bg_welcome.png');
}
