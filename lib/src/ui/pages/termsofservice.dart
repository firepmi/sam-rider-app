import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class TermsOfServicePage extends StatefulWidget {
  @override
  _TermsOfServicePageState createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends State<TermsOfServicePage> {
  PdfController termController;

  @override
  void initState() {
    termController = PdfController(
      document: PdfDocument.openAsset('assets/pdf/termsofservice.pdf'),
    );
    super.initState();
  }

  @override
  void dispose() {
    termController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(
          "Terms of Service",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: PdfView(controller: termController),
    );
  }
}
