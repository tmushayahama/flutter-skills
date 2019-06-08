import 'package:mt/dependencies.dart';
import 'package:mt/presentation/colorful_app.dart';
import 'package:mt/presentation/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Dependencies _sharedDependencies;
Dependencies get dependencies => _sharedDependencies;

FlutterLocalNotificationsPlugin _notificationManager;
FlutterLocalNotificationsPlugin get notificationManager => _notificationManager;

class App extends StatelessWidget {
  App({
    Key key,
    Dependencies dependencies,
    FlutterLocalNotificationsPlugin notificationManager,
  }) : super(key: key) {
    _sharedDependencies = dependencies;
    _notificationManager = notificationManager;
  }

  final String _title = 'General Purpose Cards';

  @override
  Widget build(BuildContext context) {
    return ColorfulApp(
      builder: (context, theme) {
        return MaterialApp(
          title: _title,
          theme: theme,
          // debugShowCheckedModeBanner: false, // removes debug ribbon
          home: HomeScreen(title: _title),
        );
      },
    );
  }
}
