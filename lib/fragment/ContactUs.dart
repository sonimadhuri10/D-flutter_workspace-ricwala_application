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

class ContactUs extends StatefulWidget {
  @override
  ContactUsState createState() => ContactUsState();
}

class ContactUsState extends State<ContactUs> {
  int _counter = 0;
  String reply = "", email = "", mobile = "", address = "";

  /* @override
  void initState() {
    super.initState();
   Map map = {"id": "1"};
    contactus(Constants.CONTACTUS_URL, map);
  }
*/

  Future<String> contactus(String url, Map jsonMap) async {
    try {
      CustomProgressLoader.showLoader(context);
      //prefs = await SharedPreferences.getInstance();
      // var isConnect = await ConnectionDetector.isConnected();
      //  if (isConnect) {9
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(jsonMap)));
      HttpClientResponse response = await request.close();
      // todo - you should check the response.statusCode
      reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      Map data = json.decode(reply);
      var details = data['data'];
      mobile = details['mobile'].toString();
      email = details['email'].toString();
      address = details['Address'].toString();

      CustomProgressLoader.cancelLoader(context);
    }
    /*else {
        CustomProgressLoader.cancelLoader(context);
        Fluttertoast.showToast(
            msg: "Please check your internet connection....!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        // ToastWrap.showToast("Please check your internet connection....!");
        // return response;
      }
    }*/
    catch (e) {
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
                  margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: new Text(
                    'Contact US',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 0.0),
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
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                        child: new Text(
                          '9691889808',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.green,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ))
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
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
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                        child: new Text(
                          'admin@gmail.com',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.green,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ))
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                        child: Image(image: AssetImage('images/location.png')),
                        width: 30.0,
                        height: 30.0,
                      ),
                      new Expanded(
                          child: Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                        child: new Text(
                          '401 satguru prinay MR-9',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.green,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ))
                    ],
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
