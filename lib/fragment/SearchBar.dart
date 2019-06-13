import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ricwala_application/comman/Constants.dart';
import 'package:ricwala_application/database/DBProvider.dart';
import 'package:ricwala_application/model/Product_model.dart';


class SearchBar extends StatefulWidget {
  SearchBar({Key key, this.title}) : super(key: key);
  final String title;

  @override
  SearchBarState createState() => new SearchBarState();
}

class SearchBarState extends State<SearchBar> {

  String reply = "", status = "";
  List<Product_model> lis = List();
  var items = List<Product_model>();
  DBProvider db;
  TextEditingController editingController = TextEditingController();

/*  final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  var items = List<String>();*/


  @override
  void initState() {
    super.initState();
    Map map = {"page": "1"};
    apiRequest(Constants.PRODUCTLIST_URL, map);
  }


  Future<String> apiRequest(String url, Map jsonMap) async {
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


  void filterSearchResults(String query) {
    List<Product_model> dummySearchList = List<Product_model>();
    dummySearchList.addAll(lis);
    if(query.isNotEmpty) {
      List<Product_model> dummyListData = List<Product_model>();
      dummySearchList.forEach((item) {
        if(lis.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(lis);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Ricwal"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
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
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[
                                                        new Container(
                                                          margin: EdgeInsets.fromLTRB(
                                                              5.0, 3.0, 0.0, 0.0),
                                                          child: Text(
                                                            lis[index].price,
                                                            style:
                                                            TextStyle(color: Colors.white),
                                                          ),
                                                        ),
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
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}