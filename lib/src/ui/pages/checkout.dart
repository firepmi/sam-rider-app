import 'package:credit_card_input_form/constants/constanst.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sam_rider_app/src/util/utils.dart';
import 'package:credit_card_input_form/credit_card_input_form.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            CreditCardInputForm(
              showResetButton: true,
              onStateChange: (currentState, cardInfo) {
                print(currentState);
                print(cardInfo);
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
          ]),
        ));
  }
}
