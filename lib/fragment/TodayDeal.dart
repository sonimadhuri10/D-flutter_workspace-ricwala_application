import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:ricwala_application/comman/Constants.dart';
import 'package:ricwala_application/comman/CustomProgressLoader.dart';
import 'package:ricwala_application/database/DBProvider.dart';
import 'package:ricwala_application/fragment/ProductInfo.dart';
import 'package:ricwala_application/model/Product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_pro/carousel_pro.dart';

class TodayDeal extends StatefulWidget {
  @override
  TodayDealState createState() => TodayDealState();
}

class TodayDealState extends State<TodayDeal> {
  String reply = "", status = "";
  List<Product_model> lis = List();
  DBProvider db;
  TextEditingController count = TextEditingController();
  Drawer home;
  int _itemCount  = 0;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    Map map = {"page": "1"};
    apiRequest(Constants.TODAYDEAL_URL, map);
  }

  void increment(String data){
    String str_value = data;
    int str_qunat = int.parse(str_value) + 1;
    setState(() => _itemCount = str_qunat);
  }

  Future<String> apiRequest(String url, Map jsonMap) async {
    try {
      setState(() {
        isLoading = true;
      });
      //  CustomProgressLoader.showLoader(context);
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

      //.  CustomProgressLoader.cancelLoader(context);

      for (var word in data['data']) {
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
          lis.add(Product_model(
              id,
              image,
              name,
              company,
              description,
              category,
              quantity,
              status,
              price,
              unit));
        });
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
    final Orientation orientation = MediaQuery
        .of(context)
        .orientation;
    Color _iconColor = Colors.green;

    Text txt = Text('',
        style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.normal,
            color: Colors.green));

    final theme = Theme.of(context);
    var size = MediaQuery
        .of(context)
        .size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.6;
    final double itemWidth = size.width / 2;
    return Scaffold(
        body: new Container(
            child:isLoading ? Center(
                child: new Container(
                  child:
                  CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation(Colors.green),
                    strokeWidth: 5.0,
                    semanticsLabel: 'is Loading',),
                )
            ): new SingleChildScrollView(
          child: Column(
            children: <Widget>[
              new Container(
                child: GridView.builder(
                  physics: PageScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: (itemWidth / itemHeight)),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.all(2.0),
                      child: new GestureDetector(
                        child: Container(
                          child: Container(
                            margin: EdgeInsets.all(2.0),
                            child: Card(
                              child: Column(
                                children: <Widget>[
                                  new Container(
                                    margin:
                                    EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
                                    child: new Image.asset(
                                        'images/ricecan.jpg'),
                                    width: double.infinity,
                                    height: 125.0,
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      new Container(
                                        margin: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
                                        alignment: Alignment.topLeft,
                                        child: new Text(
                                          'Name :',
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight
                                                  .normal),
                                        ),
                                      ),
                                      new Container(
                                        margin: EdgeInsets.fromLTRB(30.0, 5.0, 0.0, 0.0),
                                        alignment: Alignment.topLeft,
                                        child: new Text(
                                          lis[index].name,
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      new Container(
                                        margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                                        alignment: Alignment.topLeft,
                                        child: new Text(
                                          'Brand :',
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight
                                                  .normal),
                                        ),
                                      ),
                                      new Container(
                                        margin: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                                        alignment: Alignment.topLeft,
                                        child: new Text(
                                          lis[index].company,
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight
                                                  .normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                  new Container(
                                    child: new Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        new Row(
                                          children: <Widget>[
                                            new Container(
                                              margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                                              alignment: Alignment.topLeft,
                                              child: new Text(
                                                'Price :',
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight
                                                        .normal),
                                              ),
                                            ),
                                            new Container(
                                              margin: EdgeInsets.fromLTRB(33.0, 0.0, 0.0, 0.0),
                                              alignment: Alignment.topLeft,
                                              child: new Text('Rs. '+
                                                  lis[index].price,
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight
                                                        .normal),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      productInfo(
                                          lis[index].name, lis[index].category,
                                          lis[index].description,
                                          lis[index].price, lis[index].id)));
                        },
                      ),
                    );
                  },
                  itemCount: lis.length,
                ),
              ),
            ],
          ),
    )
        ));
  }
}
