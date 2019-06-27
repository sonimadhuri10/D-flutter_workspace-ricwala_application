import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:ricwala_application/comman/Constants.dart';
import 'package:ricwala_application/comman/CustomProgressLoader.dart';
import 'package:ricwala_application/model/Product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  int _counter = 0;
  String reply = "";
  Future<File> imageFile;

  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  TextEditingController password = new TextEditingController();

/*  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }*/

  Future<String> updateUser(String url, Map jsonMap) async {
    try {
      CustomProgressLoader.showLoader(context);
      //prefs = await SharedPreferences.getInstance();
      // var isConnect = await ConnectionDetector.isConnected();
      //  if (isConnect) {9
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(jsonMap)));
      HttpClientResponse response = await request.close();
      // todo - you should check the response.statusCode
      reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      Map data = json.decode(reply);
      String message = data['message'].toString();

      CustomProgressLoader.cancelLoader(context);

      if (message == "success") {
        Fluttertoast.showToast(
            msg: "successfully updated",
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

  Future update() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map map = {
      "name": '${name.text}',
      "email": '${email.text}',
      "password": '${password.text}',
      "id": '${prefs.getString('_id').toString()}',
    };
    updateUser(Constants.UPDATEUSER_URL, map);
  }

  void validation() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (name.text.isEmpty && email.text.isEmpty && password.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please Enter Any V5alue",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (email.text.length != 0 && !regex.hasMatch(email.text)) {
      Fluttertoast.showToast(
          msg: "Please Enter valid Email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (password.text.length < 6) {
      Fluttertoast.showToast(
          msg: "Password contains atleast 6 characters",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      update();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return new Scaffold(
      appBar: AppBar(
        title: new Text("Ricwal"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                new GestureDetector(
                    onTap: () {
                    //  pickImageFromGallery(ImageSource.gallery);
                    },
                    child: new Container(
                      margin: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                      child: new Image.asset('images/logo.png'),
                      width: 80.0,
                      height: 80.0,
                    )),
                new Container(
                  margin: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                        child: Image(image: AssetImage('images/username.png')),
                        width: 30.0,
                        height: 30.0,
                      ),
                      new Expanded(
                          child: Container(
                        margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                        child: new TextField(
                          controller: name,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: theme.textTheme.caption
                                .copyWith(color: Colors.green),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            border: new Border(
                                bottom: new BorderSide(
                                    color: Colors.green,
                                    style: BorderStyle.solid))),
                      ))
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                        child: Image(image: AssetImage('images/email.png')),
                        width: 30.0,
                        height: 30.0,
                      ),
                      new Expanded(
                          child: Container(
                        margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                        child: new TextField(
                          controller: email,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'email',
                            labelStyle: theme.textTheme.caption
                                .copyWith(color: Colors.green),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            border: new Border(
                                bottom: new BorderSide(
                                    color: Colors.green,
                                    style: BorderStyle.solid))),
                      ))
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                        child: Image(image: AssetImage('images/password.png')),
                        width: 30.0,
                        height: 30.0,
                      ),
                      new Expanded(
                          child: Container(
                        margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                        child: new TextField(
                          controller: password,
                          obscureText: true,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: theme.textTheme.caption
                                .copyWith(color: Colors.green),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            border: new Border(
                                bottom: new BorderSide(
                                    color: Colors.green,
                                    style: BorderStyle.solid))),
                      ))
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(30.0, 70.0, 30.0, 0.0),
                  child: new Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.green,
                    child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                        onPressed: () {
                          validation();
                        },
                        child: Text(
                          "UPDATE PROFILE",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
