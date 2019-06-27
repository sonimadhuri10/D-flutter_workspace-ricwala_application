import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:image_picker/image_picker.dart';
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
        body: Center(
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20,),
                Text('ABOUT US',
                  style: TextStyle(fontSize: 25, color: Colors.green),
                  textAlign: TextAlign.center,),
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green)
                        ),
                        width: 50,

                      ),
                      SizedBox(width: 5),
                      Text('OUR STORY', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green)
                        ),
                        width: 50,
                      ),
                    ]
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor Lorem ipsum dolor sit amet sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum',
                    style: TextStyle(color: Colors.green, fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),

                )
              ],
            )

        )

    );
  }
}
