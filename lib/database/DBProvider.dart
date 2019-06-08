import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ricwala_application/model/ClientModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';


class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  Database _database;
  List<Client> _cart = [];


  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "shudhh2o.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE Cart ("
              "id INTEGER PRIMARY KEY,"
              "product_id TEXT,"
              "product_name TEXT,"
              "quantity TEXT,"
              "price TEXT,"
              "category TEXT"
              ")");
        });
  }



  newClient(String pro_id,String product_name,String product_quantity,String product_price,String product_category,String tablePrice) async {
    final db = await database;
    var count = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM Cart WHERE product_id = '${pro_id}'"));
    print('COUNTING DATA ${count}');
    if(count == 1){
      updateClient(pro_id,product_name,product_quantity,product_price,product_category,tablePrice);
    } else {
      //get the biggest id in the table
      var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Cart");
      int id = table.first["id"];
      //insert to the table using the new id
      var raw = await db.rawInsert(
          "INSERT Into Cart (id,product_id,product_name,quantity,price,category)"
              " VALUES (?,?,?,?,?,?)",
          [
            id,
            pro_id,
            product_name,
            product_quantity,
            product_price,
            product_category
          ]);
      Fluttertoast.showToast(msg: "Add In Your Cart", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIos: 1, backgroundColor: Colors.grey, textColor: Colors.white, fontSize: 16.0);

      return raw;

    }
    return null;
  }


  updateClient(String pro_id,String product_name,String product_quantity, product_price,String product_category,String tablePrice) async {
    final db = await database;
    int tabPrice = int.parse(tablePrice);
    int price = int.parse(product_price);
    int quan = int.parse(product_quantity);
    var res =
    db.rawUpdate("UPDATE Cart SET  quantity = '${(quan+1).toString()}',price = '${(tabPrice+price).toString()}' WHERE product_id = '${pro_id}'");
    Fluttertoast.showToast(msg: "Update In Your Cart", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIos: 1, backgroundColor: Colors.grey, textColor: Colors.white, fontSize: 16.0);

    return res;
  }


  decrementClient(String pro_id,String product_name,String product_quantity, product_price,String product_category,String tablePrice) async {
    final db = await database;
    int tabPrice = int.parse(tablePrice);
    int price = int.parse(product_price);
    int quan = int.parse(product_quantity);
    var res =
    db.rawUpdate("UPDATE Cart SET  quantity = '${(quan-1).toString()}',price = '${(tabPrice-price).toString()}' WHERE product_id = '${pro_id}'");
    Fluttertoast.showToast(msg: "Update In Your Cart", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIos: 1, backgroundColor: Colors.grey, textColor: Colors.white, fontSize: 16.0);

    return res;
  }



  getClient(String id) async {
    final db = await database;
    var res = await db.query("Cart", where: "product_id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Client.fromMap(res.first) : null;
  }


  Future<List<Client>> getAllClients() async {
    final db = await database;
    var res = await db.query("Cart");
    List<Client> list =
    res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    return list;
  }

  Future  getAllClientsCard() async {
    final db = await database;
    var res = await db.query("Cart");
    //   List<Client> list =
//    res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    print('casrdawf ${res.toList()}');

    return res.toList();
  }

  deleteClient(String id, String name) async {
    final db = await database;
    Fluttertoast.showToast(msg: "item removed from your cart", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIos: 1, backgroundColor: Colors.grey, textColor: Colors.white, fontSize: 16.0);
    return db.delete("Cart", where: "product_id = ? AND product_name = ?", whereArgs: [id,name]);

  }

  Future calculateTotal() async {
    final db = await database;
    var result = await db.rawQuery("SELECT SUM(price) as Total FROM Cart");
    print('sdfasdfasdf ${result.toList()}');
    return result.toList();
  }

  // Cart Listing
  List<Client> get cartListing => _cart;

  deleteAll() async {
    final db = await database;
    db.rawDelete("DELETE FROM Cart");
  }
}