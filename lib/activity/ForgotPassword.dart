import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ricwala_application/activity/drawer.dart';
import 'package:ricwala_application/activity/login.dart';
import 'package:ricwala_application/activity/signup.dart';
import 'package:ricwala_application/comman/Connectivity.dart';
import 'package:ricwala_application/comman/Constants.dart';
import 'package:ricwala_application/comman/CustomProgressLoader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPassword extends StatefulWidget {
  String otp,mobile;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  ForgotPasswordyState createState() => ForgotPasswordyState();
}

class ForgotPasswordyState extends State<ForgotPassword> {
  int _counter = 0;
  TextEditingController mobile = new TextEditingController();

  String reply;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<String> apiRequest(String url, Map jsonMap) async {
    try {
      CustomProgressLoader.showLoader(context);
      //prefs = await SharedPreferences.getInstance();
      /// var isConnect = await ConnectionDetector.isConnected();
      // if (isConnect) {
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(jsonMap)));
      HttpClientResponse response = await request.close();
      // todo - you should check the response.statusCode
      var reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      Map data = json.decode(reply);
      String message = data['message'].toString();
      String status = data['status'].toString();

      print('RESPONCE_DATA : ' + status);
      CustomProgressLoader.cancelLoader(context);


      if(status=="200"){
        Fluttertoast.showToast(
            msg: 'Password sent on your ragister number',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }else{
        Fluttertoast.showToast(
            msg: 'not ragistered',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      /*} else {
        CustomProgressLoader.cancelLoader(context);
        Fluttertoast.showToast(
            msg: "Please check your internet connection....!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }*/
    } catch (e) {
      CustomProgressLoader.cancelLoader(context);
      print(e);
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      return reply;
    }
  }


  void validation() {
    if (mobile.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter mobile or email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Map map = {
        "mobile": '${mobile.text}'
      };
      apiRequest(Constants.FORGOTPASSWORD_URL, map);
    }
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      /*appBar: AppBar(
        title: new Text(""),
        backgroundColor: Colors.blue,
      ),*/
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
                  child: new Image.asset('images/logo.png'),
                  width: 80.0,
                  height: 80.0,
                ),

                new Container(
                  margin: EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 0.0),
                  child: new TextField(
                    controller: mobile,
                    obscureText: false,
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.normal,
                    ),
                    decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Enter Mobile Or Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(100.0, 30.0, 100.0, 0.0),
                  child: new Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.green,
                    child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                        onPressed: () {
                          validation();
                        },
                        child: Text(
                          "Submit",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}

