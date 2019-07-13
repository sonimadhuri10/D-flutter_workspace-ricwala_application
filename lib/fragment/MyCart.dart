import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' show json;
import "package:http/http.dart" as http;
import 'package:ricwala_application/activity/drawer.dart';
import 'package:ricwala_application/fragment/CoupanList.dart';
import 'package:ricwala_application/fragment/ThankYou.dart';
import 'package:ricwala_application/fragment/dashboardFragment.dart';

//import 'package:razorpay_plugin/razorpay_plugin.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:ricwala_application/comman/Constants.dart';
import 'package:ricwala_application/database/DBProvider.dart';
import 'package:ricwala_application/model/ClientModel.dart';
import 'package:ricwala_application/model/Product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ricwala_application/comman/CustomProgressLoader.dart';

import 'CheckOutPage.dart';
import 'ProductInfo.dart';

class Cart extends StatefulWidget {
  static final String route = "Cart-route";
  String id, name, code, type, price;
  Cart(this.id, this.name, this.code, this.type, this.price);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CartState();
  }
}

class CartState extends State<Cart> {
  String type = "";
  double carttotal = 0.0, discount_amount = 0.0, paid_amount = 0.0, con = 0.0;
  Client item;
  List<Client> _cart = [];
  String reply,coupan = "Promo Code";
  TextEditingController promocodeController = new TextEditingController();
  var product_name = new StringBuffer();
  var product_id = new StringBuffer();
  var price = new StringBuffer();
  var category = new StringBuffer();
  var quantity = new StringBuffer();
  var availablequantity = new StringBuffer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() => coupan = '${widget.code}');
    _calcTotal();
    setState(() {});

  }

  void _calcTotal() async {
    var total = (await DBProvider.db.calculateTotal())[0]['Total'];
    con = double.parse('${widget.price}');

    print('sdgfsfsdgsdfgsd ${total}');
    if(total != null){
      setState(() => carttotal = total);
      setState(() => paid_amount = carttotal - con);
    }else{
      setState(() => carttotal = 0.0);
      setState(() => discount_amount = 0.0);
      setState(() => paid_amount = 0.0);
    }
  }

  Future dltCoupan() async {
    var total = (await DBProvider.db.calculateTotal())[0]['Total'];
    setState(() => coupan = '');
    setState(() => carttotal = total);
    setState(() => paid_amount = carttotal);
    setState(() => con = 0.0);
  }

  void checkoutData(_context) async {
    try {
      if (carttotal == 0.0) {
        Fluttertoast.showToast(
            msg: "Cart Is Empty",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        product_name.clear();
        product_id.clear();
        price.clear();
        category.clear();
        quantity.clear();
        availablequantity.clear();
        _cart = [];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<Map> list = await DBProvider.db.getAllClientsCard();
        list.map((dd) {
          Client d = new Client();
          d.product_id = dd["product_id"];
          d.product_name = dd["product_name"];
          d.quantity = dd["quantity"];
          d.category = dd["category"];
          d.price = dd["price"];
          _cart.add(d);
        }).toList();

        for (int i = 0; i < _cart.length; i++) {
          if (product_name.isEmpty) {
            product_name.write('${_cart[i].product_name}');
            product_id.write('${_cart[i].product_id}');
            price.write('${_cart[i].price}');
            category.write('${_cart[i].category}');
            quantity.write('${_cart[i].quantity}');
            availablequantity.write('100');
          } else {
            product_name.write(',${_cart[i].product_name}');
            product_id.write(',${_cart[i].product_id}');
            price.write(',${_cart[i].price}');
            category.write(',${_cart[i].category}');
            quantity.write(',${_cart[i].quantity}');
            availablequantity.write(',100');
          }
        }
       /* Map map = {
          "userid": '${prefs.getString('_id').toString()}',
          "coupancode": '${widget.code}',
          "totalamount": carttotal,
          "discountamount": '${widget.price}',
          "paidamount": paid_amount,
          "productid": '${product_id}',
          "productname": '${product_name}',
          "productPrice": '${price}',
          "productcategory": '[${category}]',
          "productQuantity": '[${quantity}]',
          "avelabelQuentity": '[${availablequantity}]',
        };
        placeOrder(Constants.PLACEORDR_URL, map, _context); */
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> placeOrder(String url, Map jsonMap, _context) async {
    try {
      CustomProgressLoader.showLoader(_context);
      //prefs = await SharedPreferences.getInstance();
      // var isConnect = await ConnectionDetector.isConnected();
      //  if (isConnect) {
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(jsonMap)));
      HttpClientResponse response = await request.close();
      // todo - you should check the response.statusCode
      reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      Map data = json.decode(reply);
      String status = data['response'].toString();

      CustomProgressLoader.cancelLoader(_context);

      if (status == "success") {
        DBProvider.db.deleteAll();
        setState(() {});
        Fluttertoast.showToast(
            msg: "Order Placed Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushReplacement(_context, new MaterialPageRoute(
                builder: (BuildContext context) => ThankYou()));
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

  String userId, _name, _email, _mobile;

/*
  getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString(UserPreferences.USER_ID);
      _name = prefs.getString(UserPreferences.USER_NAME);
      _email = prefs.getString(UserPreferences.USER_EMAIL);
      _mobile = prefs.getString(UserPreferences.USER_MOBILE);
      print('userID' + userId + " : " + _name + " : " + _email + " : " + _mobile);
    }
    );
  }
*/

  String _randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(length, (index) {
      return rand.nextInt(33) + 89;
    });

    return new String.fromCharCodes(codeUnits);
  }

  @override
  Widget build(BuildContext context) {
    if (carttotal != 0.0) {
      return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.green,
          title: new Text("My Cart"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: Colors.green),
              alignment: Alignment.topRight,
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => HomePage()));
              },
            ),

          ],
        ),
        body: FutureBuilder<List<Client>>(
          future: DBProvider.db.getAllClients(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Client>> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Client item = snapshot.data[index];
                        return new GestureDetector(
                          child: Container(
                            child: new Card(
                              margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: <Widget>[
                                  new Card(
                                    margin: EdgeInsets.fromLTRB(
                                        5.0, 5.0, 5.0, 5.0),
                                    child: Image(
                                      image: AssetImage('images/ricecan.jpg'),
                                      height: 80.0,
                                      width: 80.0,
                                    ),
                                  ),
                                  new Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          new Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10.0, 0.0, 0.0, 0.0),
                                            alignment: Alignment.topLeft,
                                            child: new Text(
                                              item.product_name,
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
                                                10.0, 0.0, 0.0, 0.0),
                                            child: new Row(
                                              children: <Widget>[
                                                new Container(
                                                  child: new Text(
                                                    "Quantity",
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.green,
                                                      fontWeight: FontWeight
                                                          .normal,
                                                    ),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                                new Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      10.0, 0.0, 0.0, 0.0),
                                                  child: new Icon(
                                                    Icons.linear_scale,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                                new Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      10.0, 0.0, 0.0, 0.0),
                                                  child: new Text(
                                                    item.quantity,
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.green,
                                                      fontWeight: FontWeight
                                                          .normal,
                                                    ),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          new Container(
                                            child: new Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                new Row(
                                                  children: <Widget>[
                                                    new Container(
                                                      margin: EdgeInsets
                                                          .fromLTRB(
                                                          10.0, 0.0, 0.0, 0.0),
                                                      child: new Text('Rs. ' +
                                                          item.price,
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                          color: Colors.green,
                                                          fontWeight: FontWeight
                                                              .normal,
                                                        ),
                                                        textAlign: TextAlign
                                                            .right,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                new GestureDetector(
                                                    onTap: () async {
                                                      DBProvider.db
                                                          .deleteClient(
                                                          item.product_id,
                                                          item.product_name);
                                                      _calcTotal();
                                                      setState(() {});
                                                    },
                                                    child: new Container(
                                                        child: new Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                              0.0, 3.0, 10.0,
                                                              0.0),
                                                          child: Icon(
                                                            Icons.delete,
                                                            color: Colors.green,
                                                          ),
                                                          height: 20.0,
                                                          width: 20.0,
                                                        ))),
                                              ],
                                            ),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ), onTap: () {
                          double pr = double.parse(item.price) /
                              double.parse(item.quantity);
                          Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      productInfo(
                                          item.product_name, item.category,
                                          item.description,
                                          pr.toString(), item.product_id)));
                        },
                        );
                      },
                    ),
                  ),

                  new Container(
                    color: Colors.white10,
                    margin: EdgeInsets.all(10.0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          new GestureDetector(
                            onTap: () async {
                              Navigator.pushReplacement(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (BuildContext
                                      context) =>
                                          CoupanList()));
                              setState(() {});
                            },
                            child: new Container(
                              margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                              alignment: Alignment.center,
                              child: Text('Apply Coupan', style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14.0,),),
                              height: 40.0,
                              width: 130.0,
                              decoration: BoxDecoration(color: Colors.blue,
                                  shape: BoxShape.rectangle),
                            ),),
                          new Container(
                            margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                            alignment: Alignment.center,
                            child: Text('${coupan}', style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 15.0),),
                            width: 130.0,
                            height: 40.0,
                            // decoration: BoxDecoration(border: Border.all(color: Colors.black26,width: 1.0)),
                          ),
                          new GestureDetector(
                              onTap: () async {
                                setState(() {
                                  dltCoupan();
                                });
                                /* setState(() {
                                    _calcTotal();
                                  });
                                  setState(() => coupan = '');
                                  setState(() => paid_amount = carttotal);
                                  setState(() => discount_amount = 0.0);*/
                              },
                              child: new Container(
                                  child: new Container(
                                    margin: EdgeInsets.fromLTRB(
                                        5.0, 5.0, 5.0, 5.0),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.blue,
                                    ),
                                    height: 35.0,
                                    width: 35.0,
                                  ))),
                        ],
                      ),
                    ),

                  ),
                  new Container(
                      child: new Card(
                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: Column(
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Container(
                                  margin: EdgeInsets.fromLTRB(
                                      20.0, 2.0, 0.0, 0.0),
                                  alignment: Alignment.topLeft,
                                  child: new Text(
                                    'Total Amount :',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),

                                ),
                                new Container(
                                  margin: EdgeInsets.fromLTRB(
                                      0.0, 2.0, 50.0, 0.0),
                                  alignment: Alignment.topLeft,
                                  child: new Text(
                                    "Rs."'${carttotal}',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.green,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Container(
                                  margin: EdgeInsets.fromLTRB(
                                      20.0, 2.0, 0.0, 0.0),
                                  alignment: Alignment.topLeft,
                                  child: new Text(
                                    'Discount Amount :',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                new Container(
                                  margin: EdgeInsets.fromLTRB(
                                      0.0, 2.0, 50.0, 0.0),
                                  alignment: Alignment.topLeft,
                                  child: new Text(
                                    "Rs."'${con}',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.green,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Container(
                                  margin: EdgeInsets.fromLTRB(
                                      20.0, 2.0, 0.0, 2.0),
                                  alignment: Alignment.topLeft,
                                  child: new Text('Paid Amount :',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                new Container(
                                  margin: EdgeInsets.fromLTRB(
                                      0.0, 2.0, 50.0, 2.0),
                                  alignment: Alignment.topLeft,
                                  child: new Text(
                                    "Rs."'${paid_amount}',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.green,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        bottomNavigationBar: Container(
            margin: EdgeInsets.only(bottom: 10.0),
            height: 60.0,
            decoration: BoxDecoration(
                color: Colors.white,
                border:
                Border(top: BorderSide(color: Colors.grey[300], width: 1.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 60.0,
                        child: Text(
                          "Paid Amount",
                          style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        ),
                      ),
                      Text("Rs. ${paid_amount}",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w600)),
                      //  Text("Rs. ${total}",style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                /*  ScopedModelDescendant<AppModel>(
                    builder: (context,child,model){*/
                RaisedButton(
                  color: Colors.deepOrange,
                  onPressed: () {
                    checkoutData(context);
                    Navigator.of(context).pushReplacement(
                        new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new CheckOutPgae(
                              '${carttotal}',
                              '${widget.price}',
                              '${paid_amount}',
                              '${widget.code}',
                              '${product_id}',
                              '${product_name}',
                              '${price}',
                              '${quantity}'),
                        )
                    );


                    //  checkoutData(context);
                    // checkout(DBProvider.db.getAllClientsCard());
                    //   checkoutData();
                    //startPayment(_total);
                  },
                  child: Text(
                    "Check Out",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                //          },
                //      )
              ],
            )),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text("My Cart")),
        backgroundColor: Colors.white,
        body: new Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("images/emptycart.png"),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
  }

