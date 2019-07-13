import 'package:flutter/material.dart';
import 'package:ricwala_application/activity/splash.dart';

class StartScreen extends StatefulWidget{
  @override
  _StartScreenState createState() => _StartScreenState();
}
class _StartScreenState extends State<StartScreen>{
  @override
  Widget build(BuildContext context) {

    final forgotLabel = FlatButton(
      child: Text('Welcome to Ricwal',
        style: TextStyle(color: Colors.green,fontSize: 20.0),
      ),
    );
    final signUpButton = Container(
      child: new SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: () {
            Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) => splash()));
          },
          padding: EdgeInsets.all(20),
          color: Colors.green,
          child: Text('GET STARTED', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
    Widget middleSection =  new Container (
      child: new Column(
        //  crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Image.asset('images/slider.png')
        ],
      ),
      //   ),
    );
    final textLabel = FlatButton(
      child: Text(
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries.',
        style: TextStyle(color: Colors.black54,
            fontFamily: 'Roboto:300'),textAlign: TextAlign.justify,
      ),
    );
    Widget body = new SingleChildScrollView(
      child: new Column(
        // This makes each child fill the full width of the screen
        /* crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,*/
        children: <Widget>[
          middleSection,
          SizedBox(height: 5.0),
          forgotLabel,
          textLabel,
          SizedBox(height: 15.0),
          new Container(
            alignment: Alignment.bottomCenter,
            child: signUpButton,
          )
        ],
      ),
    );
    return new Scaffold(
      body: new Padding(
        padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        child: body,
      ),
    );
  }
}