import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ricwala_application/activity/drawer.dart';
import 'package:ricwala_application/activity/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'activity/startscreen.dart';

void main() {
  runApp(
      new MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primaryColor: Colors.green,

        ), home: new MyApp(),
    routes: <String, WidgetBuilder>{
      '/splash': (BuildContext context) => new StartScreen(),
      '/HomeScreen': (BuildContext context) => new HomePage()
    },
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();

}

class _MyAppState extends State<MyApp>  {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  Future navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String status = prefs.getString('loginstatus').toString();
    print(status);

    if(status == 'true'){
      Navigator.of(context).pushReplacementNamed('/HomeScreen');
    }else{
       Navigator.of(context).pushReplacementNamed('/splash');
    }
    }
  @override
  void initState() {
    super.initState();
    startTime();


    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //_showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      //  _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
       // _navigateToItemDetail(message);
       },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.getToken().then((String token) async {
      assert(token != null);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('fcmid', token);
      print(token);
    });

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Image.asset('images/splash.jpg'),
      ),
    );
  }
}