import 'package:flutter/material.dart';

String get shortPrivacyPolicy =>
    'I do not store any data you have entered into Mt. It is yours and yours only!\n\nI do, however, ask for STORAGE permission - to allow you to add photos to your Cards.\n\nWozAppz';

class PrivacyScreen extends StatelessWidget {
  final String _privacyPolicy =
      'Last updated: 17.04.2019\n\nThe application Mt, hereby defined as the App, requests the following potentially sensitive data:\n\n• android.permission.READ_EXTERNAL_STORAGE\n\n• android.permission.WRITE_EXTERNAL_STORAGE\n\nThis potentially sensitive data is not transmitted over the internet, and is not stored by the App. It is not handled by any system other than the device the App is installed on. It is used to provide better experience while using the App.\n\nApp does not use any third party services.\n\nIf you have any questions or suggestions about this Privacy Policy, do not hesitate to contact me.\n\nWozAppz';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy Policy'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Text(_privacyPolicy, textAlign: TextAlign.justify),
        ),
      ),
    );
  }
}
