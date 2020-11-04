import 'package:flutter/material.dart';
import 'package:sam_rider_app/src/util/utils.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final nameController = TextEditingController();
  TextEditingController creditCardController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController expirationController = TextEditingController();
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // AppStyle.titleLabel(context, "Project name"),
            // Container(
            //   height: AppConfig.size(context, 44),
            //   child: TextField(
            //     controller: nameController,
            //     maxLength: 300,
            //     maxLines: 10,
            //     decoration: InputDecoration(
            //         hintText: "Comments / Special Instructions"),
            //     onChanged: (text) {
            //       setState(() {});
            //     },
            //   ),
            // ),
            // AppStyle.label(
            //     context, "Characters left: ${300 - nameController.text.length}",
            //     size: 6),
            // SizedBox(
            //   height: AppConfig.size(context, 20),
            // ),
            // AppStyle.titleLabel(context, "Billing Info:"),
            // CreditCardFormField(
            //   decoration: InputDecoration(
            //     border: OutlineInputBorder(),
            //     labelText: "Credit Card Number",
            //   ),
            //   controller: creditCardController,
            // ),
            // SizedBox(height: 8),
            // CVVFormField(
            //   decoration: InputDecoration(
            //     border: OutlineInputBorder(),
            //     labelText: "CVV",
            //   ),
            //   controller: cvvController,
            // ),
            // SizedBox(height: 8),
            // ExpirationFormField(
            //   decoration: InputDecoration(
            //     border: OutlineInputBorder(),
            //     labelText: "Card Expiration",
            //     hintText: "MM/YY",
            //   ),
            //   controller: expirationController,
            // ),
          ]),
        ));
  }
}
