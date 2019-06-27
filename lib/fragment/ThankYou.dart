import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ricwala_application/activity/drawer.dart';


class ThankYou extends StatefulWidget {
  @override
  ThankYouState createState() => ThankYouState();
}

class ThankYouState extends State<ThankYou> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Ricwal'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      body: new Stack(
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(top: 50.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Container(
                  child: new SizedBox(
                    width: double.infinity,
                    child: new FloatingActionButton(
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.check, size: 35.0),
                    ),
                  ),
                  margin: new EdgeInsets.all(15.0),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 0.0),
                  alignment: Alignment.center,
                  child: Text('Thank You for Your Order',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30.0,fontWeight:
                      FontWeight.bold,color: Colors.green)),
                ),
                new Container(margin: EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 0.0),
                  alignment: Alignment.center,
                  child: Text('Your Order has placed successfully. When your order will ready and shipped to deliever we will give you a notification.',textAlign : TextAlign.center,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15.0,color: Colors.green),),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(30.0, 70.0, 30.0, 0.0),
                  child: new Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.green,
                    child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      HomePage()));
                        },
                        child: Text(
                          "Back to Home",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
                //your elements here
              ],
            ),
          ),
        ],
      ),
    );
  }
}
