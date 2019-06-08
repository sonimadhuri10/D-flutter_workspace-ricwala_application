import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ricwala_application/activity/ForgotPassword.dart';
import 'package:ricwala_application/activity/otpvarify.dart';
import 'package:ricwala_application/activity/signup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ricwala_application/comman/Constants.dart';
import 'package:ricwala_application/comman/CustomProgressLoader.dart';
import 'package:ricwala_application/comman/Connectivity.dart';
import 'drawer.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail({Key key, this.title}) : super(key: key);


  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  ProductDetailState createState() => ProductDetailState();
}

class ProductDetailState extends State<ProductDetail> {
  int _counter = 0;
  bool obscureText=true,passwordVisible = false;


  String reply;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return new Scaffold(
      body: SingleChildScrollView(
        child: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
                child: new Image.asset('images/ricecan.jpg'),
                width: 200.0,
                height: 200.0,
              ),
              new Container(
                margin: EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 0.0),
                alignment: Alignment.center,
                child: new Text(
                  "Pure long Dawat Rice",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              new Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
                alignment: Alignment.center,
                child: new Text(
                  "Mogra Churi Brand",
                  style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal),
                ),
              ),
              new Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
                alignment: Alignment.center,
                child: new Text(
                  "Rs 300/5 Kg",
                  style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal),
                ),
              ),
              new Container(
                margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.fromLTRB(
                          10.0, 3.0, 0.0, 0.0),
                      child: Image(
                          image: AssetImage('images/plus.png')),
                      width: 30.0,
                      height: 30.0,
                    ),
                    new Container(
                        margin: EdgeInsets.fromLTRB(5.0, 3.0, 0.0, 0.0),
                        child: new Text("1",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        )),
                    new Container(
                      margin: EdgeInsets.fromLTRB(
                          5.0, 3.0, 0.0, 0.0),
                      child: Image(image: AssetImage(
                          'images/minus.png')),
                      width: 30.0,
                      height: 30.0,
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
        )


      ),
    );
  }
}
