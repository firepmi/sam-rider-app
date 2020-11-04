import 'package:flutter/material.dart';
// import 'package:native_pdf_view/native_pdf_view.dart';

class PrivacyPage extends StatefulWidget {
  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  // PdfController privacyController;
  @override
  void initState() {
    // privacyController = PdfController(
    //   document: PdfDocument.openAsset('assets/pdf/privacy.pdf'),
    // );
    super.initState();
  }

  @override
  void dispose() {
    // privacyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(
          "Privacy Policy",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      // body: PdfView(controller: privacyController),
    );
  }
}
