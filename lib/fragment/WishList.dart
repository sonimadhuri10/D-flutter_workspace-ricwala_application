import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:ricwala_application/comman/Constants.dart';
import 'package:ricwala_application/comman/CustomProgressLoader.dart';
import 'package:ricwala_application/model/Product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishList extends StatefulWidget {
  @override
  WishListState createState() => WishListState();
}

class WishListState extends State<WishList> {
  String reply = "", status = "";
  List<Product_model> lis = List();

  @override
  Future initState() {
    super.initState();
    fetcwish();
  }

  Future fetcwish() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map map = {"user_id": '${prefs.getString('_id').toString()}'};
    wishlist(Constants.WISHLISTFETCH_URL, map);
  }

  Future delet() async {

  }

  Future<String> wishlist(String url, Map jsonMap) async {
    try {
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
      for (var word in data['details']) {
        String id = word["_id"].toString();
        String name = word["product_name"].toString();
        String company = word["company_name"].toString();
        String image = word["image"].toString();
        String description = word["description"].toString();
        String status = word["stock_status"].toString();
        String category = word["category"].toString();
        String quantity = word["quantity"].toString();
        String price = word["price"].toString();
        String unit = word["unit"].toString();
        setState(() {
          lis.add(Product_model(id, image, name, company, description, category,
              quantity, status, price, unit));
        });
      }
//var array = data['data'];
      print('RESPONCE_DATA : ' + status);
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
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 16.0);
    }
  }

  Future<String> deletItem(String url, Map jsonMap) async {
    try {
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
      String message = data['message'].toString();
      print('RESPONCE_DATA : ' + status);
      if (message == "success") {
        Fluttertoast.showToast(
            msg: "Item Successfully Removed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }else {
        Fluttertoast.showToast(
            msg: "Try sometime letter",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
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
      body: ListView.builder(
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
                            child: Image(image: AssetImage('images/logo.png')),
                            width: 100.0,
                            height: 100.0,
                          ),
                          new Expanded(
                              child: Column(
                            children: <Widget>[
                              new Container(
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                alignment: Alignment.topLeft,
                                child: new Text(
                                  lis[index].name,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
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
                                  lis[index].description,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              new Container(
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Container(
                                      margin: EdgeInsets.fromLTRB(
                                          10.0, 2.0, 0.0, 0.0),
                                      alignment: Alignment.topLeft,
                                      child: new Text(
                                        lis[index].price,
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    new Container(
                                        child: new Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        new Container(
                                          margin: EdgeInsets.fromLTRB(
                                              5.0, 3.0, 0.0, 0.0),
                                          child: Text(lis[index].price, style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        new GestureDetector(
                                            onTap: () async {
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              Map map = {"id": '${lis[index].id}'};
                                              deletItem(Constants.DELEWISHTITEM_URL, map);
                                                delet();
                                            },
                                            child: new Container(
                                              margin: EdgeInsets.fromLTRB(4.0, 3.0, 0.0, 0.0),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.green,
                                              ),
                                              height: 20.0,
                                              width: 20.0,
                                            )),
                                      ],
                                    )),
                                  ],
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
              onTap: () {
                Fluttertoast.showToast(
                    msg: lis[index].name,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
            );
          }),
    );
  }
}
