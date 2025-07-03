import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Privacy Policy'),
      ),
      body:  SfPdfViewer.asset(
        'assets/docs/Uboho_app_privacy_ethics_docs.pdf',
        canShowScrollHead: false,
        canShowScrollStatus: false,
      ),
    );
  }
}
