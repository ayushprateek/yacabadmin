import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:yacabadmin/Components/Customs.dart';
import 'package:yacabadmin/UI/Drivers/DriversAccount.dart';

class AssignDriver extends StatefulWidget {
  String booking_id;

  AssignDriver({required this.booking_id});

  @override
  _AssignDriverState createState() => _AssignDriverState();
}

class _AssignDriverState extends State<AssignDriver> {
  String driver_id = "1", driver_name = "";
  bool isSet = false;
  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController id = TextEditingController();
  List drivers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text(
          "Assign Driver",
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(border: Border.all()),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        child: TextFormField(
                          onTap: () {},
                          controller: name,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Customer Name",
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(0.0),
                              borderSide: new BorderSide(color: Colors.grey),
                            ),
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(0.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          style: new TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        child: TextFormField(
                          onTap: () {},
                          controller: mobile,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Customer Mobile",
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(0.0),
                              borderSide: new BorderSide(color: Colors.grey),
                            ),
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(0.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          keyboardType: TextInputType.number,
                          style: new TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        child: TextFormField(
                          onTap: () {},
                          controller: email,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Customer Email",
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(0.0),
                              borderSide: new BorderSide(color: Colors.grey),
                            ),
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(0.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          keyboardType: TextInputType.emailAddress,
                          style: new TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        child: TextFormField(
                          onTap: () {},
                          controller: id,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Customer ID",
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(0.0),
                              borderSide: new BorderSide(color: Colors.grey),
                            ),
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(0.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          keyboardType: TextInputType.number,
                          style: new TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              margin: EdgeInsets.only(
                                  left: 8, top: 8, right: 8, bottom: 10),
                              child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FittedBox(
                                      child: Text(
                                        "Search",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  color: Color(0XFF35B736)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              StreamBuilder(
                stream: firRef.child("Drivers").onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  drivers.clear();
                  DatabaseEvent? databaseEvent = snapshot.data as DatabaseEvent;
                  databaseEvent.snapshot.children.forEach((event) {
                    Map value = event.value as Map;
                    if (value['driver_id'] != null) if (name.text.isNotEmpty
                        ? value['name']
                            .toString()
                            .toLowerCase()
                            .contains(name.text.toLowerCase())
                        : true && email.text.isNotEmpty
                            ? value['email']
                                .toString()
                                .toLowerCase()
                                .contains(email.text.toLowerCase())
                            : true && mobile.text.isNotEmpty
                                ? value['mobile']
                                    .toString()
                                    .contains(mobile.text)
                                : true && id.text.isNotEmpty
                                    ? value['customer_id']
                                        .toString()
                                        .contains(id.text)
                                    : true) {
                      drivers.add(event.value as Map);
                    }
                  });

                  // try{
                  //   List<dynamic> values=snapshot.data.snapshot.value;
                  //   if(values!=null)
                  //     values.forEach((value) {
                  //       if(value!=null && value['driver_id']!=null)
                  //         if( name.text.isNotEmpty?value['name'].toString().toLowerCase().contains(name.text.toLowerCase()):true
                  //             && email.text.isNotEmpty?value['email'].toString().toLowerCase().contains(email.text.toLowerCase()):true
                  //             && mobile.text.isNotEmpty?value['mobile'].toString().contains(mobile.text):true
                  //             && id.text.isNotEmpty?value['customer_id'].toString().contains(id.text):true
                  //         )
                  //         {
                  //           drivers.add(value);
                  //         }
                  //     });
                  // }
                  // catch(e)
                  // {
                  //   Map<dynamic,dynamic> values=snapshot.data.snapshot.value;
                  //   if(values!=null)
                  //     values.forEach((key,value) {
                  //       if(value!=null && value['driver_id']!=null)
                  //         if( name.text.isNotEmpty?value['name'].toString().toLowerCase().contains(name.text.toLowerCase()):true
                  //             && email.text.isNotEmpty?value['email'].toString().toLowerCase().contains(email.text.toLowerCase()):true
                  //             && mobile.text.isNotEmpty?value['mobile'].toString().contains(mobile.text):true
                  //             && id.text.isNotEmpty?value['customer_id'].toString().contains(id.text):true
                  //         )
                  //         {
                  //           drivers.add(value);
                  //         }
                  //     });
                  // }
                  if (!isSet) {
                    isSet = true;
                    driver_id = drivers[0]['driver_id'];
                    driver_name = drivers[0]['name'];
                  }
                  return ListView.builder(
                      itemCount: drivers.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        String status = drivers[index]['status'] == "True"
                            ? "Approved"
                            : drivers[index]['status'] == "False"
                                ? "Disapproved"
                                : drivers[index]['status'];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                driver_id = drivers[index]['driver_id'];
                                driver_name = drivers[index]['name'];
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 20),
                                  child: Row(
                                    children: [
                                      Radio(
                                        onChanged: (val) {
                                          setState(() {
                                            driver_id =
                                                drivers[index]['driver_id'];
                                            driver_name =
                                                drivers[index]['name'];
                                          });
                                        },
                                        value: driver_id,
                                        groupValue: drivers[index]['driver_id'],
                                        activeColor: Colors.black,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    "Name : ${drivers[index]['name']} ",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DriversAccount(
                                                                  driver_id: drivers[
                                                                          index]
                                                                      [
                                                                      'driver_id'],
                                                                  name: drivers[
                                                                          index]
                                                                      ['name'],
                                                                )));
                                                  },
                                                  icon: Icon(
                                                    Icons.arrow_forward,
                                                    size: 35,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "EMAIL",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              drivers[index]['email'],
                                              style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "MOBILE",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              drivers[index]['mobile'],
                                              style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "STATUS",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 6,
                                                      ),
                                                      Text(
                                                        status,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      margin: EdgeInsets.only(
                                                          top: 8,
                                                          right: 8,
                                                          bottom: 10),
                                                      child: MaterialButton(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  5),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            if (drivers[index][
                                                                    'latitude'] !=
                                                                null)
                                                              MapsLauncher.launchCoordinates(
                                                                  drivers[index]
                                                                      [
                                                                      'latitude'],
                                                                  drivers[index]
                                                                      [
                                                                      'longitude'],
                                                                  drivers[index]
                                                                      ['name']);
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: FittedBox(
                                                              child: Text(
                                                                "View Location",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          color: Color(
                                                              0XFF35B736)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0XFF35B736),
        onPressed: () {
          assignDriver();
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            Icons.save,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void assignDriver() {
    firRef
        .child("Bookings")
        .orderByChild("booking_id")
        .equalTo(widget.booking_id)
        .once()
        .then((DatabaseEvent dataSnapshot) {
      try {
        if (dataSnapshot.snapshot.children.first.key != null &&
            dataSnapshot.snapshot.children.first.key != '') {
          firRef
              .child("Bookings")
              .child(dataSnapshot.snapshot.children.first.key ?? '')
              .update({
            "driver_name": driver_name,
            "driver_id": driver_id,
            "status": "Assigned"
          });
        }
      } catch (e) {
        print(e.toString());
      }
      Fluttertoast.showToast(msg: "Driver Assigned");
      Timer(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    });

    // firRef.child("Bookings").orderByChild("booking_id").equalTo(widget.booking_id).once().then((snapshot) {
    //   try{
    //     Map<dynamic,dynamic> values=snapshot.value;
    //     if(values!=null)
    //       values.forEach((key, value) {
    //         if(value!=null)
    //           firRef.child("Bookings").child(key.toString()).update({
    //             "driver_name":driver_name,
    //             "driver_id":driver_id,
    //             "status":"Assigned"
    //           });
    //       });
    //   }
    //   catch(e)
    //   {
    //
    //   }
    //   Fluttertoast.showToast(msg: "Driver Assigned");
    //   Timer(Duration(seconds: 1),(){
    //     Navigator.pop(context);
    //   });
    // });
  }
}
