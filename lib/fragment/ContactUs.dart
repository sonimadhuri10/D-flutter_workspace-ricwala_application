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
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  child: new Text(
                    'Registrant Contact Info',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(10.0, 5.0, 15.0, 0.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        child: Image(image: AssetImage('images/cellphone.png')),
                        width: 20.0,
                        height: 20.0,
                      ),
                      new Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            child: new Text(
                          '9591670072',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(10.0, 20.0, 15.0, 0.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        child: Image(image: AssetImage('images/email.png')),
                        width: 20.0,
                        height: 20.0,
                      ),
                      new Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10.0, 00.0, 0.0, 0.0),
                            child: new Text(
                          'boostervinodkumar@cloud.com',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(10.0, 20.0, 15.0, 0.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        child: Image(image: AssetImage('images/location.png')),
                        width: 20.0,
                        height: 20.0,
                      ),
                      new Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10.0, 00.0, 0.0, 0.0),
                            child: new Text(
                          'Gitam University Banglore Campus',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ))
                    ],
                  ),
                ),

                new Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: new Text(
                    'Tech Contact Info',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(10.0, 5.0, 15.0, 0.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        child: Image(image: AssetImage('images/cellphone.png')),
                        width: 20.0,
                        height: 20.0,
                      ),
                      new Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            child: new Text(
                              '9791670072',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(10.0, 20.0, 15.0, 0.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        child: Image(image: AssetImage('images/email.png')),
                        width: 20.0,
                        height: 20.0,
                      ),
                      new Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10.0, 00.0, 0.0, 0.0),
                            child: new Text(
                              'ceo@ricwal.com',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(10.0, 20.0, 15.0, 0.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        child: Image(image: AssetImage('images/location.png')),
                        width: 20.0,
                        height: 20.0,
                      ),
                      new Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10.0, 00.0, 0.0, 0.0),
                            child: new Text(
                              'Gitam University Banglore Campus',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),

                new Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: new Text(
                    'Admin Contact Info',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(10.0, 5.0, 15.0, 0.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        child: Image(image: AssetImage('images/cellphone.png')),
                        width: 20.0,
                        height: 20.0,
                      ),
                      new Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            child: new Text(
                              '9591670072',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(10.0, 20.0, 15.0, 0.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        child: Image(image: AssetImage('images/email.png')),
                        width: 20.0,
                        height: 20.0,
                      ),
                      new Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10.0, 00.0, 0.0, 0.0),
                            child: new Text(
                              'boostervinodkumar@cloud.com',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(10.0, 20.0, 15.0, 0.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        child: Image(image: AssetImage('images/location.png')),
                        width: 20.0,
                        height: 20.0,
                      ),
                      new Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10.0, 00.0, 0.0, 0.0),
                            child: new Text(
                              'Gitam University Banglore Campus',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
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
