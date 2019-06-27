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

class CustomerSupport extends StatefulWidget {
  @override
  CustomerSupportState createState() => CustomerSupportState();
}

class CustomerSupportState extends State<CustomerSupport> {
  int _counter = 0;
  String reply = "";
  Future<File> imageFile;

  TextEditingController title = new TextEditingController();
  TextEditingController query = new TextEditingController();

  Future<String> sendQuery(String url, Map jsonMap) async {
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
      String message = data['data'].toString();

      CustomProgressLoader.cancelLoader(context);

      if (message == "success") {
        Fluttertoast.showToast(
            msg: "Your query has submitter successfully,our customer executive will solve your issue within 24 hours",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
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

  Future validation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(title.text.isEmpty && query.text.isEmpty){
      Fluttertoast.showToast(
          msg: "Please Enter Input",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
         }else{
           Map map = {"userid": '${prefs.getString('_id').toString()}',
             "title": '${title.text}',
             "note": '${query.text}'};
           sendQuery(Constants.CUSTOMERSUPPORT_URL, map);
         }
  }

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
                  margin: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
                  child: new Image.asset('images/logo.png'),
                  width: 80.0,
                  height: 80.0,
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                    child: new TextField(
                      controller: title,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: theme.textTheme.caption
                            .copyWith(color: Colors.green),
                      ),
                    ),
                    decoration: new BoxDecoration(
                        border: new Border(
                            bottom: new BorderSide(
                                color: Colors.green,
                                style: BorderStyle.solid))),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                    child: new TextField(
                      controller: query,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: 'Query',
                        labelStyle: theme.textTheme.caption
                            .copyWith(color: Colors.green),
                      ),
                    ),
                    decoration: new BoxDecoration(
                        border: new Border(
                            bottom: new BorderSide(
                                color: Colors.green,
                                style: BorderStyle.solid))),
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
                          "SEND QUERY",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
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
