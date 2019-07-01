import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ricwala_application/comman/Constants.dart';
import 'package:ricwala_application/comman/CustomProgressLoader.dart';
import 'package:ricwala_application/database/DBProvider.dart';
import 'package:ricwala_application/fragment/ProductInfo.dart';
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
  List<String> _dropdownValues = List();
  String _currentlySelected = "Search by Category";
  var items = List<Product_model>();
  DBProvider db;
  var isLoading = false;

  TextEditingController editingController = TextEditingController();

/*  final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  var items = List<String>();*/

  @override
  void initState() {
    super.initState();
    Map map = {
      "page": "1",
    };
    setState(() {
      _dropdownValues.add("Search by Category");
    });
    apiRequest(Constants.PRODUCTLIST_URL, map);
    ProductCategory(Constants.PRO_CAT_URL);
  }

  Future<String> ProductCategory(String url) async {
    try {
      //prefs = await SharedPreferences.getInstance();
      // var isConnect = await ConnectionDetector.isConnected();
      //  if (isConnect) {
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      HttpClientResponse response = await request.close();
      // todo - you should check the response.statusCode
      var reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      Map data = json.decode(reply);
      String status = data['status'].toString();
      for (var word in data['data']) {
        String proCat = word["category_name"].toString();

        setState(() {
          _dropdownValues.add(proCat);
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

  Future<String> apiRequest(String url, Map jsonMap) async {
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

  Future<String> Search(String url, Map jsonMap, _context) async {
    try {
       setState(() {
        isLoading = true;
      }); //prefs = await SharedPreferences.getInstance();
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
        setState(() {
          lis.clear();
        });
        Fluttertoast.showToast(
            msg: "No Items according to you search",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
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
            lis.clear();
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Ricwal"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            new Container(
              child: DropdownButton(
                hint: Text(
                  '${_currentlySelected}',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                isExpanded: false,
                onChanged: (String newValue) {
                  setState(() {
                    _currentlySelected = newValue;
                  });
                },
                items: _dropdownValues.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                // value: _dropdownValues.first,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 2.0),
              child: TextField(
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            new GestureDetector(
              onTap: () {
                if (editingController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please Enter value for search",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  Map map = {
                    "searchproduct": '${editingController.text}',
                    "category": '${_currentlySelected}'
                  };
                  Search(Constants.SEARCH_URL, map, context);
                }
              },
              child: new Container(
                margin: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
                alignment: Alignment.center,
                child: new Container(
                  margin: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
                  child: Text(
                    'SEARCH',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ),
              ),
            ),
            Expanded(
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
                      shrinkWrap: true,
                      itemCount: lis.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new GestureDetector(
                          child: Container(
                            child: Container(
                              margin: EdgeInsets.all(2.0),
                              child: Card(
                                child: new Container(
                                  margin:
                                      EdgeInsets.fromLTRB(5.0, 0.0, 20.0, 0.0),
                                  child: new Row(
                                    children: <Widget>[
                                      new Container(
                                        child: Image(
                                            image: AssetImage(
                                                'images/ricecan.jpg')),
                                        width: 100.0,
                                        height: 100.0,
                                      ),
                                      new Expanded(
                                          child: Column(
                                        children: <Widget>[
                                          new Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10.0, 0.0, 0.0, 0.0),
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
                                            margin: EdgeInsets.fromLTRB(
                                                10.0, 2.0, 0.0, 0.0),
                                            alignment: Alignment.topLeft,
                                            child: new Text(
                                              lis[index].company,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.black87,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                          new Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10.0, 2.0, 0.0, 0.0),
                                            alignment: Alignment.topLeft,
                                            child: new Text(
                                              lis[index].description,
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.grey,
                                                  fontWeight:
                                                      FontWeight.normal),
                                              maxLines: 3,
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                          new Container(
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                new Row(
                                                  children: <Widget>[
                                                    new Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              8.0,
                                                              2.0,
                                                              0.0,
                                                              0.0),
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: new Text(
                                                        'Rs. ' +
                                                            lis[index].price,
                                                        style: TextStyle(
                                                            fontSize: 18.0,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        productInfo(
                                            lis[index].name, lis[index].category,
                                            lis[index].description,
                                            lis[index].price, lis[index].id)));
                          },
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }
}
