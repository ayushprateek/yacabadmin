import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:yacabadmin/Components/Customs.dart';
import 'package:yacabadmin/Services/CustomLaunchURL.dart';
import 'package:yacabadmin/UI/Admin/AssignDriver.dart';
import 'package:yacabadmin/UI/Admin/Booking.dart';

class EmptyRequest extends StatefulWidget {
  @override
  _EmptyRequestState createState() => _EmptyRequestState();
}

class _EmptyRequestState extends State<EmptyRequest> {
  List leads = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Empty Request",
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
              StreamBuilder(
                stream: firRef
                    .child("Bookings")
                    .orderByChild("status")
                    .equalTo("Pending")
                    .onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  leads.clear();
                  DatabaseEvent? databaseEvent = snapshot.data as DatabaseEvent;
                  databaseEvent.snapshot.children.forEach((event) {
                    Map value = event.value as Map;
                    if (value != null && value['driver_id'] == null)
                      leads.add(value);
                  });
                  // try{
                  //   Map<dynamic,dynamic> values=snapshot.data.snapshot.value;
                  //   if(values!=null)
                  //     values.forEach((key, value) {
                  //       if(value!=null && value['driver_id']==null)
                  //         leads.add(value);
                  //     });
                  // }
                  // catch(e)
                  // {
                  //   List<dynamic> values=snapshot.data.snapshot.value;
                  //   if(values!=null)
                  //     values.forEach(( value) {
                  //       if(value!=null && value['driver_id']==null)
                  //         leads.add(value);
                  //     });
                  // }
                  return ListView.builder(
                      itemCount: leads.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "BOOKING ID : ${leads[index]['booking_id']}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Booking(
                                                        booking_id: leads[index]
                                                            ['booking_id'],
                                                        date: leads[index]
                                                            ['date_added'],
                                                      )));
                                        },
                                        icon: Icon(
                                          Icons.arrow_forward,
                                          size: 35,
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "PICKUP",
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
                                  leads[index]['from_location'],
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
                                  "DROP OFF",
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
                                  leads[index]['to_location'],
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
                                  "BOOKED BY",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      leads[index]['customer_name'],
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        customLaunchURL("tel:+91" +
                                            leads[index]['customer_mobile']);
                                      },
                                      child: Text(
                                        leads[index]['customer_mobile'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0XFF4CD864)),
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    margin: EdgeInsets.only(
                                        left: 8, top: 8, right: 8, bottom: 10),
                                    child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new AssignDriver(
                                                        booking_id: leads[index]
                                                            ['booking_id'],
                                                      )));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Assign Driver",
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
                          ),
                        );
                      });
                },
              ),
              // Container(
              //   decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(10)
              //   ),
              //   child: Padding(
              //     padding:  EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         SizedBox(
              //           height: 10,
              //         ),
              //         Row(
              //           children: [
              //             Text("BOOKING ID : YA21231",
              //               style: TextStyle(
              //                 fontSize: 20,
              //                 fontWeight: FontWeight.w900,
              //               ),),
              //             Spacer(),
              //             IconButton(
              //               onPressed: (){
              //                 Navigator.push(context, MaterialPageRoute(builder: (context)=>Booking()));
              //               },
              //                 icon: Icon(Icons.arrow_forward,size: 35,)),
              //           ],
              //         ),
              //         SizedBox(
              //           height: 10,
              //         ),
              //         Text("PICKUP",
              //           style: TextStyle(
              //             fontSize: 20,
              //             color: Colors.grey,
              //             fontWeight: FontWeight.w500,
              //
              //           ),),
              //         SizedBox(
              //           height: 8,
              //         ),
              //         Text("Ashapur, Sarnath, Varanasi ",
              //           style: TextStyle(
              //             fontSize: 19,
              //
              //             fontWeight: FontWeight.w500,
              //
              //           ),),
              //         SizedBox(
              //           height: 8,
              //         ),
              //         Divider(thickness: 1,color: Colors.grey,),
              //         SizedBox(
              //           height: 8,
              //         ),
              //         Text("DROP OFF",
              //           style: TextStyle(
              //             fontSize: 20,
              //             color: Colors.grey,
              //             fontWeight: FontWeight.w500,
              //
              //           ),),
              //         SizedBox(
              //           height: 8,
              //         ),
              //         Text("Paharia Mandi, Varanasi ",
              //           style: TextStyle(
              //             fontSize: 19,
              //
              //             fontWeight: FontWeight.w500,
              //
              //           ),),
              //         SizedBox(
              //           height: 8,
              //         ),
              //         Divider(thickness: 1,color: Colors.grey,),
              //         SizedBox(
              //           height: 8,
              //         ),
              //         Text("BOOKED BY",
              //           style: TextStyle(
              //             fontSize: 20,
              //             color: Colors.grey,
              //             fontWeight: FontWeight.w500,
              //
              //           ),),
              //         SizedBox(
              //           height: 8,
              //         ),
              //         Row(
              //           children: [
              //             Text("Ayush Pratik ",
              //               style: TextStyle(
              //                 fontSize: 19,
              //                 fontWeight: FontWeight.w500,
              //
              //               ),),
              //             Spacer(),
              //             InkWell(
              //               onTap: (){
              //                 customLaunchURL("tel:+916386106277");
              //               },child: Text("6386106277",
              //               style: TextStyle(
              //                   fontSize: 20,
              //                   color: Color(0XFF4CD864")
              //               ),),),
              //             Spacer(),
              //           ],
              //         ),
              //         SizedBox(
              //           height: 8,
              //         ),
              //         Align(
              //           alignment: Alignment.centerRight,
              //           child: Container(
              //
              //             decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.all(Radius.circular(5))),
              //             margin: EdgeInsets.only(
              //                 left: 8, top: 8, right: 8, bottom: 10),
              //             child: MaterialButton(
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.all(
              //                     Radius.circular(5),
              //                   ),
              //                 ),
              //                 onPressed: () {
              //                   Navigator.push(context, new MaterialPageRoute(builder: (context) => new AssignDriver()));
              //                 },
              //                 child:Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: Text("Assign Driver",
              //                     style: TextStyle(
              //                         color: Colors.white,
              //
              //                         fontSize: 20
              //                     ),),
              //                 ),
              //                 color: Color(0XFF35B736")
              //             ),
              //           ),
              //         ),
              //
              //
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
