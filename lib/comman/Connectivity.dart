import 'dart:async';
import 'package:connectivity/connectivity.dart';
class ConnectionDetector{

  static final Connectivity connectivity =new Connectivity();
  static Future<bool>isConnected()async
  {  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
  print("Connected to Mobile Network");
  } else if (connectivityResult == ConnectivityResult.wifi) {
  print("Connected to WiFi");
  } else {
  print("Unable to connect. Please Check Internet Connection");
  }
  }

}