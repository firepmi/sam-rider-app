import 'package:flutter/material.dart';
import 'package:sam_rider_app/src/blocs/auth_bloc.dart';
import 'package:sam_rider_app/src/ui/pages/add_payment_method.dart';
import 'package:sam_rider_app/src/ui/pages/free_rides.dart';
import 'package:sam_rider_app/src/ui/pages/help.dart';
import 'package:sam_rider_app/src/ui/pages/home.dart';
import 'package:sam_rider_app/src/ui/pages/login.dart';
import 'package:sam_rider_app/src/ui//pages/add_card.dart';
import 'package:sam_rider_app/src/ui/pages/payment.dart';
import 'package:sam_rider_app/src/ui/pages/select_issue.dart';
import 'package:sam_rider_app/src/ui/pages/settings.dart';
import 'package:sam_rider_app/src/ui/pages/your_trips.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
          '/': (context) => LoginPage(),
          '/payment': (context) => PaymentPage(),
          '/add_payment': (context) => AddPaymentMethodPage(),
          '/add_card': (context) => AddCardPage(),
          '/your_trip': (context) => YourTripPage(),
          '/select_issue': (context) => SelectIssuePage(),
          '/free_rides': (context) => FreeRidesPage(),
          '/help': (context) => HelpPage(),
          '/settings': (context) => SettingsPage(),
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
    return context.inheritFromWidgetOfExactType(MyApp);
  }
}
