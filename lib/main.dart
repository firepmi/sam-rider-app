import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sam_rider_app/src/blocs/auth_bloc.dart';
import 'package:sam_rider_app/src/fire_base/firebase_dataref.dart';
import 'package:sam_rider_app/src/ui/pages/checkout.dart';
import 'package:sam_rider_app/src/ui/pages/faq.dart';
import 'package:sam_rider_app/src/ui/pages/add_payment_method.dart';
import 'package:sam_rider_app/src/ui/pages/driver_list.dart';
import 'package:sam_rider_app/src/ui/pages/driver_profile.dart';
import 'package:sam_rider_app/src/ui/pages/help.dart';
import 'package:sam_rider_app/src/ui/pages/job_location_pick.dart';
import 'package:sam_rider_app/src/ui/pages/intro.dart';
import 'package:sam_rider_app/src/ui/pages/login.dart';
import 'package:sam_rider_app/src/ui//pages/add_card.dart';
import 'package:sam_rider_app/src/ui/pages/payment.dart';
import 'package:sam_rider_app/src/ui/pages/privacy.dart';
import 'package:sam_rider_app/src/ui/pages/register.dart';
import 'package:sam_rider_app/src/ui/pages/request_details.dart';
import 'package:sam_rider_app/src/ui/pages/select_car_size.dart';
import 'package:sam_rider_app/src/ui/pages/select_duration.dart';
import 'package:sam_rider_app/src/ui/pages/select_issue.dart';
import 'package:sam_rider_app/src/ui/pages/select_weight.dart';
import 'package:sam_rider_app/src/ui/pages/settings.dart';
import 'package:sam_rider_app/src/ui/pages/termsofservice.dart';
import 'package:sam_rider_app/src/ui/pages/verify_number.dart';
import 'package:sam_rider_app/src/ui/pages/welcome.dart';
import 'package:sam_rider_app/src/ui/pages/home.dart';
import 'package:sam_rider_app/src/ui/pages/your_trips.dart';

import 'src/ui/pages/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FireDataRef dataRef = FireDataRef();
  dataRef.initConfig();
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
          '/home': (context) => HomePage(),
          '/joblocation': (context) => JobLocationPickPage(),
          '/': (context) => WelcomePage(),
          '/intro': (context) => IntroPage(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => RegisterPage(),
          '/verify_phone': (context) => VerificationPage(),
          '/payment': (context) => PaymentPage(),
          '/add_payment': (context) => AddPaymentMethodPage(),
          '/add_card': (context) => AddCardPage(),
          '/your_trip': (context) => YourTripPage(),
          '/select_issue': (context) => SelectIssuePage(),
          '/help': (context) => HelpPage(),
          '/settings': (context) => SettingsPage(),
          '/profile': (context) => ProfilePage(),
          '/privacy': (context) => PrivacyPage(),
          '/termsofservice': (context) => TermsOfServicePage(),
          '/select_duration': (context) => SelectDurationPage(),
          '/driver_profile': (context) => DriverProfilePage(),
          '/driver_list': (context) => DriverListPage(),
          '/select_car_size': (context) => SelectCarSizePage(),
          '/select_weight': (context) => SelectWeightPage(),
          '/request_details': (context) => RequestDetailsPage(),
          '/faq': (context) => FAQPage(),
          '/checkout': (context) => CheckoutPage(),
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
