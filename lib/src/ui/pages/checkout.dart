import 'package:credit_card_input_form/constants/constanst.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sam_rider_app/src/blocs/data_bloc.dart';
import 'package:sam_rider_app/src/util/globals.dart';
import 'package:sam_rider_app/src/util/utils.dart';
import 'package:credit_card_input_form/credit_card_input_form.dart';
import 'package:stripe_payment/stripe_payment.dart';

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
    var distance = getDistance();

    if (distance < 5)
      price += 5;
    else
      price += distance;

    StripePayment.setOptions(StripeOptions(
        publishableKey: publishableKey,
        merchantId:
            "SAM_rider${FirebaseAuth.instance.currentUser.uid}", //YOUR_MERCHANT_ID
        androidPayMode: 'production'));
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
    if (cardInformation == null) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Incorrect card information')));
      return;
    }
    String validate = cardInformation.validate;

    if (validate.length != 5) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Incorrect card information')));
      return;
    }
    print(int.parse(validate.split("/")[0]));
    print(int.parse(validate.split("/")[1]));
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
      // onMakeRequest(token.tokenId);
    }).catchError((error) {
      setError(error, context);
    });
    // StripePayment.createPaymentMethod(
    //   PaymentMethodRequest(
    //     card: CreditCard(
    //       number: cardInformation.cardNumber,
    //       expMonth: int.parse(validate.split("/")[0]),
    //       expYear: int.parse(validate.split("/")[1]),
    //     ),
    //   ),
    // ).then((paymentMethod) {
    //   _scaffoldKey.currentState.showSnackBar(
    //       SnackBar(content: Text('Received ${paymentMethod.id}')));
    //   setState(() {
    //     _paymentMethod = paymentMethod;
    //   });
    //   onMakeRequest(paymentMethod.id);
    // }).catchError((error) {
    //   setError(error, context);
    // });
  }

  void setError(dynamic error, BuildContext context) {
    var err = Text(error.toString());
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: err));
    // Scaffold.of(context).showSnackBar(SnackBar(content: err));
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
              // Navigator.of(context).pop("cancel");
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
        appBar: AppBar(
          backgroundColor: Colors.white70,
          title: Text(
            "Checkout",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(children: [
            AppStyle.titleLabel(context, "Project name"),
            Container(
              height: AppConfig.size(context, 44),
              child: TextField(
                controller: nameController,
                maxLength: 300,
                maxLines: 10,
                decoration: InputDecoration(
                    hintText: "Comments / Special Instructions"),
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
            AppStyle.titleLabel(context, "Billing Info:"),
            SizedBox(height: 5),
            CreditCardInputForm(
              showResetButton: true,
              onStateChange: (currentState, cardInfo) {
                print(currentState);
                cardInformation = cardInfo;
              },
              customCaptions: customCaptions,
              // cardCVV: '222',
              // cardName: 'Jeongtae Kim',
              // cardNumber: '1111111111111111',
              // cardValid: '12/12',
              intialCardState: InputState.DONE,
              frontCardDecoration: cardDecoration,
              backCardDecoration: cardDecoration,
              prevButtonDecoration: buttonStyle,
              nextButtonDecoration: buttonStyle,
              prevButtonTextStyle: buttonTextStyle,
              nextButtonTextStyle: buttonTextStyle,
              resetButtonTextStyle: buttonTextStyle,
            ),
            AppStyle.button(context, "Order", onPressed: () {
              onMakePayment(context);
            }),
          ]),
        ));
  }
}
