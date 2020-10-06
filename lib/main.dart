import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sam_rider_app/src/blocs/auth_bloc.dart';
import 'package:sam_rider_app/src/ui/pages/add_payment_method.dart';
import 'package:sam_rider_app/src/ui/pages/free_rides.dart';
import 'package:sam_rider_app/src/ui/pages/help.dart';
import 'package:sam_rider_app/src/ui/pages/home.dart';
import 'package:sam_rider_app/src/ui/pages/intro.dart';
import 'package:sam_rider_app/src/ui/pages/login.dart';
import 'package:sam_rider_app/src/ui//pages/add_card.dart';
import 'package:sam_rider_app/src/ui/pages/payment.dart';
import 'package:sam_rider_app/src/ui/pages/privacy.dart';
import 'package:sam_rider_app/src/ui/pages/register.dart';
import 'package:sam_rider_app/src/ui/pages/select_issue.dart';
import 'package:sam_rider_app/src/ui/pages/settings.dart';
import 'package:sam_rider_app/src/ui/pages/termsofservice.dart';
import 'package:sam_rider_app/src/ui/pages/welcome.dart';
import 'package:sam_rider_app/src/ui/pages/your_trips.dart';

import 'src/ui/pages/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(
      AuthBloc(),
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SAM Rider',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: './',
        routes: {
          '/home': (context) => MyHomePage(title: 'SAM Rider'),
          '/': (context) => WelcomePage(),
          '/intro': (context) => IntroPage(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => RegisterPage(),
          '/payment': (context) => PaymentPage(),
          '/add_payment': (context) => AddPaymentMethodPage(),
          '/add_card': (context) => AddCardPage(),
          '/your_trip': (context) => YourTripPage(),
          '/select_issue': (context) => SelectIssuePage(),
          '/free_rides': (context) => FreeRidesPage(),
          '/help': (context) => HelpPage(),
          '/settings': (context) => SettingsPage(),
          '/profile': (context) => ProfilePage(),
          '/privacy': (context) => PrivacyPage(),
          '/termsofservice': (context) => TermsOfServicePage(),
        },
      )));
}

class MyApp extends InheritedWidget {
  final AuthBloc authBloc;
  final Widget child;
  MyApp(this.authBloc, this.child) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static MyApp of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyApp>();
  }
}
