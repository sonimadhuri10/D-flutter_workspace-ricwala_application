import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//import 'package:image_picker/image_picker.dart';
import 'package:ricwala_application/comman/Constants.dart';
import 'package:ricwala_application/comman/CustomProgressLoader.dart';
import 'package:ricwala_application/model/Product_model.dart';
import 'package:ricwala_application/model/VideoModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class nautification extends StatefulWidget {
  @override
  nautificationState createState() => nautificationState();
}

class nautificationState extends State<nautification> {
  List<VideoModel> lis = List();
  var isLoading = false;

  @override
  Future initState() {
    super.initState();
    showorder();
  }

  Future showorder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map map = {"userid": '${prefs.getString('_id').toString()}'};
    firmwork(Constants.ORDERHISTORY, map);
  }

  Future<String> firmwork(String url, Map jsonMap) async {
    try {
      setState(() {
        isLoading = true;
      });
      //prefs = await SharedPreferences.getInstance();
      // var isConnect = await ConnectionDetector.isConnected();
      //  if (isConnect) {
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

      if (status == "300") {
        Fluttertoast.showToast(
            msg: "No any order made by you",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        for (var word in data['data']) {
          String id = word["_id"].toString();
          String title = word["title"].toString();
          String link = word["makeproduct"].toString();
          String type = word["type"].toString();
          setState(() {
            // lis.add(VideoModel(id, title, link, type));
          });
        }
      }

//var array = data['data'];
      print('RESPONCE_DATA : ' + status);
      setState(() {
        isLoading = false;
      });
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
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return new Scaffold(
        body: new Container(
      child: isLoading
          ? Center(
              child: new Container(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation(Colors.green),
                strokeWidth: 5.0,
                semanticsLabel: 'is Loading',
              ),
            ))
          : ListView.builder(
              itemCount: lis.length,
              itemBuilder: (BuildContext context, int index) {
                return new GestureDetector(
                  child: Container(
                    child: Container(
                      margin: EdgeInsets.all(2.0),
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            new Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 0.0),
                             child: Row(
                               children: <Widget>[
                                 new Icon(Icons.notifications_active,color: Colors.green,),
                                 new Text("Nautification",style: TextStyle(fontSize: 15.0,
                                     color: Colors.black,fontWeight: FontWeight.normal),),
                               ],
                             ),
                            ),
                            /* new Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 0.0),
                              child: Text("Nautification",style: TextStyle(fontSize: 15.0,
                                  color: Colors.black,fontWeight: FontWeight.normal),),
                            ),*/
                            new Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.fromLTRB(5.0, 8.0, 10.0, 0.0),
                              child: Text(
                                lis[index].link,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.green,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
    ));
  }
}
