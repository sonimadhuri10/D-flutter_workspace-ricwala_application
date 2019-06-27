import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:ricwala_application/comman/Connectivity.dart';
import 'package:ricwala_application/comman/Constants.dart';
import 'package:ricwala_application/comman/CustomProgressLoader.dart';
import 'package:ricwala_application/database/DBProvider.dart';
import 'package:ricwala_application/fragment/ProductInfo.dart';
import 'package:ricwala_application/model/Product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_pro/carousel_pro.dart';

class dashboardFragment extends StatefulWidget {
  @override
  dashboardFragmentState createState() => dashboardFragmentState();
}

class dashboardFragmentState extends State<dashboardFragment> {
  String reply = "", status = "";
  var isLoading = false;

  List<Product_model> lis = List();
  List<Product_model> addlist = List();
  DBProvider db;
  TextEditingController count = TextEditingController();
  Drawer home;
  int _itemCount  = 1;

  @override
  void initState() {
    super.initState();
    Map map = {"page": '${_itemCount}'};
    apiRequest(Constants.PRODUCTLIST_URL, map);
  }

  void increment(){
    setState(() => _itemCount = _itemCount+1);
  }

  Future<String> apiRequest(String url, Map jsonMap) async {
    try {
      setState(() {
        isLoading = true;
      });
     // CustomProgressLoader.showLoader(context);
      //prefs = await SharedPreferences.getInstance();
     // var isConnect = await ConnectionDetector.isConnected();
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

    //   CustomProgressLoader.cancelLoader(context);

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

  Future<String> addWishlist(String url, Map jsonMap) async {
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

//var array = data['data'];
      print('RESPONCE_DATA : ' + status);

      if (message == "success") {
        Fluttertoast.showToast(
            msg: "Successfully Added",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (message == "Duplicate record") {
        Fluttertoast.showToast(
            msg: "Already Exists",
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
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.3;
    final double itemWidth = size.width / 2;
    return Scaffold(
        body: new SingleChildScrollView(
          child: Column(
            children: <Widget>[
              new SizedBox(
                  height: 150.0,
                  width: double.infinity,
                  child: new Carousel(
                    images: [
                      new NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFtJRVuVD8qNJrdysGx3WjVdJ_usxUtKHCOUwzga-lH5qKT7JsUg'),
                      new NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRi_z67Oi93lZg7hUhtSzbP_03hYOFdckil9EaqIYUge-O15Ot0LQ'),
                      new NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLx6lc69wBhJmWjudTQr_pAaSuZ6RBXy_fXKTPNhQJ_7mO5qhtYQ'),
                      new NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRv5zBZffj4cUv84MjIcqRbusWDbEGgV_Cny9SYFPkiZTpqFFw'),
                      new NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSC7eNj1-UP7EEMcSoSl3ovHMnTKxCy8TNddtNUE9-wrIacMnOx'),
                      new NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJGKXY1xLpXSFx-o0uvSHZJiE53kbzYMqilG0fPUCdnV1G4lK-'),
                    ],
                    dotSize: 4.0,
                    dotSpacing: 15.0,
                    dotColor: Colors.green,
                    indicatorBgPadding: 5.0,
                    dotBgColor: Colors.grey.withOpacity(0.5),
                  )),
              new Container(
                child:isLoading ? Center(
                  child: new Container(
                    margin: EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
                    child:
                    CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation(Colors.green),
                      strokeWidth: 5.0,
                      semanticsLabel: 'is Loading',),
                  )
                  )
                : GridView.builder(
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
                                  new GestureDetector(
                                    onTap: () async {
                                      SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                      Map map = {
                                        "user_id":
                                        '${prefs.getString('_id').toString()}',
                                        "product_id": '${lis[index].id}',
                                        "product_name": '${lis[index].name}',
                                        "company_name": '${lis[index].company}',
                                        "image": '${lis[index].image}',
                                        "description": '${lis[index]
                                            .description}',
                                        "category": '${lis[index].category}',
                                        "quantity": '${lis[index].quantity}',
                                        "unit": '${lis[index].unit}',
                                        "price": '${lis[index].price}'
                                      };
                                      addWishlist(Constants.WISHLIST_URL, map);
                                    },
                                    child: new Container(
                                      margin:
                                      EdgeInsets.fromLTRB(100.0, 15.0, 0.0, 0.0),
                                      alignment: Alignment.topRight,
                                      child: new Icon(
                                        Icons.favorite,
                                        color: _iconColor,
                                      ),
                                      width: 20.0,
                                      height: 20.0,
                                    ),
                                  ),
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
                                        margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
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
                                        margin: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
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
                                       /* new Container(
                                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                          alignment: Alignment.topRight,
                                          child: new Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              new GestureDetector(
                                                onTap: () {
                                                // increment(txt.data);
                                                  DBProvider.db.FinalClient(
                                                      lis[index].id,
                                                      lis[index].name,
                                                      "1",
                                                      lis[index].price,
                                                      lis[index].category);
                                                  setState(() {});
                                                },
                                                child: new Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      10.0, 3.0, 0.0, 0.0),
                                                  alignment: Alignment.topLeft,
                                                  child: Image(
                                                      image: AssetImage(
                                                          'images/plus.png')),
                                                  width: 20.0,
                                                  height: 20.0,
                                                ),
                                              ),
                                              new Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      5.0, 3.0, 0.0, 0.0),
                                                  child: txt),
                                              new GestureDetector(
                                                onTap: () {
                                                  setState(()=>_itemCount--);                                                  DBProvider.db.FinalDecrement(
                                                      lis[index].id,
                                                      lis[index].name,
                                                      "1",
                                                      lis[index].price,
                                                      lis[index].category);
                                                  setState(() {});
                                                },
                                                child: new Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      5.0, 3.0, 8.0, .0),
                                                  child: Image(
                                                      image: AssetImage(
                                                          'images/minus.png')),
                                                  width: 20.0,
                                                  height: 20.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )*/
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
            /*  new Container(
                color: Colors.green,
                width: double.infinity,
                height: 40.0,
                child: FlatButton(
                  child: Text("Load More",style: TextStyle(fontSize: 12.0,
                      fontWeight: FontWeight.bold,color: Colors.white),),
                  onPressed: () {
                  //  increment();
                    Map map = {"page": '${++_itemCount}'};
                    apiRequest(Constants.PRODUCTLIST_URL, map);
                    setState(() {

                    });
                  },
                ),
              )*/
            ],
          ),
        ));
  }
}
