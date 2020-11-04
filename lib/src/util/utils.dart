import 'package:flutter/material.dart';

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
}

class AppStyle {
  static Widget label(BuildContext context, String text, {double size = 8}) {
    return Text(
      text,
      style: TextStyle(fontSize: AppConfig.size(context, size)),
    );
  }

  static Widget titleLabel(BuildContext context, String text,
      {double size = 8}) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: AppConfig.size(context, size)),
    );
  }
}

class AvailableFonts {
  static const primaryFont = "Quicksand";
}

class AppColors {
  static const main = Color.fromRGBO(81, 175, 51, 1);
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
