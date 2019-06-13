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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Cart")),
      body: FutureBuilder<List<Client>>(
        future: DBProvider.db.getAllClients(),
        builder: (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
          if (snapshot.hasData) {
           return new Container(
                child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              Client item = snapshot.data[index];
              return new Container(
                child: new Card(
                  margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Card(
                        margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                        child: Image(image: AssetImage('images/logo.png'),
                        height: 80.0,
                          width: 80.0,
                        ),
                      ),
                     new Expanded(child: Column(
                       children: <Widget>[
                         new Container(
                           margin:
                           EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
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
                           margin:
                           EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                           alignment: Alignment.topLeft,
                           child: new Text(
                             item.quantity,
                             style: TextStyle(
                               fontSize: 18.0,
                               color: Colors.green,
                               fontWeight: FontWeight.normal,
                             ),
                             textAlign: TextAlign.right,
                           ),
                         ),
                        new Container(
                          margin:  EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Container(
                                child: new Text(
                                  item.quantity,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.green,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              new GestureDetector(
                                  onTap: () async {
                                    DBProvider.db.deleteClient(item.product_id,item.product_name);
                                    setState(() {});
                                  },
                                  child: new Container(
                                      child: new Container(
                                        margin: EdgeInsets.fromLTRB(0.0, 3.0, 10.0, 0.0),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.green,
                                        ),
                                        height: 20.0,
                                        width: 20.0,
                                      )
                                  )),
                            ],
                          ),

                        )
                       ],
                     ))

                    ],
                  ),
                ),
              );
            },
          ),

            );

           /* */
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar:
        new Container(
          height: 40.0,
          color: Colors.green,
          alignment: Alignment.center,
          child: Text('Place Order',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 16.0),),
        ),
    );
  }
}

