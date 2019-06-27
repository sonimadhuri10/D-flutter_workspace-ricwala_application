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
import 'package:ricwala_application/model/Product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CatProductInfo extends StatefulWidget {
  String catid,subid;
  CatProductInfo(this.catid,this.subid);

  @override
  CatProductInfoState createState() => CatProductInfoState();
}

class CatProductInfoState extends State<CatProductInfo> {
  String reply = "", status = "",count="";
  List<Product_model> lis = List();
  var isLoading = false;

  @override
  Future initState() {
    super.initState();
    Map map = {
      "categoryid": '${widget.catid}',
      "subcategoryid": '${widget.subid}'
    };
    catProduct("https://polar-basin-67929.herokuapp.com/sortbycategory", map);
  }

  Future<String> catProduct(String url, Map jsonMap) async {
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
            msg: "No any product according to your category and subcategory",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        for (var word in data['data']) {
          String id = word["_id"].toString();
          String name = word["product_name"].toString();
          String company = word["company_name"].toString();
          String image = word["image"].toString();
          String description = word["description"].toString();
          String status = word["stock_status"].toString();
          String category = word["productcategory"].toString();
          String quantity = word["productQuantity"].toString();
          String price = word["price"].toString();
          String unit = word["date"].toString();
          setState(() {

            lis.add(Product_model(id, image, name, company, description,
                category, quantity, status, price, unit));
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
        appBar: AppBar(
          title: Text('Products'),
          backgroundColor: Colors.green,
        ),
        body: new Container(
          child:isLoading ? Center(
              child: new Container(
                child:
                CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation(Colors.green),
                  strokeWidth: 5.0,
                  semanticsLabel: 'is Loading',),
              )
          ):
          ListView.builder(
              itemCount: lis.length,
              itemBuilder: (BuildContext context, int index) {
                return new GestureDetector(
                  child: Container(
                    child: Container(
                      margin: EdgeInsets.all(2.0),
                      child: Card(
                        child: new Container(
                          margin: EdgeInsets.fromLTRB(5.0, 0.0, 20.0, 0.0),
                          child: new Row(
                            children: <Widget>[
                              new Container(
                                child: Image(image: AssetImage('images/ricecan.jpg')),
                                width: 100.0,
                                height: 100.0,
                              ),
                              new Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      new Container(
                                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                        alignment: Alignment.topLeft,
                                        child: new Text(
                                          lis[index].name,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      new Container(
                                        margin:
                                        EdgeInsets.fromLTRB(10.0, 2.0, 0.0, 0.0),
                                        alignment: Alignment.topLeft,
                                        child: new Text(
                                          lis[index].company,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      new Container(
                                        margin:
                                        EdgeInsets.fromLTRB(10.0, 2.0, 0.0, 0.0),
                                        alignment: Alignment.topLeft,
                                        child: new Text(
                                          lis[index].price,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.green,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      new Container(
                                        margin:
                                        EdgeInsets.fromLTRB(10.0, 2.0, 0.0, 0.0),
                                        alignment: Alignment.topLeft,
                                        child: new Text(
                                          lis[index].unit,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        )
    );

  }
}

