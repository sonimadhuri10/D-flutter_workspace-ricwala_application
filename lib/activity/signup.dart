import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ricwala_application/activity/login.dart';
import 'package:ricwala_application/comman/Connectivity.dart';
import 'package:ricwala_application/comman/Constants.dart';
import 'package:ricwala_application/comman/CustomProgressLoader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class signup extends StatefulWidget {
  signup({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  signupState createState() => signupState();
}

class signupState extends State<signup> {
  int _counter = 0;
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  TextEditingController password = new TextEditingController();
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

      if (message == "success") {
        Fluttertoast.showToast(
            msg: "Successfully Register",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
             Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) => Login()));
        return reply;
      } else if (message == "Duplicate record") {
        Fluttertoast.showToast(
            msg: "Email & Mobile No already exists",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
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

  Future validation() async {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (name.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter name",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (email.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (!regex.hasMatch(email.text)) {
      Fluttertoast.showToast(
          msg: "Please enter valid email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (mobile.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter mobile no",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (mobile.text.length != 10) {
      Fluttertoast.showToast(
          msg: "Please enter 10 digit mobile no",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (password.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (password.text.length < 6) {
      Fluttertoast.showToast(
          msg: "Password atleast 6 character",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
       String did = prefs.getString('fcmid').toString();
      Map map = {
        "name": '${name.text}',
        "email": '${email.text}',
        "mobile": '${mobile.text}',
        "imei": '68786867668',
        "device_id": did,
        "password": '${password.text}'
      };
      apiRequest(Constants.SIGNUP_URL, map);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.green,
        title: new Text("Signup"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
                  child: new Text(
                    'Sign Up',
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                        child: Image(image: AssetImage('images/username.png')),
                        width: 30.0,
                        height: 30.0,
                      ),
                      new Expanded(
                          child: Container(
                        margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                        child: new TextField(
                          controller: name,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: theme.textTheme.caption
                                .copyWith(color: Colors.green),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            border: new Border(
                                bottom: new BorderSide(
                                    color: Colors.green,
                                    style: BorderStyle.solid))),
                      ))
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                        child: Image(image: AssetImage('images/email.png')),
                        width: 30.0,
                        height: 30.0,
                      ),
                      new Expanded(
                          child: Container(
                        margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                        child: new TextField(
                          controller: email,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: theme.textTheme.caption
                                .copyWith(color: Colors.green),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            border: new Border(
                                bottom: new BorderSide(
                                    color: Colors.green,
                                    style: BorderStyle.solid))),
                      ))
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                        child: Image(image: AssetImage('images/cellphone.png')),
                        width: 30.0,
                        height: 30.0,
                      ),
                      new Expanded(
                          child: Container(
                        margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                        child: new TextField(
                          controller: mobile,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Mobile',
                            labelStyle: theme.textTheme.caption
                                .copyWith(color: Colors.green),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        decoration: new BoxDecoration(
                            border: new Border(
                                bottom: new BorderSide(
                                    color: Colors.green,
                                    style: BorderStyle.solid))),
                      ))
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                        child: Image(image: AssetImage('images/password.png')),
                        width: 30.0,
                        height: 30.0,
                      ),
                      new Expanded(
                          child: Container(
                        margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                        child: new TextField(
                          controller: password,
                          obscureText: true,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: theme.textTheme.caption
                                .copyWith(color: Colors.green),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            border: new Border(
                                bottom: new BorderSide(
                                    color: Colors.green,
                                    style: BorderStyle.solid))),
                      ))
                    ],
                  ),
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
                          validation();
                        },
                        child: Text(
                          "REGISTER",
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
