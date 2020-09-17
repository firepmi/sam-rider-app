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

  static const homePage = const AssetImage('assets/images/home_page.png');
  static const appLogo = const AssetImage('assets/images/sam_logo.png');
}
