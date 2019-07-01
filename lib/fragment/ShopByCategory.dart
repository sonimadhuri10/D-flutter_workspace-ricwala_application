import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:ricwala_application/comman/Constants.dart';
import 'package:ricwala_application/comman/CustomProgressLoader.dart';
import 'package:ricwala_application/fragment/CatProductInfo.dart';
import 'package:ricwala_application/model/CategoryModel.dart';
import 'package:ricwala_application/model/Product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new MaterialApp(home: new ShopByCategory(), debugShowCheckedModeBanner: false,),);

class ShopByCategory extends StatefulWidget {
  @override
  ShopByCategoryState createState() => new ShopByCategoryState();
}

class ShopByCategoryState extends State<ShopByCategory> {
  String category = "", subcategory = "",finalid="";
  List<Vehicle> vehicles = List();
  List<CategoryModel> subcat = List();
  var isLoading = false;

  @override
  Future initState() {
    super.initState();
    exapnalist("https://polar-basin-67929.herokuapp.com/sortbycategory");
  }


  Future<Vehicle> exapnalist(String url) async {
    try {
      setState(() {
        isLoading = true;
      });
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
        String category = word["category_name"].toString();
        subcat = [];
        for (var subdetail in word['subcategory']) {
          String subcategory = subdetail["subcategory"].toString();
          String categoryid = subdetail["categoryid"].toString();
          String subid = subdetail["_id"].toString();
          subcat.add(new CategoryModel(subcategory, categoryid,subid));
        }
        setState(() {
          vehicles.add(new Vehicle(category, subcat));
          setState(() {
            isLoading = false;
          });
        });
      }
    }catch(e){
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

  _buildExpandableContent(Vehicle vehicle,_context){
    List<Widget> columnContent = [];
    for
    (CategoryModel content in vehicle.subcategory)
      columnContent.
      add(GestureDetector(
        onTap: () {
          Navigator.of(_context).push(
              new MaterialPageRoute(
                builder:(BuildContext context) =>
                new CatProductInfo('${content.catid}','${content.subid}'),
              )
          );
        },
        child: new ListTile(
          title: new Text(
            content.subcat, style: new TextStyle(fontSize: 18.0
          ), ),
        ),
        ),
      );
    return columnContent
    ;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Container(
          child:isLoading ? Center(
              child: new Container(
                child:
                CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation(Colors.green),
                  strokeWidth: 5.0,
                  semanticsLabel: 'is Loading',),
              )
          ): new ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, i) {
              return new GestureDetector(
                child: new Container(
                  child: new ExpansionTile(
                    title: new Text(vehicles[i].title, style: new TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.green), ),
                    children: <Widget>[
                      new Column(
                        children: _buildExpandableContent(vehicles[i],context),
                      ),
                    ],
                  ),
                ),
                /*onTap: () {
                  Navigator.of(context).push(
                      new MaterialPageRoute(
                        builder:(BuildContext context) =>
                       new CatProductInfo('${vehicles[i].subcategory[i].catid}','${finalid}'),
                      )
                  );
                  Fluttertoast.showToast(
                      msg: '${vehicles[i].subcategory[i].catid}' + '${finalid}',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },*/
              );

            },
          ),

      )
    );
  }
}

class Vehicle {
  final String title;
  List<CategoryModel> subcategory = [];
  Vehicle(this.title, this.subcategory);
}
