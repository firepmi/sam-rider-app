import 'package:flutter/material.dart';

class AppConfig {
  static const appName = "Sam Will Do It";
}

class AvailableFonts {
  static const primaryFont = "Quicksand";
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
}
