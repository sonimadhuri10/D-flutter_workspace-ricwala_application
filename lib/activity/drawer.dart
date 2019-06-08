import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ricwala_application/activity/ProductDetail.dart';
import 'package:ricwala_application/activity/signup.dart';
import 'package:ricwala_application/fragment/ContactUs.dart';
import 'package:ricwala_application/fragment/CustomerSupport.dart';
import 'package:ricwala_application/fragment/EditProfile.dart';
import 'package:ricwala_application/fragment/MyCart.dart';
import 'package:ricwala_application/fragment/WishList.dart';
import 'package:ricwala_application/fragment/dashboardFragment.dart';
import 'package:ricwala_application/fragment/homeFragment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'login.dart';
import 'logout.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("My Orders", Icons.offline_pin),
    new DrawerItem("My Cart", Icons.add_shopping_cart),
    new DrawerItem("WishList", Icons.favorite),
    new DrawerItem("Today's Deal", Icons.business),
    new DrawerItem("Order Status", Icons.strikethrough_s),
    new DrawerItem("Privacy Setting", Icons.settings),
    new DrawerItem("Security Setting", Icons.settings_backup_restore),
    new DrawerItem("Customer Service", Icons.settings_remote),
    new DrawerItem("About Us", Icons.supervised_user_circle),
    new DrawerItem("Contact Us", Icons.mobile_screen_share),
    new DrawerItem("Logout", Icons.power_settings_new),
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  Future<File> imageFile;
  String name = "", email = "";

  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showdata();
  }

  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new dashboardFragment();
      case 1:
        return new HomeFragment();
      case 2:
        return new MyCart();
      case 3:
        return new WishList();
      case 4:
        return new dashboardFragment();
      case 5:
        return new dashboardFragment();
      case 6:
        return new dashboardFragment();
      case 7:
        return new dashboardFragment();
      case 8:
        return new CustomerSupport();
      case 9:
        return new dashboardFragment();
      case 10:
        return new ContactUs();
      case 11:
        return new Logout();
      default:
        return new Text("Error");
    }
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Image.file(
            snapshot.data,
            fit: BoxFit.fill,
            width: 300,
            height: 300,
          );
        } else if (snapshot.error != null) {
          return Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.fill, image: (AssetImage('images/logo.png')))),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.fill, image: (AssetImage('images/logo.png')))),
          );
          /*Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );*/
        }
      },
    );
  }

  Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (BuildContext context) => Login()));
  }

  Future showdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name').toString();
      email = prefs.getString('email').toString();
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Logout"),
          content: new Text("Are you sure you want to logout ?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                new Logout();
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.green,
        title: new Text("Ricwal"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications_active, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      drawer: new Drawer(
        child: SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
                margin: EdgeInsets.only(bottom: 10.0),
                currentAccountPicture: InkWell(
                  onTap: () {
                    pickImageFromGallery(ImageSource.gallery);
                  },
                  child: showImage(),
                ),
                accountName: new Container(
                    margin: EdgeInsets.fromLTRB(5.0, 3.0, 0.0, 0.0),
                    child: Text(
                      name,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                accountEmail: new Container(
                    child: new Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.fromLTRB(5.0, 3.0, 0.0, 0.0),
                      child: Text(
                        email,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    new GestureDetector(
                        onTap: () {
                         // return new EditProfile();
                           Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) => EditProfile()));
                        },
                        child: new Container(
                          margin: EdgeInsets.fromLTRB(4.0, 3.0, 0.0, 0.0),
                          child: Icon(
                            Icons.mode_edit,
                            color: Colors.white,
                          ),
                          height: 20.0,
                          width: 20.0,
                        )),
                  ],
                )),

                /*accountEmail: new Container(
                    margin: EdgeInsets.fromLTRB(5.0, 3.0, 0.0, 0.0),
                    child: Text(
                      email,
                      style: TextStyle(color: Colors.white),
                    )),*/
              ),
              new Column(children: drawerOptions)
            ],
          ),
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}



