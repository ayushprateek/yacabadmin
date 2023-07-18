import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yacabadmin/Components/Customs.dart';
import 'package:yacabadmin/Components/GetImageURL.dart';
import 'package:yacabadmin/Services/GetCurrentLocation.dart';
import 'package:yacabadmin/Services/GetCustomCurrentLocation.dart';

class AllDriversLocation extends StatefulWidget {
  @override
  _AllDriversLocationState createState() => _AllDriversLocationState();
}

class _AllDriversLocationState extends State<AllDriversLocation> {
  List<MarkerId> listMarkerIds = List<MarkerId>.empty(growable: true);

  List<MarkerId> l = [];
  List<Marker> m = [];
  var custAddress, city, postalCode, state, country;
  TextEditingController _location = TextEditingController();

  Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late CameraPosition cameraPosition;
  late double lat, lon;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  //static  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(28.7041,77.1025), zoom: 14.4746,);
  static CameraPosition? _kGooglePlex;

  void initState() {
    super.initState();
    print("Init");

    cameraPosition = CameraPosition(target: LatLng(0, 0), zoom: 17.0);
    getCurrentLocation();
  }

  Future getCurrentLocation() async {
    print("getCurrentLocation");
    if (await Permission.location.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // backgroundColor: Colors.transparent,
            content: Container(
              height: MediaQuery.of(context).size.height / 20,
              width: MediaQuery.of(context).size.width / 1.5,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      );
      Position position = await getCustomCurrentLocation();
      Navigator.pop(context);
      print(position.latitude.toString());
      print(position.longitude.toString());
      if (position.latitude == null || position.latitude == 0.0) {
        Fluttertoast.showToast(msg: "Allow the app to access your location");
      } else {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        LatLng latlong = new LatLng(position.latitude, position.longitude);
        print("Printing current ");
        print(position.latitude);
        print(position.longitude);

        setState(() {
          cameraPosition = CameraPosition(target: latlong, zoom: 17.0);
          _kGooglePlex = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14.4746,
          );
          updateMarker(cameraPosition);
        });
      }
      return;
    }

    // LocationPermission permission = await Geolocator.checkPermission();
    // if (permission != PermissionStatus.granted) {
    //   LocationPermission permission = await Geolocator.requestPermission();
    //   if (permission != PermissionStatus.granted) {
    //     Position position = await Geolocator.getCurrentPosition(
    //         desiredAccuracy: LocationAccuracy.high);
    //     LatLng latlong = new LatLng(position.latitude, position.longitude);
    //     print("Printing current ");
    //     print(position.latitude);
    //     print(position.longitude);
    //
    //     setState(() {
    //       cameraPosition = CameraPosition(target: latlong, zoom: 17.0);
    //       _kGooglePlex = CameraPosition(
    //         target: LatLng(position.latitude, position.longitude),
    //         zoom: 14.4746,
    //       );
    //       updateMarker(cameraPosition);
    //     });
    //   }
    //
    //   return;
    // }
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    // LatLng latlong = new LatLng(position.latitude, position.longitude);
    // cameraPosition = CameraPosition(target: latlong, zoom: 17.0);
    // print("Printing");
    // print(position.latitude);
    // print(position.longitude);
    // setState(() {
    //   _kGooglePlex = cameraPosition;
    //   updateMarker(cameraPosition);
    // });
  }

  void updateMarker(CameraPosition position) {
    final MarkerId markerId = MarkerId("current");
    l.add(markerId);
    listMarkerIds.add(markerId);
    Marker marker = Marker(
        markerId: markerId,
        draggable: true,
        position: LatLng(position.target.latitude, position.target.longitude),
        onDragEnd: ((newPosition) {
          print("drag ended");
          print(newPosition.latitude);
          print(newPosition.longitude);
        }),
        onTap: () {
          print("Location selected");
          print(position.target.latitude.toString());
          print(position.target.longitude.toString());
          // address(position.target.latitude.toString(),
          //     position.target.longitude.toString());
        });
    m.add(marker);

    firRef.child("Drivers").once().then((DatabaseEvent datasnapshot) {
      try {
        Map<dynamic, dynamic> values =
            datasnapshot.snapshot.children.first.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          if (value != null &&
              value['latitude'] != null &&
              value['type'] == "T") {
            MarkerId markerId = MarkerId(key.toString());
            l.add(markerId);
            listMarkerIds.add(markerId);
            m.add(Marker(
                markerId: markerId,
                position: LatLng(value['latitude'], value['longitude']),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueCyan),
                infoWindow: InfoWindow(
                    title: value['first_name'] + " " + value['last_name'],
                    onTap: () {
                      var bottomSheetController = scaffoldKey.currentState
                          ?.showBottomSheet((context) => Container(
                                child: getBottomSheet(
                                    value['name'],
                                    value['image'],
                                    value['latitude'],
                                    value['longitude']),
                                height: 250,
                                color: Colors.transparent,
                              ));
                    },
                    snippet: value['service'])));
            print("latitude=" + value['latitude']);
          }
        });
      } catch (e) {
        print(e.toString());
      }
      for (int i = 0; i < l.length; i++) {
        markers[l[i]] = m[i];
      }

      setState(() {});
    });
    print("Hello");

    // firRef.child("Drivers").once().then(
    //         (DataSnapshot datasnapshot){
    //       try
    //       {
    //
    //         Map<dynamic,dynamic> values= datasnapshot.value;
    //         if(values!=null)
    //           values.forEach((key,value){
    //
    //
    //             try{
    //               if(value!=null && value['latitude']!=null && value['type']=="T")
    //               {
    //                 MarkerId markerId = MarkerId(key.toString());
    //                 l.add(markerId);
    //                 listMarkerIds.add(markerId);
    //                 m.add(Marker(
    //                     markerId: markerId,
    //                     position: LatLng(value['latitude'], value['longitude']),
    //                     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),infoWindow: InfoWindow(
    //                     title: value['first_name']+" "+value['last_name'],onTap: (){
    //
    //                   var  bottomSheetController=scaffoldKey.currentState.showBottomSheet((context) => Container(
    //                     child: getBottomSheet(value['name'],value['image'],value['latitude'], value['longitude']),
    //                     height: 250,
    //                     color: Colors.transparent,
    //                   ));
    //
    //                 },snippet: value['service']
    //                 )));
    //                 print("latitude="+value['latitude']);
    //
    //               }
    //
    //             }
    //             catch(e)
    //             {
    //
    //             }
    //           });
    //       }
    //       catch(e)
    //       {
    //
    //         List<dynamic> values= datasnapshot.value;
    //         if(values!=null)
    //           for(int i=0;i<values.length;i++)
    //           {
    //
    //             if(values[i]!=null && values[i]['latitude']!=null && values[i]['type']=="T")
    //             {
    //               MarkerId markerId = MarkerId(i.toString());
    //               listMarkerIds.add(markerId);
    //               l.add(markerId);
    //
    //
    //               m.add(Marker(
    //                   markerId: markerId,
    //                   position: LatLng(values[i]['latitude'], values[i]['longitude']),
    //                   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),infoWindow: InfoWindow(
    //                   title: values[i]['first_name']+" "+values[i]['last_name'],onTap: (){
    //                 var  bottomSheetController=scaffoldKey.currentState.showBottomSheet((context) => Container(
    //                   child: getBottomSheet(values[i]['first_name']+" "+values[i]['last_name'],values[i]['image'],values[i]['latitude'], values[i]['longitude']),
    //                   height: 250,
    //                   color: Colors.transparent,
    //                 ));
    //
    //               },snippet: values[i]['service']
    //               )));
    //               listMarkerIds.add(markerId);
    //               print("latitude="+values[i]['latitude'].toString());
    //               print("longitude="+values[i]['longitude'].toString());
    //
    //             }
    //           }
    //       }
    //       for(int i=0;i<l.length;i++)
    //       {
    //         markers[l[i]]=m[i];
    //       }
    //
    //       setState(() {
    //         markers;
    //
    //       });
    //     }
    // );
  }

  Future<void> address(var lat, var long) async {
    try {
      print("Address called");
      ReverseGeoCodingModel address =
          await reverseGeoCoding(double.parse(lat), double.parse(long));
      print(address.results[0].formattedAddress.toString());
      setState(() {
        _location.text = address.results[0].formattedAddress.toString();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> address(var lat, var long) async {
  //   List<Address> results = [];
  //   print("Address called");
  //   final coordinates = new Coordinates(double.parse(lat), double.parse(long));
  //   results = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //
  //   var first = results.first;
  //   if (first != null) {
  //     custAddress = first.featureName + "," + first.subLocality.toString();
  //     city = first.subAdminArea;
  //     postalCode = first.postalCode;
  //     state = first.adminArea;
  //     country = first.countryName;
  //
  //     setState(() {
  //       _location.text = first.addressLine.toString().trim();
  //     });
  //
  //     //print(custAddress);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return new Scaffold(
      resizeToAvoidBottomInset: true,
      key: scaffoldKey,
      body: SingleChildScrollView(
        // height: _height,
        // width: _width,
        child: Column(
          children: [
            Container(
              height: _height,
              width: _width,
              child: _kGooglePlex != null
                  ? GoogleMap(
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex!,
                      myLocationEnabled: true,
                      onCameraIdle: () {
                        address(cameraPosition.target.latitude.toString(),
                            cameraPosition.target.longitude.toString());
                      },
                      onCameraMove: (position) {
                        //debugPrint("Camera Position Ghulam Mustafa $position ");
                        setState(() {
                          cameraPosition = position;
                          updateMarker(cameraPosition);
                        });
                      },
                      markers: Set<Marker>.of(markers.values),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    )
                  : Container(
                      color: Colors.white,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getBottomSheet(
      String name, String image, double latitude, double longitude) {
    String location = "";
    getAddress(latitude, longitude).then((value) {
      print(value.location);
      location = value.location;
    });
    return FutureBuilder(
      future: imageurl(image),
      builder: (context, AsyncSnapshot<Url> snap) {
        if (snap.hasData) {
          Widget image;
          try {
            image = ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(snap.data?.image,
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width / 5,
                    height: MediaQuery.of(context).size.width / 5));
          } catch (e) {
            image = ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: MediaQuery.of(context).size.width / 5,
                  height: MediaQuery.of(context).size.width / 5,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ));
          }

          return Stack(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.blueAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              name,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                Text("4.5",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12)),
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text("970 Folowers",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14))
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            location != null
                                ? Text(location,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14))
                                : Text(""),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.map,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(latitude.toString() + " " + longitude.toString())
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Material(
                      elevation: 0.0,
                      color: Colors.white,
                      child: MaterialButton(
                        onPressed: () {
                          print("Calling...");
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.call,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text("Call " + name)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: image,
                ),
              )
            ],
          );
        }
        return Container();
      },
    );
  }

  Future<FutureLocation> getAddress(double latitude, double longitude) async {
    String location = "";
    try {
      print("Address called");
      ReverseGeoCodingModel address =
          await reverseGeoCoding(latitude, longitude);
      print(address.results[0].formattedAddress.toString());
      setState(() {
        location = address.results[0].formattedAddress.toString();
      });
    } catch (e) {
      print(e.toString());
    }
    return FutureLocation(location: location);
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps With Markers',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AllDriversLocation(),
    );
  }
}

class FutureLocation {
  String location;

  FutureLocation({required this.location});
}
