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

class MyCart extends StatefulWidget {
  @override
  MyCartState createState() => MyCartState();
}

class MyCartState extends State<MyCart> {
  String reply = "", status = "";
  List<Product_model> lis = List();
  DBProvider db ;

  @override
  void initState() {
    super.initState();

  }
 /* Future<String> addWishlist(String url, Map jsonMap) async {
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
      }else if(message == "Duplicate record"){
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
    *//*else {
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
    }*//*
    catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 16.0);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("Flutter SQLite")),
      body: FutureBuilder<List<Client>>(
        future: DBProvider.db.getAllClients(),
        builder: (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
          if (snapshot.hasData) {
            return new Card(
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              Client item = snapshot.data[index];
              return new Card(
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                child: new Container(
                  margin: EdgeInsets.fromLTRB(5.0, 5.0, 50.0, 5.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        child: Text(item.product_name,style: TextStyle(fontSize: 14.0,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            color: Colors.green
                        ),),
                      ),new Container(
                        child: Text(item.price,style: TextStyle(fontSize: 14.0,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            color: Colors.green
                        ),),
                      ),new Container(
                        child: Text(item.quantity,style: TextStyle(fontSize: 14.0,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            color: Colors.green
                        ),),
                      ),new GestureDetector(
                          onTap: () async {
                            Fluttertoast.showToast(
                                msg: "item delet from cart",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            db.deleteClient(item.product_id,item.product_name);},
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
                  ),
                ),
              );
            },
          )
         );
           /* */
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),

    );
  }
}

