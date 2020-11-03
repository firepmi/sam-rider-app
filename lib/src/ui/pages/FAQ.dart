import 'package:flutter/material.dart';
import 'package:sam_rider_app/src/util/utils.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  List<String> titles = [
    "How does SAM: Swift Asset Movement Work",
    "What is SAM: Swift Asset Movement's off-loading policy?",
    "How does pricing work?",
    "What are SAM’s operating hours?",
    "Does SAM: Swift Asset Movement markup prices?",
    "How do I pay for SAM?",
    "How will I be notified when SAM: Swift Asset Movement is in route to deliver my materials?",
    "Where does SAM off-load my material?",
    "How and when will I be charged for SAM: Swift Asset Movement?"
  ];

  List<Widget> getItems(BuildContext context) {
    var items = List<Widget>();
    for (int i = 0; i < titles.length; i++) {
      items.add(getItem(context, i));
    }
    return items;
  }

  Widget getItem(BuildContext context, int index) {
    return ExpansionTile(
      title: new Text(
        titles[index],
        style: new TextStyle(
            fontSize: AppConfig.size(context, 8),
            fontWeight: FontWeight.bold,
            color: AppColors.main),
      ),
      children: <Widget>[
        new Column(
          children: _buildExpandableContent(index),
        ),
      ],
    );
  }

  _buildExpandableContent(int index) {
    TextStyle style = TextStyle(
        fontSize: AppConfig.size(context, 8), color: Colors.grey[800]);
    TextStyle boldStyle = TextStyle(
        fontSize: AppConfig.size(context, 8), fontWeight: FontWeight.bold);
    List<Widget> content1 = [
      SizedBox(height: 20),
      Text(
        "SAM is a same-day construction and building materials delivery service. Customers select materials through a mobile application from various suppliers and the order is delivered by a personal shopper",
        style: style,
      ),
      SizedBox(height: 20),
      Align(
        alignment: Alignment.centerLeft,
        child: Text("Stay onsite", style: boldStyle),
      ),
      SizedBox(height: 20),
      Text(
        "Whether you're a builder, contractor, house flipper, or handyman, one thing is for certain - there are constant shortages of materials that affect job completion and profit made. The days of",
        style: style,
      ),
      SizedBox(height: 20),
      Text("    •	Leaving the job site to run to your favorite local supplier",
          style: style),
      Text(
          "    •	Limited oversight on what your runners are actually buying and why they took so long",
          style: style),
      Align(
        alignment: Alignment.centerLeft,
        child: Text("    •	Battling traffic", style: style),
      ),
      Text("    •	Shopping and waiting in the dreadful line", style: style),
      Text("    •	Not having equipment to haul needed materials", style: style),
      SizedBox(height: 20),
      Align(
          alignment: Alignment.centerLeft,
          child: Text("...are over", style: boldStyle)),
      SizedBox(height: 20),
      Align(
          alignment: Alignment.centerLeft,
          child: Text("Order Pickup", style: boldStyle)),
      SizedBox(height: 20),
      RichText(
        text: TextSpan(
          style: style,
          children: <TextSpan>[
            TextSpan(
                text:
                    'Have you already placed an order from your favorite supplier and these materials are ready for pickup? Using SAM Pickup my Order" feature, '),
            TextSpan(
                text:
                    'our drivers will retrieve the ready-for-pickup order and bring the materials to you same day. ',
                style: boldStyle),
            TextSpan(text: 'We are your personal runner.'),
          ],
        ),
      ),
      SizedBox(height: 20),
      Align(
          alignment: Alignment.centerLeft,
          child: Text("In-App Purchasing", style: boldStyle)),
      SizedBox(height: 20),
      RichText(
        text: TextSpan(
          // Note: Styles for TextSpans must be explicitly defined.
          // Child text spans will inherit styles from parent
          style: style,
          children: <TextSpan>[
            TextSpan(
                text:
                    'Using SAM, you can simply select the supplier of your choice - '),
            TextSpan(text: 'Home Depot', style: boldStyle),
            TextSpan(text: ' or '),
            TextSpan(text: "Lowe's. ", style: boldStyle),
            TextSpan(
                text:
                    'Browse a catalogue of materials or search for exactly what you need. Add materials to your cart and complete the order. SAM will retrieve the items for you from the chosen supplier. Pay for them at the store checkout and deliver them to you same-day. '),
          ],
        ),
      ),
      SizedBox(height: 20),
    ];
    List<Widget> content2 = [
      SizedBox(height: 20),
      Text(
        "SAM: Swift Asset Movement's standard procedure is to off-load your materials on the driveway or in the garage.",
        style: style,
      ),
      SizedBox(height: 20),
      Text(
        "SAM: Swift Asset Movement's off-loading policy is consistent with the majority of building material suppliers. However, we understand that in times of convenience you may want to have the materials off-loaded in different areas of the job site, i.e. inside the home, behind the house, a specific area of your job site, etc. ",
        style: style,
      ),
      SizedBox(height: 20),
      RichText(
        text: TextSpan(
          style: style,
          children: <TextSpan>[
            TextSpan(
                text:
                    'If you prefer to have SAM: Swift Asset Movement off-load your materials in a different area other than the driveway or garage, '),
            TextSpan(
                text:
                    'please put your request in the comment box during checkout. ',
                style: boldStyle),
            TextSpan(
                text:
                    'SAM: Swift Asset Movement will assess the request and contact you if we are able to fulfill this request, if pricing is affected, or if we are unable satisfy your request.'),
          ],
        ),
      ),
      SizedBox(height: 30),
    ];
    List<Widget> content3 = [
      SizedBox(height: 20),
      Text(
        "Pricing is based on weight, distance, dimensions, and effort to unload your materials.",
        style: style,
      ),
      SizedBox(height: 20),
      Align(
        alignment: Alignment.centerLeft,
        child: Text("Standard Pricing", style: boldStyle),
      ),
      SizedBox(height: 20),
      RichText(
        text: TextSpan(
          style: style,
          children: <TextSpan>[
            TextSpan(text: '\$49', style: boldStyle),
            TextSpan(
                text:
                    'for materials that weigh under 350 lbs. Materials cannot be 16ft or longer at this tier. Materials that are longer require a flatbed and the delivery fee will become \$89.'),
          ],
        ),
      ),
      SizedBox(height: 20),
      Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            style: style,
            children: <TextSpan>[
              TextSpan(text: '\$89', style: boldStyle),
              TextSpan(
                  text:
                      ' for materials that weigh between 351 lbs - 2,000 lbs.'),
            ],
          ),
        ),
      ),
      SizedBox(height: 20),
      Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            style: style,
            children: <TextSpan>[
              TextSpan(text: '\$169', style: boldStyle),
              TextSpan(
                  text: ' for materials that weigh between 2,001 - 4,000 lbs'),
            ],
          ),
        ),
      ),
      SizedBox(height: 20),
      Align(
          alignment: Alignment.centerLeft,
          child: Text("Additional Fees", style: boldStyle)),
      SizedBox(height: 20),
      RichText(
        text: TextSpan(
          style: style,
          children: <TextSpan>[
            TextSpan(
                text:
                    'Included in the base price above, is a 15 mile radius around the pickup location. A '),
            TextSpan(text: '\$1.50/mile ', style: boldStyle),
            TextSpan(
                text:
                    'charge will incurred after the 15 mile radius has been travelled.\n\nIf multiple off-loaders are required to off-load your materials and personnel is not onsite to help for the off-loading process, an additional '),
            TextSpan(text: '\$29 fee', style: boldStyle),
            TextSpan(
                text:
                    'fee will incur for off-loading services.\n\nIf you have selected that personnel will be onsite and they are not there when SAM: Swift Asset Movement arrives, a \$45 penalty will incur.'),
          ],
        ),
      ),
      SizedBox(height: 30),
    ];
    List<Widget> content4 = [
      SizedBox(height: 20),
      Text(
        "SAM is open Monday through Friday from 8:00am - 8:00pm, Saturday from 8:00am - 9:00pm, and closed on Sunday.",
        style: style,
      ),
      SizedBox(height: 30),
    ];
    List<Widget> content5 = [
      SizedBox(height: 20),
      RichText(
        text: TextSpan(
          style: style,
          children: <TextSpan>[
            TextSpan(
                text:
                    'SAM: Swift Asset Movement sources materials based on your selection of Home Depot or Lowe\'s.\n\nSAM: Swift Asset Movement '),
            TextSpan(text: 'does not ', style: boldStyle),
            TextSpan(
                text:
                    'markup any of the pricing. Products in-app are priced from the selected supplier. '),
          ],
        ),
      ),
      SizedBox(height: 30),
    ];
    List<Widget> content6 = [
      SizedBox(height: 20),
      Text(
        "SAM accepts all major credit / debit cards to pay for materials and the delivery of them.\n\nAll payments are processed in-app at the time of purchase using a:\n",
        style: style,
      ),
      Align(
          alignment: Alignment.centerLeft,
          child: Text("    •	Visa", style: style)),
      Align(
        alignment: Alignment.centerLeft,
        child: Text("    •	Mastercard", style: style),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text("    •	American Express", style: style),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text("    •	Discover", style: style),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text("    •	Debit Card", style: style),
      ),
      SizedBox(height: 30),
    ];
    List<Widget> content7 = [
      SizedBox(height: 20),
      Text(
        "The drivers’ location is made available to the client using the SAM mobile app. \n\nOnce the SAM: Swift Asset Movement driver has loaded your order and began their transit to your job site, you will be notified and will have the option to contact the driver at any time.",
        style: style,
      ),
      SizedBox(height: 30),
    ];
    List<Widget> content8 = [
      SizedBox(height: 20),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Our standard off-loading procedure is the driveway or garage.\n",
          style: style,
        ),
      ),
      Text(
        "Will there be an additional charge if SAM: Swift Asset Movement unloads my order?\n",
        style: boldStyle,
      ),
      Text(
        "Here at SAM: Swift Asset Movement we're all about speed. If we see that an order is going to take a driver 30+ minutes just to unload, we will send an additional Runner to help unload at an additional charge of \$29/Runner\n",
        style: style,
      ),
      Text(
        "What is the maximum length of material that SAM: Swift Asset Movement will deliver?\n",
        style: boldStyle,
      ),
      Text(
        "SAM: Swift Asset Movement will deliver materials with a maximum length of 20 feet.\nSAM: Swift Asset Movement's fleet does not include 18 wheelers or long flatbeds that have lift gates or moffetts to off-load material. Currently, our maximum length flatbed is 14.5 feet.",
        style: style,
      ),
      SizedBox(height: 40),
    ];
    List<Widget> content9 = [
      SizedBox(height: 20),
      Text(
        "SAM: Swift Asset Movement is a pay as you go service. Our customers are charged when materials have been verified and materials are out for delivery.\n\nIf you have placed an order through SAM: Swift Asset Movement's app from Home Depot or Lowe's - our drivers will verify inventory of the materials that you have ordered and only after this quality control will you be charged for your materials / delivery",
        style: style,
      ),
      SizedBox(height: 50),
    ];
    var contents = [
      content1,
      content2,
      content3,
      content4,
      content5,
      content6,
      content7,
      content8,
      content9
    ];
    return contents[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "FAQ",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white70,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: getItems(context),
          ),
        ));
  }
}
