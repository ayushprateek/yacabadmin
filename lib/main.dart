import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yacabadmin/UI/Admin/LoginPage.dart';

late SharedPreferences localStorage;
// Future<dynamic> backGroundMessage(Map<String,dynamic> message)
// {
//   Fluttertoast.showToast(msg: "You received a new job");
//   return "";
// }
Future<void> main() async {
  Map<int, Color> color = {
    50: Color.fromRGBO(254, 212, 40, .1),
    100: Color.fromRGBO(254, 212, 40, .2),
    200: Color.fromRGBO(254, 212, 40, .3),
    300: Color.fromRGBO(254, 212, 40, .4),
    400: Color.fromRGBO(254, 212, 40, .5),
    500: Color.fromRGBO(254, 212, 40, .6),
    600: Color.fromRGBO(254, 212, 40, .7),
    700: Color.fromRGBO(254, 212, 40, .8),
    800: Color.fromRGBO(254, 212, 40, .9),
    900: Color.fromRGBO(254, 212, 40, 1),
  };
  MaterialColor colorCustom = MaterialColor(0xFFFED428, color);
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Color(0XFFFED428),
          // buttonColor: Color(0XFFFED428),
          primarySwatch: colorCustom,
          appBarTheme: AppBarTheme(
              elevation: 0,
              backgroundColor: Color(0XFFFED428),
              iconTheme: IconThemeData(
                color: Colors.black,
                size: 30,
              ))),
      home: MyApp(),
      //home:  Send(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // FirebaseMessaging _firebaseMessaging=FirebaseMessaging();

  Future getCurrentLocation() async {
    // print("getCurrentLocation");
    // LocationPermission permission = await Geolocator.checkPermission();
    // if (permission != PermissionStatus.GRANTED) {
    //   LocationPermission permission = await Geolocator.requestPermission();
    //   if (permission != PermissionStatus.GRANTED) {
    //     try{
    //       Position position = await Geolocator.getLastKnownPosition();
    //       if(position== null)
    //         position = await Geolocator.getCurrentPosition(
    //             desiredAccuracy: LocationAccuracy.high);
    //       print("Printing current");
    //       print(position.latitude);
    //       print(position.longitude);
    //       UserDetails.currentLatitude=position.latitude;
    //       UserDetails.currentLongitude=position.longitude;
    //     }
    //     catch(e)
    //     {
    //       print(e.toString());
    //     }
    //   }
    //   else
    //   {
    //     print(permission.toString());
    //   }
    //
    //   return;
    // }
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    // print("Printing");
    // print(position.latitude);
    // print(position.longitude);
  }

  @override
  void initState() {
    //TODO:FIREBASE MESSEGING FOR IOS
    // _firebaseMessaging.configure(
    //   onMessage: (message)async{
    //     Fluttertoast.showToast(msg: "You received a new job");
    //   },
    //   onLaunch: (message)async{
    //     Fluttertoast.showToast(msg: "You received a new job");
    //   },
    //   onResume: (message)async{
    //     Fluttertoast.showToast(msg: "You received a new job");
    //   },
    //   onBackgroundMessage: backGroundMessage,
    // );
    getCurrentLocation();
    initConnectivity();
    navigate();
    // _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initConnectivity() async {
    // ConnectivityResult result;
    //
    // try {
    //   result = await _connectivity.checkConnectivity();
    // } on PlatformException {
    // }
    // if (!mounted) {
    //   return Future.value(null);
    // }
    //
    // return _updateConnectionStatus(result);
  }

  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   switch (result) {
  //     case ConnectivityResult.none:
  //       key.currentState
  //           .showSnackBar(
  //           SnackBar(
  //             content: Text(
  //                 'Failed to get connectivity.'),
  //             backgroundColor:
  //             Colors
  //                 .red,
  //           ));
  //       break;
  //     default:
  //       navigate();
  //   }
  // }
  void navigate() async {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'images/Logo2.png',
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.height / 4,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Ya Cab\nAdmin",
              style: TextStyle(
                  fontFamily: "Fredoka One",
                  fontSize: 50,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ));
  }
}
//todo: replace Application with MyApplication in AndroidMenifest.xml file
