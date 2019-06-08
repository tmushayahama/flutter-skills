import 'package:mt/dependencies.dart';
import 'package:mt/presentation/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final dependencies = Dependencies.standard();
  final notificationManager = FlutterLocalNotificationsPlugin();

  runApp(App(
    dependencies: dependencies,
    notificationManager: notificationManager,
  ));
}
