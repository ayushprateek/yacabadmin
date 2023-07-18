import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:yacabadmin/Components/Customs.dart';
import 'package:yacabadmin/Components/GetImageURL.dart';
import 'package:yacabadmin/Services/CustomLaunchURL.dart';
import 'package:yacabadmin/UI/Admin/AllBookings.dart';
import 'package:yacabadmin/UI/Drivers/DocumentManagement/CabsDoc/FitnessCertificate.dart';
import 'package:yacabadmin/UI/Drivers/DocumentManagement/CabsDoc/Insurance.dart';
import 'package:yacabadmin/UI/Drivers/DocumentManagement/CabsDoc/LeasePaper.dart';
import 'package:yacabadmin/UI/Drivers/DocumentManagement/CabsDoc/PollutionCertificate.dart';
import 'package:yacabadmin/UI/Drivers/DocumentManagement/CabsDoc/RoutePermit.dart';
import 'package:yacabadmin/UI/Drivers/DocumentManagement/DriversDoc/AddressDetails.dart';
import 'package:yacabadmin/UI/Drivers/DocumentManagement/DriversDoc/AdhaarDetails.dart';
import 'package:yacabadmin/UI/Drivers/DocumentManagement/DriversDoc/BankDetails.dart';
import 'package:yacabadmin/UI/Drivers/DocumentManagement/DriversDoc/DrivingLiscense.dart';
import 'package:yacabadmin/UI/Drivers/DocumentManagement/DriversDoc/PANDetails.dart';
import 'package:yacabadmin/UI/Drivers/EditDriver.dart';
import 'package:yacabadmin/UI/Drivers/Vehicle.dart';

class DriversAccount extends StatefulWidget {
  String driver_id, name;

  DriversAccount({required this.driver_id, required this.name});

  @override
  _DriversAccountState createState() => _DriversAccountState();
}

class _DriversAccountState extends State<DriversAccount> {
//TODO:DISPLAY DRIVER'S VEHICLE ALSO
  List driver = [];

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
          widget.name == null ? "Driver's Account" : widget.name,
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
                height: 50,
              ),
              StreamBuilder(
                stream: firRef
                    .child("Drivers")
                    .orderByChild("driver_id")
                    .equalTo(widget.driver_id)
                    .onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  driver.clear();
                  DatabaseEvent? databaseEvent = snapshot.data as DatabaseEvent;
                  databaseEvent.snapshot.children.forEach((event) {
                    driver.add(event.value as Map);
                  });
                  // try{
                  //   List<dynamic> values=snapshot.data.snapshot.value;
                  //   if(values!=null)
                  //     values.forEach((value) {
                  //       if(value!=null)
                  //         driver.add(value);
                  //     });
                  // }
                  // catch(e)
                  // {
                  //   Map<dynamic,dynamic> values=snapshot.data.snapshot.value;
                  //   if(values!=null)
                  //     values.forEach((key,value) {
                  //       if(value!=null)
                  //         driver.add(value);
                  //     });
                  // }
                  if (driver.length != 0)
                    return ListView.builder(
                        itemCount: driver.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          String status = driver[index]['status'] == "True"
                              ? "Approved"
                              : driver[index]['status'] == "False"
                                  ? "Disapproved"
                                  : driver[index]['status'];
                          Widget image = FutureBuilder(
                              future: imageurl(driver[index]['image']),
                              builder: (context, AsyncSnapshot<Url> snap) {
                                if (!snapshot.hasData)
                                  return Image.asset(
                                    'images/Logo2.png',
                                    fit: BoxFit.cover,
                                  );
                                try {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      snap.data?.image,
                                      fit: BoxFit.cover,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              6,
                                      width:
                                          MediaQuery.of(context).size.height /
                                              6,
                                    ),
                                  );
                                } catch (e) {
                                  return Image.asset(
                                    'images/Logo2.png',
                                    fit: BoxFit.cover,
                                  );
                                }
                              });
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditDriver(
                                            driver_id: widget.driver_id,
                                            name: widget.name,
                                          )));
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Name : ${driver[index]['name']}",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                                Text(
                                                  "Driver ID : ${driver[index]['driver_id']} ",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w900,
                                                  ),
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
                                                  "${driver[index]['email']}",
                                                  style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          image
                                        ],
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
                                      InkWell(
                                        onTap: () {
                                          customLaunchURL(
                                              "tel:+91${driver[index]['mobile']}");
                                        },
                                        child: Text(
                                          "${driver[index]['mobile']}",
                                          style: TextStyle(
                                            fontSize: 19,
                                            color: Color(0XFF4CD864),
                                            fontWeight: FontWeight.w500,
                                          ),
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
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "STATUS",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                status,
                                                style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              margin: EdgeInsets.only(
                                                  left: 8,
                                                  top: 8,
                                                  right: 8,
                                                  bottom: 10),
                                              child: MaterialButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    if (driver[index]
                                                            ['latitude'] !=
                                                        null)
                                                      MapsLauncher
                                                          .launchCoordinates(
                                                              driver[index]
                                                                  ['latitude'],
                                                              driver[index]
                                                                  ['longitude'],
                                                              driver[index]
                                                                  ['name']);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "View Location",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                  color: Color(0XFF35B736)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        margin: EdgeInsets.only(
                                            left: 8,
                                            top: 8,
                                            right: 8,
                                            bottom: 10),
                                        child: MaterialButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AllBookings(
                                                            id: widget
                                                                .driver_id,
                                                            keyName:
                                                                "driver_id",
                                                          )));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "View bookings of this driver",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            color: Color(0XFF35B736)),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  else
                    return Container();
                },
              ),
              SizedBox(
                height: 20,
              ),
              // InkWell(
              //   onTap: (){
              //     Navigator.push(context, MaterialPageRoute(builder: (context)=>AdhaarDetails()));
              //   },
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Container(
              //         height: MediaQuery.of(context).size.height/5,
              //         decoration: BoxDecoration(
              //             color: Colors.white,
              //             borderRadius: BorderRadius.circular(10)
              //         ),
              //
              //         child: Row(
              //           children: [
              //             Expanded(
              //               flex:4,
              //               child:Image.asset(
              //                 'images/Logo2.png',
              //                 fit: BoxFit.contain,
              //
              //               ),
              //             ),
              //             Expanded(
              //               flex:5,
              //               child: Padding(
              //                 padding: const EdgeInsets.only(left: 8.0),
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children: [
              //                     Spacer(),
              //
              //                     Flexible(
              //                       flex:2,
              //                       child: Text(
              //                         "Adhaar Details",
              //
              //                         style: TextStyle(
              //
              //                             fontWeight: FontWeight.w900,
              //                             fontSize: 23
              //                         ),
              //                       ),
              //                     ),
              //                     Spacer(),
              //
              //                     Flexible(
              //                       child: Text(
              //                         "Ayush Pratik",
              //
              //                         style: TextStyle(
              //                           fontSize: 18,
              //                           color: Colors.black,
              //
              //                         ),
              //                       ),
              //                     ),
              //                     SizedBox(height: 8,),
              //
              //
              //                     Flexible(
              //                       child: Text(
              //                         "929093105847",
              //
              //                         style: TextStyle(
              //                             fontSize: 15
              //                         ),
              //                       ),
              //                     ),
              //                     Spacer(),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                margin: EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 10),
                child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Vehicle(
                                    driver_id: widget.driver_id,
                                  )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "View driver's vehicle",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    color: Color(0XFF35B736)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Cab's Documents",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 23),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FitnessCertificate(
                                        driver_id: widget.driver_id,
                                      )));
                        },
                        leading: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                        title: Text(
                          "Fitness Certificate",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 23),
                        ),
                        trailing: Icon(
                          Icons.arrow_right,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Insurance(
                                        driver_id: widget.driver_id,
                                      )));
                        },
                        leading: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                        title: Text(
                          "Insurance",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 23),
                        ),
                        trailing: Icon(
                          Icons.arrow_right,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LeasePaper(
                                        driver_id: widget.driver_id,
                                      )));
                        },
                        leading: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                        title: Text(
                          "Lease Paper",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 23),
                        ),
                        trailing: Icon(
                          Icons.arrow_right,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PollutionCertificate(
                                        driver_id: widget.driver_id,
                                      )));
                        },
                        leading: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                        title: Text(
                          "Pollution Certificate",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 23),
                        ),
                        trailing: Icon(
                          Icons.arrow_right,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RoutePermit(
                                        driver_id: widget.driver_id,
                                      )));
                        },
                        leading: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                        title: Text(
                          "Route Permit",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 23),
                        ),
                        trailing: Icon(
                          Icons.arrow_right,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Driver's Documents",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 23),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddressDetails(
                                        driver_id: widget.driver_id,
                                      )));
                        },
                        leading: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                        title: Text(
                          "Address Details",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 23),
                        ),
                        trailing: Icon(
                          Icons.arrow_right,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdhaarDetails(
                                        driver_id: widget.driver_id,
                                      )));
                        },
                        leading: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                        title: Text(
                          "Adhaar Details",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 23),
                        ),
                        trailing: Icon(
                          Icons.arrow_right,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BankDetails(
                                        driver_id: widget.driver_id,
                                      )));
                        },
                        leading: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                        title: Text(
                          "Bank Details",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 23),
                        ),
                        trailing: Icon(
                          Icons.arrow_right,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DrivingLiscense(
                                        driver_id: widget.driver_id,
                                      )));
                        },
                        leading: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                        title: Text(
                          "Driving Liscense",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 23),
                        ),
                        trailing: Icon(
                          Icons.arrow_right,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PANDetails(
                                        driver_id: widget.driver_id,
                                      )));
                        },
                        leading: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                        title: Text(
                          "PAN Details",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 23),
                        ),
                        trailing: Icon(
                          Icons.arrow_right,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
