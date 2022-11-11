import 'dart:async';


import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:yacabadmin/Components/Customs.dart';
import 'package:yacabadmin/Services/CustomLaunchURL.dart';
import 'package:yacabadmin/UI/Drivers/DriversAccount.dart';

class Booking extends StatefulWidget {
  String booking_id, date;

  Booking({required this.booking_id, required this.date});

  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  List booking = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).buttonColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).buttonColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: StreamBuilder(
                stream: firRef
                    .child("Bookings")
                    .orderByChild("booking_id")
                    .equalTo(widget.booking_id)
                    .onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  booking.clear();
                  DatabaseEvent? databaseEvent = snapshot.data as DatabaseEvent;
                  databaseEvent.snapshot.children.forEach((event) {
                    booking.add(event.value as Map);
                  });
                  // try
                  // {
                  //   Map<dynamic,dynamic> values=snapshot.data.snapshot.value;
                  //   if(values!=null)
                  //     values.forEach((key, value) {
                  //       if(value!=null)
                  //         booking.add(value);
                  //     });
                  // }
                  // catch(e)
                  // {
                  //
                  //   List<dynamic> values=snapshot.data.snapshot.value;
                  //   if(values!=null)
                  //     values.forEach((value) {
                  //       if(value!=null)
                  //         booking.add(value);
                  //     });
                  // }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: Text(
                          "BOOKING ID : ${widget.booking_id}",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: Text(
                          "DATE : ${widget.date}",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 16),
                        ),
                      ),
                      Text(
                        "STATUS : " +
                            booking[0]['status'].toString().toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            fontSize: 16),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "${booking[0]['status'].toString().toUpperCase()} BY",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  booking[0]['driver_name'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                              ],
                            )),
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: MaterialButton(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DriversAccount(
                                                driver_id: booking[0]
                                                    ['driver_id'],
                                                name: booking[0]['driver_name'],
                                              )));
                                },
                                child: FittedBox(
                                  child: Text(
                                    "Visit profile",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                color: Theme.of(context).buttonColor,
                              ),
                            ))
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 3,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Row(
                          children: [
                            Text(
                              "PICKUP",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey,
                                  fontSize: 18),
                            ),
                            Spacer(),
                            Container(
                              height: MediaQuery.of(context).size.height / 20,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              margin: EdgeInsets.only(
                                  left: 8, top: 8, right: 8, bottom: 10),
                              child: MaterialButton(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  // Position pos= await getCurrentLocation();
                                  // print(pos.latitude);
                                  // print(pos.longitude);
                                  MapsLauncher.launchCoordinates(
                                      booking[0]['from_latitude'],
                                      booking[0]['from_longitude'],
                                      "PICKUP LOCATION");
                                },
                                child: FittedBox(
                                  child: Text(
                                    "View on Map",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                color: Theme.of(context).buttonColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          booking[0]['from_location'],
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 16),
                        ),
                      ),
                      Divider(
                        thickness: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Row(
                          children: [
                            Text(
                              "DROP OFF",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey,
                                  fontSize: 18),
                            ),
                            Spacer(),
                            Container(
                              height: MediaQuery.of(context).size.height / 20,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              margin: EdgeInsets.only(
                                  left: 8, top: 8, right: 8, bottom: 10),
                              child: MaterialButton(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  // Position pos= await getCurrentLocation();
                                  // print(pos.latitude);
                                  // print(pos.longitude);
                                  MapsLauncher.launchCoordinates(
                                      booking[0]['to_latitude'],
                                      booking[0]['to_longitude'],
                                      "DROPOFF LOCATION");
                                },
                                child: FittedBox(
                                  child: Text(
                                    "View on Map",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                color: Theme.of(context).buttonColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          booking[0]['to_location'],
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 16),
                        ),
                      ),
                      Divider(
                        thickness: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "BOOKED BY",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey,
                              fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Row(
                          children: [
                            Text(
                              booking[0]['customer_name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 16),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                customLaunchURL(
                                    "tel:+91" + booking[0]['customer_mobile']);
                              },
                              child: Text(
                                booking[0]['customer_mobile'],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: HexColor("#4CD864")),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "BOOKED FOR",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey,
                              fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Row(
                          children: [
                            Text(
                              booking[0]['customer_name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 16),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                customLaunchURL(
                                    "tel:+91" + booking[0]['customer_mobile']);
                              },
                              child: Text(
                                booking[0]['customer_mobile'],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: HexColor("#4CD864")),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "TRIP FARE",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey,
                              fontSize: 18),
                        ),
                      ),
                      Divider(
                        thickness: 3,
                      ),
                      Table(
                        children: [
                          TableRow(children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  booking[0]['payment_mode'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "\u{20B9}${booking[0]['trip_fare'].toString()}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "Discount",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "\u{20B9}${booking[0]['discount'].toString()}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "Amount Paid",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "\u{20B9}${booking[0]['amt_paid'].toString()}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(left:8.0),
                      //   child: Padding(
                      //       padding: const EdgeInsets.only(left:8.0,top: 8,bottom: 8),
                      //       child:  Container(
                      //         width: MediaQuery.of(context).size.width / 1.3,
                      //         height: MediaQuery.of(context).size.height/15,
                      //
                      //         decoration: BoxDecoration(
                      //           color: Colors.black,
                      //             borderRadius: BorderRadius.all(Radius.circular(10))),
                      //         margin: EdgeInsets.only(
                      //             left: 8, top: 8, right: 8, bottom: 10),
                      //         child: MaterialButton(
                      //
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.all(
                      //               Radius.circular(10),
                      //             ),
                      //           ),
                      //           onPressed: () {
                      //             // OTPsent=false;
                      //             // Navigator.push(context, new MaterialPageRoute(builder: (context) => new OTPPage(_mobileTextController.text)));
                      //           },
                      //           child:Text("CANCEL",
                      //             style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.w800,
                      //                 fontSize: 20
                      //             ),),
                      //           color: Colors.black,
                      //         ),
                      //       )
                      //   ),
                      // ),
                      booking[0]['status'].toString().toUpperCase() == "STARTED"
                          ? Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, top: 8, bottom: 8),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.3,
                                    height:
                                        MediaQuery.of(context).size.height / 15,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    margin: EdgeInsets.only(
                                        left: 8, top: 8, right: 8, bottom: 10),
                                    child: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        showAnimatedDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return ClassicGeneralDialogWidget(
                                              titleText: 'Complete',
                                              contentText: 'Are you sure you want to complete the trip?',
                                              negativeText: 'Cancel',
                                              positiveText: "DROP OFF",
                                              onPositiveClick: () {
                                                Navigator.of(context).pop();
                                              },
                                              onNegativeClick: () {
                                                Navigator.pop(context);
                                                dropOff();
                                              },
                                            );
                                          },
                                        );
                                        // animated_dialog_box.showScaleAlertBox(
                                        //   context: context,
                                        //   title: Text("Complete"),
                                        //   icon: Icon(FlutterIcons.check_ant),
                                        //   yourWidget: Text(
                                        //     "Are you sure you want to complete the trip?",
                                        //     textAlign: TextAlign.center,
                                        //     style: TextStyle(
                                        //         color: Colors.black,
                                        //         fontWeight: FontWeight.w600,
                                        //         fontSize: 20),
                                        //   ),
                                        //   firstButton: Container(
                                        //     decoration: BoxDecoration(
                                        //         borderRadius: BorderRadius.all(
                                        //             Radius.circular(10))),
                                        //     child: MaterialButton(
                                        //       shape: RoundedRectangleBorder(
                                        //         borderRadius: BorderRadius.all(
                                        //           Radius.circular(10),
                                        //         ),
                                        //       ),
                                        //       onPressed: () {
                                        //         Navigator.pop(context);
                                        //       },
                                        //       child: Text(
                                        //         "Cancel",
                                        //         style: TextStyle(
                                        //             color: Colors.black,
                                        //             fontSize: 20),
                                        //       ),
                                        //       color:
                                        //           Theme.of(context).buttonColor,
                                        //     ),
                                        //   ),
                                        //   secondButton: Container(
                                        //     decoration: BoxDecoration(
                                        //         borderRadius: BorderRadius.all(
                                        //             Radius.circular(10))),
                                        //     child: MaterialButton(
                                        //       shape: RoundedRectangleBorder(
                                        //         borderRadius: BorderRadius.all(
                                        //           Radius.circular(10),
                                        //         ),
                                        //       ),
                                        //       onPressed: () {
                                        //         Navigator.pop(context);
                                        //         dropOff();
                                        //       },
                                        //       child: Text(
                                        //         "DROP OFF",
                                        //         style: TextStyle(
                                        //             color: Colors.white,
                                        //             fontSize: 20),
                                        //       ),
                                        //       color: Colors.red,
                                        //     ),
                                        //   ),
                                        // );
                                      },
                                      child: Text(
                                        "DROP OFF",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20),
                                      ),
                                      color: Theme.of(context).buttonColor,
                                    ),
                                  )),
                            )
                          : Container(),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void dropOff() {
    firRef
        .child("Bookings")
        .orderByChild("booking_id")
        .equalTo(widget.booking_id)
        .once()
        .then((DatabaseEvent datasnapshot) {
      try {
        Map<dynamic, dynamic> values =
            datasnapshot.snapshot.children.first.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          if (value != null)
            firRef
                .child("Bookings")
                .child(key.toString())
                .update({"status": "Completed"});
        });
      } catch (e) {
        print(e.toString());
      }

      Timer(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    });
    // firRef.child("Bookings").orderByChild("booking_id").equalTo(widget.booking_id).once().then((snapshot) {
    //   try
    //       {
    //         Map<dynamic,dynamic> values=snapshot.value;
    //         if(values!=null)
    //           values.forEach((key, value) {
    //             if(value!=null)
    //               firRef.child("Bookings").child(key.toString()).update({
    //                 "status":"Completed"
    //               });
    //           });
    //       }
    //       catch(e)
    //   {
    //
    //   }
    //   Timer(Duration(seconds: 1),(){
    //     Navigator.pop(context);
    //   });
    // });
  }
}
