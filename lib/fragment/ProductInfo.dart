import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:ricwala_application/comman/Constants.dart';
import 'package:ricwala_application/comman/CustomProgressLoader.dart';
import 'package:ricwala_application/comman/spinner_input.dart';
import 'package:ricwala_application/database/DBProvider.dart';
import 'package:ricwala_application/model/Product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MyCart.dart';

class productInfo extends StatefulWidget {
  String id, name, category, description, price;
  productInfo(this.name, this.category, this.description, this.price, this.id);
  DBProvider db;

  @override
  productInfoState createState() => productInfoState();
}

class productInfoState extends State<productInfo> {
  String reply;
  double spinner = 1;
  double total = 0;
  int count =0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    total = double.tryParse('${widget.price}');
    cartCount();
  }

  cartCount() async {
    var cartitem =  await DBProvider.db.getCount();
    setState(()  {
      count =  cartitem;
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return new Scaffold(
      appBar: AppBar(
        title: Text("Product Detail"),
        actions: <Widget>[
          Center
            (child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: InkResponse(
                  onTap: (){
                    Navigator.of(context).pushReplacement(
                        new MaterialPageRoute(
                            builder:(BuildContext context) =>
                            new Cart('','','','','0')
                        )
                    );                      },
                  child: Icon(Icons.shopping_cart),
                ),
              ),
              Positioned(
                child: Container(
                  child: Text('${count}'),
                  // child: Text((DBP.length > 0) ? model.cartListing.length.toString() : "",textAlign: TextAlign.center,style: TextStyle(color: Colors.orangeAccent,fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
                child: new Image.asset('images/ricecan.jpg'),
                width: 200.0,
                height: 200.0,
              ),
              new Container(
                margin: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 0.0),
                alignment: Alignment.center,
                child: new Text('${widget.description}',
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                    textAlign: TextAlign.justify),
              ),
              new Container(
                child: new Row(
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.fromLTRB(25.0, 10.0, 0.0, 0.0),
                      alignment: Alignment.topLeft,
                      child: new Text(
                        'Name :',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.fromLTRB(70.0, 10.0, 0.0, 0.0),
                      alignment: Alignment.topLeft,
                      child: new Text(
                        '${widget.name}',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                child: new Row(
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.fromLTRB(25.0, 10.0, 0.0, 0.0),
                      alignment: Alignment.topLeft,
                      child: new Text(
                        'Company :',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.fromLTRB(50.0, 10.0, 0.0, 0.0),
                      alignment: Alignment.topLeft,
                      child: new Text(
                        '${widget.category}',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                child: new Row(
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.fromLTRB(25.0, 10.0, 0.0, 0.0),
                      alignment: Alignment.topLeft,
                      child: new Text(
                        'Price :',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.fromLTRB(75.0, 10.0, 0.0, 0.0),
                      alignment: Alignment.center,
                      child: new Text(
                        'Rs. '
                        '${widget.price}',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(25.0, 10.0, 0.0, 0.0),
                          alignment: Alignment.topLeft,
                          child: new Text(
                            'Quantity :',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      new Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0.0, 5.0,0.0, 0.0),
                          alignment: Alignment.topLeft,
                          child: SpinnerInput(
                            spinnerValue: spinner,
                            minValue: 1,
                            maxValue: 200,
                            minusButton: SpinnerButtonStyle(
                                color: Colors.green, height: 30.0, width: 30.0),
                            plusButton: SpinnerButtonStyle(
                                color: Colors.green, height: 30.0, width: 30.0),
                            onChange: (newValue) {
                              setState(() {
                                spinner = newValue;
                                total = double.tryParse('${widget.price}') * spinner;
                              });
                            },
                          ),
                          //   margin: EdgeInsets.only(left:8.0),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      )),
      bottomNavigationBar: Container(
          margin: EdgeInsets.only(bottom: 10.0),
          height: 60.0,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[300], width: 1.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 60.0,
                      child: Text(
                        "Total Amount",
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ),
                    Text("Rs. ${total}",
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
                  DBProvider.db.FinalClient('${widget.id}', '${widget.name}',
                      spinner.toString(), total.toString(), '${widget.category}','${widget.description}');
                  Future.delayed(const Duration(milliseconds: 1500), () {
                    cartCount();
                  });
                 /* Future.delayed(const Duration(milliseconds: 2000), () {
                    setState(() {
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder:(BuildContext context) =>
                              new Cart('','','','','0')
                          )
                      );                    });
                  });*/
                },
                child: Text(
                  "Add To Cart",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              //          },
              //      )
            ],
          )),
    );
  }
}
