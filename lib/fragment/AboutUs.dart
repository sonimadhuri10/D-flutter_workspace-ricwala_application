import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ricwala_application/comman/Constants.dart';
import 'package:ricwala_application/comman/CustomProgressLoader.dart';
import 'package:ricwala_application/model/Product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutUs extends StatefulWidget {
  @override
  AboutUsState createState() => AboutUsState();
}

class AboutUsState extends State<AboutUs> {


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return new Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                new Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  child: new Text(
                    'Who We are',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.green
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  child: new Card(
                   child: Text( 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries.',
                     style: TextStyle(color: Colors.black,
                         fontSize: 15.0,
                         fontFamily: 'Roboto:300'),
                   ),
                    
                  ),
                  
                ),

                new Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  child: new Text(
                    'Why Choose Us',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.green
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  child: new Card(
                    child: Text( 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries.',
                      style: TextStyle(color: Colors.black,
                          fontSize: 15.0,
                          fontFamily: 'Roboto:300'),
                    ),

                  ),

                ),


                new Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  child: new Text(
                    'Our Services',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.green
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  child: new Card(
                    child: Text( 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries.',
                      style: TextStyle(color: Colors.black,
                          fontSize: 15.0,
                          fontFamily: 'Roboto:300'),
                    ),

                  ),

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
