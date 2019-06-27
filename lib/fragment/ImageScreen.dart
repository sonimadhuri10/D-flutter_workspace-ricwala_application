import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageScreen extends StatefulWidget {
  String link ;
  ImageScreen(this.link);

  @override
  ImageScreenState createState() => ImageScreenState();
}

class ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.green,
          title: new Text("Our Work"),
        ),
        body: Container(
          child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrWX9u5_kZOLy4R_HYqL0iN6OkhLFwV12ZY7fg4tBl7EouuQSL0Q'),
          height: 200.0,
          width: double.infinity,
       )
    );
  }
}
