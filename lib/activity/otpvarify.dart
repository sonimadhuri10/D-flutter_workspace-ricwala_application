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

class Otpvarify extends StatefulWidget {
  String otp,mobile;
  Otpvarify(this.otp,this.mobile);
  @override
  OtpvarifyState createState() => OtpvarifyState();
}

class OtpvarifyState extends State<Otpvarify> {
  int _counter = 0;
  TextEditingController otp = new TextEditingController();

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
      String status = data['status'].toString();
      String message = data['message'].toString();

      print('RESPONCE_DATA : ' + status);
      CustomProgressLoader.cancelLoader(context);

      if (message=="success") {

        var details=data['details'];
        String name = details['name'].toString();
        String email = details['email'].toString();
        String userid = details['_id'].toString();

        Fluttertoast.showToast(
            msg: "Successfully Varified",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('loginstatus', 'true');
        prefs.setString('name', name);
        prefs.setString('email', email);
        prefs.setString('_id', userid);

        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => HomePage()));
        return reply;
      } else {
        Fluttertoast.showToast(
            msg: "Try Again Some Thing Is Wrong",
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

  Future<String> resndOtp(String url, Map jsonMap) async {
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
    //  String message = data['message'].toString();
      String status = data['status'].toString();
     // String otp = data['otp'].toString();

      print('RESPONCE_DATA : ' + status);
      CustomProgressLoader.cancelLoader(context);

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
   if (otp.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter otp",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (otp.text.trim().toString() !='${widget.otp}') {
      Fluttertoast.showToast(
          msg: "Encorrect otp",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
     Map map = {
       "mobile": '${widget.mobile}',
       "status": "1"
     };
     apiRequest(Constants.OTPVARIFY_URL, map);
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
                  margin: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
                  child: new Image.asset('images/logo.png'),
                  width: 80.0,
                  height: 80.0,
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 0.0),
                  child: new TextField(
                    controller: otp,
                    obscureText: false,
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.normal,
                    ),
                    decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Enter Otp",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                  ),
                ),

                new Container(
                  margin: EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 0.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     new Expanded(child:
                    new Container(

                      child: new Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.green,
                        child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
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
                      margin: EdgeInsets.only(right: 5.0),
                    ),
                    ),
                 new Expanded(child:
                    new Container(
                      margin: EdgeInsets.only(left: 5.0),
                      child: new Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.green,
                        child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            onPressed: () {
                              Map map ={
                                "mobile": '${widget.mobile}'
                              };
                              resndOtp(Constants.RESENDOTP_URL, map);
                            },
                            child: Text(
                              "Resend",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold),
                            )),
                      ),
                    )
                    )
                   ],
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

