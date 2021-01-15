import 'dart:math';

import 'package:credit_card_input_form/constants/constanst.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sam_rider_app/src/blocs/data_bloc.dart';
import 'package:sam_rider_app/src/util/globals.dart';
import 'package:sam_rider_app/src/util/utils.dart';
import 'package:credit_card_input_form/credit_card_input_form.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'dart:core';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  dynamic data;
  DataBloc dataBloc = DataBloc();
  double price = 0;
  Token _paymentToken;
  PaymentMethod _paymentMethod;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String _error;
  var distance;
  var cardInformation;

  var publishableKey =
      "pk_live_51Hti88BEXyg0kPLy9gBfD4SjNZn860IGsafOdvEmnPmeuwQUQwhiXqDFGXN7NIeI3LItwWzbV6tuXyp90gJHtUBv00VUrNEItR";
  //Test Key
  // var publishableKey = "pk_test_51Hti88BEXyg0kPLyuSSuAzmzTkPWfWfh83GEvXBC27nRN1NweUI6HNKESkLTbq1HA9iPqVMYcPLwMTUuw2kzqp3J005Du7q6dH";
  // var secretKey =
  //     "sk_test_51Hti88BEXyg0kPLywO3GHoaVqnGwhH9M7R1p1egxjObRviUItKKxi6kNS4bt1od2WEtGYagMr9L57S3Ep9UHoRkl00X984phiA";

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    price = (Globals.weightPrices[Globals.weight.index] +
            Globals.carPrices[Globals.carSize.index])
        .toDouble();
    distance = dp(getDistance(), 2);
    if (distance < 5) distance = 5;
    print(distance);

    price += distance;
    print(price);

    StripePayment.setOptions(StripeOptions(
        publishableKey: publishableKey,
        merchantId:
            "SAM_rider${FirebaseAuth.instance.currentUser.uid}", //YOUR_MERCHANT_ID
        androidPayMode: 'production'));
  }

  double dp(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  double getDistance() {
    if (Globals.path.length < 2) {
      return Globals.getDistanceFromLatLonInMi(
          Globals.fromLocation.latLng.latitude,
          Globals.fromLocation.latLng.longitude,
          Globals.toLocation.latLng.latitude,
          Globals.toLocation.latLng.longitude);
    }
    var distance = 0.0;
    for (int i = 0; i < Globals.path.length - 1; i++) {
      distance += Globals.getDistanceFromLatLonInMi(
          Globals.path[i].latitude,
          Globals.path[i].longitude,
          Globals.path[i + 1].latitude,
          Globals.path[i + 1].longitude);
    }
    return distance;
  }

  final nameController = TextEditingController();
  final Map<String, String> customCaptions = {
    'PREV': 'Prev',
    'NEXT': 'Next',
    'DONE': 'Done',
    'CARD_NUMBER': 'Card Number',
    'CARDHOLDER_NAME': 'Cardholder Name',
    'VALID_THRU': 'Valid Thru',
    'SECURITY_CODE_CVC': 'Security Code (CVC)',
    'NAME_SURNAME': 'Name Surname',
    'MM_YY': 'MM/YY',
    'RESET': 'Reset',
  };

  final buttonStyle = BoxDecoration(
    borderRadius: BorderRadius.circular(30.0),
    gradient: LinearGradient(
        colors: [
          const Color(0xfffcdf8a),
          const Color(0xfff38381),
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp),
  );

  final cardDecoration = BoxDecoration(
      boxShadow: <BoxShadow>[
        BoxShadow(color: Colors.black54, blurRadius: 15.0, offset: Offset(0, 8))
      ],
      gradient: LinearGradient(
          colors: [
            Colors.red,
            Colors.blue,
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp),
      borderRadius: BorderRadius.all(Radius.circular(15)));

  final buttonTextStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18);

  void onMakePayment(BuildContext context) {
    // onMakeRequest("token.tokenId");
    StripePayment.paymentRequestWithNativePay(
      androidPayOptions: AndroidPayPaymentRequest(
        totalPrice: "$price",
        currencyCode: "USD",
      ),
      applePayOptions: ApplePayPaymentOptions(
        countryCode: 'US',
        currencyCode: 'USD',
        items: [
          ApplePayItem(
            label: 'SAM',
            amount: '$price',
          )
        ],
      ),
    ).then((token) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Received ${token.tokenId}')));
      _paymentToken = token;
      onMakeRequest(token.tokenId);
    }).catchError((error) {
      setError(error, context);
    });
  }

  void setError(dynamic error, BuildContext context) {
    var err = Text(error.toString());
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: err));
  }

  void onMakeRequest(paymentId) {
    data["weight"] = Globals.weight.index;
    data["car_size"] = Globals.carSize.index;
    data["stripe_id"] = paymentId;
    var pathStr = "";
    Globals.path.forEach((element) {
      pathStr += "${element.latitude},${element.longitude},";
    });
    data["path"] = pathStr;
    data["price"] = price;
    data["client_id"] = FirebaseAuth.instance.currentUser.uid;
    data["status"] = "waiting";
    data["from_lat"] = Globals.fromLocation.latLng.latitude;
    data["from_lon"] = Globals.fromLocation.latLng.longitude;
    data["to_lat"] = Globals.toLocation.latLng.latitude;
    data["to_lon"] = Globals.toLocation.latLng.longitude;
    dataBloc.makeOrder(data, () {
      print("completion");
      Globals.isWaiting = true;
      Navigator.popUntil(context, ModalRoute.withName('/joblocation'));
    }, (error) {
      AlertDialog(
        title: Text("Order Request Error"),
        content: Text(error),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Ok"),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        key: _scaffoldKey,
        // appBar: AppBar(
        //   backgroundColor: Colors.white70,
        //   title: Text(
        //     "Checkout",
        //     style: TextStyle(color: Colors.black),
        //   ),
        //   iconTheme: IconThemeData(color: Colors.black),
        // ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(children: [
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
            Center(
              child: Text(
                "Checkout",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: AppConfig.size(context, 15),
                  color: AppColors.main,
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
                color: Color.fromRGBO(201, 237, 211, 1),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: AppStyle.titleLabel(context, "PRICE",
                      color: AppColors.main),
                )),
            SizedBox(height: 8),
            Container(
              color: Color.fromRGBO(201, 237, 211, 1),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppStyle.titleLabel(context, "LOADING PRICE ",
                        color: AppColors.main),
                    AppStyle.titleLabel(context,
                        "\$${Globals.weightPrices[Globals.weight.index]}",
                        color: AppColors.main),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              color: Color.fromRGBO(201, 237, 211, 1),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppStyle.titleLabel(context, "VEHICLE PRICE",
                        color: AppColors.main),
                    AppStyle.titleLabel(context,
                        "\$${Globals.carPrices[Globals.carSize.index]}",
                        color: AppColors.main),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              color: Color.fromRGBO(201, 237, 211, 1),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppStyle.titleLabel(context, "DISTANCE PRICE",
                        color: AppColors.main),
                    AppStyle.titleLabel(context, "\$$distance",
                        color: AppColors.main),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              color: AppColors.main,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppStyle.titleLabel(context, "TOTAL", color: Colors.white),
                    AppStyle.titleLabel(context, "\$$price",
                        color: Colors.white),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
                color: Colors.black,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: AppStyle.titleLabel(context, "PROJECT NAME",
                      color: Colors.white),
                )),
            SizedBox(height: 8),
            Container(
              height: AppConfig.size(context, 44),
              child: TextField(
                controller: nameController,
                maxLength: 300,
                maxLines: 10,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Comments / Special Instructions",
                  filled: true,
                  fillColor: Colors.grey[400],
                ),
                onChanged: (text) {
                  setState(() {});
                },
              ),
            ),
            AppStyle.label(
                context, "Characters left: ${300 - nameController.text.length}",
                size: 6),
            SizedBox(
              height: AppConfig.size(context, 20),
            ),
            // AppStyle.titleLabel(context, "Billing Info:"),
            // SizedBox(height: 5),
            // CreditCardInputForm(
            //   showResetButton: true,
            //   onStateChange: (currentState, cardInfo) {
            //     print(currentState);
            //     cardInformation = cardInfo;
            //   },
            //   customCaptions: customCaptions,
            //   // cardCVV: '222',
            //   // cardName: 'Jeongtae Kim',
            //   // cardNumber: '1111111111111111',
            //   // cardValid: '12/12',
            //   intialCardState: InputState.DONE,
            //   frontCardDecoration: cardDecoration,
            //   backCardDecoration: cardDecoration,
            //   prevButtonDecoration: buttonStyle,
            //   nextButtonDecoration: buttonStyle,
            //   prevButtonTextStyle: buttonTextStyle,
            //   nextButtonTextStyle: buttonTextStyle,
            //   resetButtonTextStyle: buttonTextStyle,
            // ),
            AppStyle.button(context, "Order", onPressed: () {
              onMakePayment(context);
            }),
          ]),
        ));
  }
}
