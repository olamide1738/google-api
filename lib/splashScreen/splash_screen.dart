import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';

import '../Assistance/assistant_methods.dart';
import '../global/global.dart';
import '../screens/login_screen.dart';
import '../screens/main_screen.dart';

Future<Position> getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error("Location services are disabled");
  }
  ;
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error("Location permission are denied");
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        "Location permissions are permamently denied, we cannot request");
  }
  return await Geolocator.getCurrentPosition();
}

var lat;
var long;
void liveLocation() {
  LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  Geolocator.getPositionStream(locationSettings: locationSettings)
      .listen((Position position) {
    lat = position.latitude;
    long = position.longitude;
  });
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isPulsating = true;
  static const double _maxSize = 150.0;
  static const double _minSize = 100.0;
  double _currentSize = _maxSize;

  startTimer() {
    getCurrentLocation();
    liveLocation();
    Timer(Duration(seconds: 3), () async {
      if (await firebaseAuth.currentUser != null) {
        firebaseAuth.currentUser != null
            ? AssistantMethods.readCurrentOnlineUserInfo()
            : null;
        // ignore: use_build_context_synchronously
     Navigator.push(
            context, MaterialPageRoute(builder: (c) => MainScreen()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });
  }

 
  

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Text(
          "Trippa",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        nextScreen: MainScreen(),
        splashTransition: SplashTransition.slideTransition,
        backgroundColor: Colors.black);
  }
}
