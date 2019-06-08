import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ricwala_application/activity/drawer.dart';
import 'package:ricwala_application/activity/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'activity/startscreen.dart';

void main() {
  runApp(
      new MaterialApp(
        title: 'Flutter Demo',
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