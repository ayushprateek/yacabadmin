import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:yacabadmin/Components/Customs.dart';
import 'package:yacabadmin/Components/element_dialog_box.dart';

class Vehicle extends StatefulWidget {
  String driver_id;
  Vehicle({
    required this.driver_id
});
  @override
  _VehicleState createState() => _VehicleState();
}
class _VehicleState extends State<Vehicle> {
  TextEditingController reason=TextEditingController();
  TextEditingController brand=TextEditingController();
  TextEditingController model=TextEditingController();
  TextEditingController year=TextEditingController();
  TextEditingController license=TextEditingController();
  TextEditingController colour=TextEditingController();
  TextEditingController num_of_seats=TextEditingController();
  TextEditingController vehStatus=TextEditingController();
  String Status="Pending";
  List<String> status=['Pending','Disapproved','Approved'];
  bool update=false,isSet=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Driver's Vehicle",
            style: TextStyle(

                fontWeight: FontWeight.w900,
                fontSize: 23
            ),
          ),
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.black,size: 30,),
          )

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/8,right: MediaQuery.of(context).size.width/8),
          child: StreamBuilder(
            stream: firRef.child("Vehicles").orderByChild("driver_id").equalTo(widget.driver_id).onValue,
            builder: (context,snapshot){
              if(snapshot.hasData)
              {
                if(!isSet){
                  isSet=true;

                  DatabaseEvent? databaseEvent = snapshot.data as DatabaseEvent;
                  databaseEvent.snapshot.children.forEach((event) {
                    Map value=event.value as Map;
                    if(value!=null)
                    {
                      update=true;
                      brand.text=value['brand'];
                      model.text=value['model'];
                      year.text=value['year'];
                      license.text=value['license'];
                      colour.text=value['colour'];
                      num_of_seats.text=value['num_of_seats'];
                      vehStatus.text=value['status'];
                      Status=value['status'];
                      Status=="Disapproved"?reason.text=value['reason']:"";
                    }
                  });
                  // try
                  // {
                  //   Map<dynamic,dynamic> values=snapshot.data.snapshot.value;
                  //   if(values!=null)
                  //     values.forEach((key, value) {
                  //       if(value!=null)
                  //       {
                  //         update=true;
                  //         brand.text=value['brand'];
                  //         model.text=value['model'];
                  //         year.text=value['year'];
                  //         license.text=value['license'];
                  //         colour.text=value['colour'];
                  //         num_of_seats.text=value['num_of_seats'];
                  //         vehStatus.text=value['status'];
                  //         Status=value['status'];
                  //         Status=="Disapproved"?reason.text=value['reason']:null;
                  //
                  //       }
                  //     });
                  // }
                  // catch(e)
                  // {
                  //   List<dynamic> values=snapshot.data.snapshot.value;
                  //   if(values!=null)
                  //     values.forEach((value) {
                  //       if(value!=null)
                  //       {
                  //         update=true;
                  //         brand.text=value['brand'];
                  //         model.text=value['model'];
                  //         year.text=value['year'];
                  //         license.text=value['license'];
                  //         colour.text=value['colour'];
                  //         num_of_seats.text=value['num_of_seats'];
                  //         vehStatus.text=value['status'];
                  //         Status=value['status'];
                  //         Status=="Disapproved"?reason.text=value['reason']:null;
                  //       }
                  //     });
                  // }
                }

              }
              return Column(

                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("VEHICLE BRAND",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 20
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(

                    height: 35,
                    child: TextFormField(


                      controller: brand,
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.only(left: 15),
                        filled: true,

                        prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 15),
                        // Icon(Icons.phone_android, color: HexColor("#27ab87"),),
                        fillColor: Colors.white,
                        hoverColor: Colors.red,
                        //focusColor:HexColor("#27ab87"),
                        // isDense: true,
                        // fillColor: Colors.red,
                        focusedBorder: new OutlineInputBorder(

                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(
                              color: Colors.grey
                          ),
                        ) ,
                        //labelStyle: TextStyle(color: HexColor("#27ab87")),

                        border: new OutlineInputBorder(

                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(


                          ),
                        ),
                        //fillColor: Colors.green
                      ),

                      style: new TextStyle(
                          fontWeight: FontWeight.w900
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("MODEL",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 20
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(

                    height: 35,
                    child: TextFormField(


                      controller: model,
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.only(left: 15),
                        filled: true,

                        prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 15),
                        // Icon(Icons.phone_android, color: HexColor("#27ab87"),),
                        fillColor: Colors.white,
                        hoverColor: Colors.red,
                        //focusColor:HexColor("#27ab87"),
                        // isDense: true,
                        // fillColor: Colors.red,
                        focusedBorder: new OutlineInputBorder(

                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(
                              color: Colors.grey
                          ),
                        ) ,
                        //labelStyle: TextStyle(color: HexColor("#27ab87")),

                        border: new OutlineInputBorder(

                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(


                          ),
                        ),
                        //fillColor: Colors.green
                      ),

                      style: new TextStyle(
                          fontWeight: FontWeight.w900
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("YEAR",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 20
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(

                    height: 35,
                    child: TextFormField(


                      controller: year,
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.only(left: 15),
                        filled: true,

                        prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 15),
                        // Icon(Icons.phone_android, color: HexColor("#27ab87"),),
                        fillColor: Colors.white,
                        hoverColor: Colors.red,
                        //focusColor:HexColor("#27ab87"),
                        // isDense: true,
                        // fillColor: Colors.red,
                        focusedBorder: new OutlineInputBorder(

                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(
                              color: Colors.grey
                          ),
                        ) ,
                        //labelStyle: TextStyle(color: HexColor("#27ab87")),

                        border: new OutlineInputBorder(

                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(


                          ),
                        ),
                        //fillColor: Colors.green
                      ),
                      keyboardType: TextInputType.datetime,

                      style: new TextStyle(
                          fontWeight: FontWeight.w900
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("VEHICLE NUMBER",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 20
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(

                    height: 35,
                    child: TextFormField(


                      controller: license,
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.only(left: 15),
                        filled: true,

                        prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 15),
                        // Icon(Icons.phone_android, color: HexColor("#27ab87"),),
                        fillColor: Colors.white,
                        hoverColor: Colors.red,
                        //focusColor:HexColor("#27ab87"),
                        // isDense: true,
                        // fillColor: Colors.red,
                        focusedBorder: new OutlineInputBorder(

                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(
                              color: Colors.grey
                          ),
                        ) ,
                        //labelStyle: TextStyle(color: HexColor("#27ab87")),

                        border: new OutlineInputBorder(

                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(


                          ),
                        ),
                        //fillColor: Colors.green
                      ),

                      style: new TextStyle(
                          fontWeight: FontWeight.w900
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("COLOUR",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 20
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(

                    height: 35,
                    child: TextFormField(


                      controller: colour,
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.only(left: 15),
                        filled: true,

                        prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 15),
                        // Icon(Icons.phone_android, color: HexColor("#27ab87"),),
                        fillColor: Colors.white,
                        hoverColor: Colors.red,
                        //focusColor:HexColor("#27ab87"),
                        // isDense: true,
                        // fillColor: Colors.red,
                        focusedBorder: new OutlineInputBorder(

                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(
                              color: Colors.grey
                          ),
                        ) ,
                        //labelStyle: TextStyle(color: HexColor("#27ab87")),

                        border: new OutlineInputBorder(

                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(


                          ),
                        ),
                        //fillColor: Colors.green
                      ),

                      style: new TextStyle(
                          fontWeight: FontWeight.w900
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("NUMBER OF SEATS",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 20
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(

                    height: 35,
                    child: TextFormField(


                      controller: num_of_seats,
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.only(left: 15),
                        filled: true,

                        prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 15),
                        // Icon(Icons.phone_android, color: HexColor("#27ab87"),),
                        fillColor: Colors.white,
                        hoverColor: Colors.red,
                        //focusColor:HexColor("#27ab87"),
                        // isDense: true,
                        // fillColor: Colors.red,
                        focusedBorder: new OutlineInputBorder(

                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(
                              color: Colors.grey
                          ),
                        ) ,
                        //labelStyle: TextStyle(color: HexColor("#27ab87")),

                        border: new OutlineInputBorder(

                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(


                          ),
                        ),

                        //fillColor: Colors.green
                      ),
                      keyboardType: TextInputType.number,


                      style: new TextStyle(
                          fontWeight: FontWeight.w900
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text("Status :",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 20
                          ),
                        ),
                        SizedBox(width: 10,),
                        DropdownButton<String>(
                          items: status.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),

                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {

                              Status=val??"";
                              if(Status==status[1])
                              {
                                showRejectionDialog(context: context,
                                    onRejection: (){
                                      if(reason.text.isEmpty)
                                        Fluttertoast.showToast(msg: "Please tell the reason of rejection");
                                      else
                                      {
                                        Navigator.pop(context);
                                      }
                                    },
                                    onCancel: (){
                                      if(reason.text.isEmpty)
                                      {
                                        Status=vehStatus.text;
                                      }
                                      Navigator.pop(context);
                                    }, controller: reason).then((value){
                                  setState(() {

                                  });
                                });
                                // animated_dialog_box.showScaleAlertBox(
                                //   context: context,
                                //   title: Text("Reason of Rejection"),
                                //   icon: Icon(Icons.cancel_outlined),
                                //   yourWidget:  Container(
                                //
                                //     width: MediaQuery.of(context).size.width/1.5,
                                //     child: TextFormField(
                                //       controller: reason,
                                //
                                //       decoration: new InputDecoration(
                                //
                                //         filled: true,
                                //
                                //         fillColor: Colors.white,
                                //         hoverColor: Colors.red,
                                //
                                //         labelText: "Reason",
                                //
                                //         // fillColor: Colors.red,
                                //         focusedBorder: new OutlineInputBorder(
                                //           borderRadius: new BorderRadius.circular(0.0),
                                //           borderSide: new BorderSide(
                                //               color: Colors.grey
                                //           ),
                                //         ) ,
                                //         //labelStyle: TextStyle(color: HexColor("#27ab87")),
                                //
                                //         border: new OutlineInputBorder(
                                //
                                //           borderRadius: new BorderRadius.circular(0.0),
                                //           borderSide: new BorderSide(
                                //
                                //
                                //           ),
                                //         ),
                                //         //fillColor: Colors.green
                                //       ),
                                //
                                //       style: new TextStyle(
                                //           fontSize: 20,
                                //           fontWeight: FontWeight.w900
                                //       ),
                                //     ),
                                //   ),
                                //   firstButton:  Container(
                                //     decoration: BoxDecoration(
                                //
                                //         borderRadius: BorderRadius.all(Radius.circular(10))),
                                //
                                //     child: MaterialButton(
                                //
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.all(
                                //           Radius.circular(10),
                                //         ),
                                //       ),
                                //       onPressed: () {
                                //         if(reason.text.isEmpty)
                                //         {
                                //           Status=vehStatus.text;
                                //         }
                                //         Navigator.pop(context);
                                //
                                //
                                //       },
                                //       child:Text("Cancel",
                                //         style: TextStyle(
                                //             color: Colors.black,
                                //             fontSize: 20
                                //         ),),
                                //       color: Theme.of(context).buttonColor,
                                //     ),
                                //   ),
                                //   secondButton: Container(
                                //
                                //
                                //     decoration: BoxDecoration(
                                //
                                //         borderRadius: BorderRadius.all(Radius.circular(10))),
                                //
                                //     child: MaterialButton(
                                //
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.all(
                                //           Radius.circular(10),
                                //         ),
                                //       ),
                                //       onPressed: () {
                                //         if(reason.text.isEmpty)
                                //           Fluttertoast.showToast(msg: "Please tell the reason of rejection");
                                //         else
                                //         {
                                //           Navigator.pop(context);
                                //         }
                                //
                                //       },
                                //       child:Text("Reject",
                                //         style: TextStyle(
                                //             color: Colors.black,
                                //
                                //             fontSize: 20
                                //         ),),
                                //       color: Theme.of(context).buttonColor,
                                //     ),
                                //   ),).then((value) {
                                //   setState(() {
                                //
                                //   });
                                // });
                              }
                            });
                          },
                          value: Status,
                        ),
                      ],
                    ),
                  ),
                  Status=="Disapproved"?Align(
                    alignment: Alignment.centerLeft,
                      child: Text("Reason of Disapproval : "+reason.text,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 20
                        ),)):Container(),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: MediaQuery.of(context).size.height/15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    margin: EdgeInsets.only(
                        left: 8, top: 8, right: 8, bottom: 10),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if(brand.text==null||brand.text=="")
                        {
                          Fluttertoast.showToast(msg: "Brand cannot be empty");
                        }
                        else if(model.text==null||model.text=="")
                        {
                          Fluttertoast.showToast(msg: "Model cannot be empty");
                        }
                        else if(year.text==null||year.text=="")
                        {
                          Fluttertoast.showToast(msg: "Year cannot be empty");
                        }
                        else if(license.text==null||license.text=="")
                        {
                          Fluttertoast.showToast(msg: "Vehicle number cannot be empty");
                        }
                        else if(colour.text==null||brand.text=="")
                        {
                          Fluttertoast.showToast(msg: "Brand cannot be empty");
                        }
                        else if(num_of_seats.text==null||num_of_seats.text=="")
                        {
                          Fluttertoast.showToast(msg: "Number of Seats cannot be empty");
                        }
                        else
                        {
                          if(update)
                            {
                              updateVehicle(context);
                            }
                          else
                          addVehicle(context);
                        }

                      },
                      child:Text("Save",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 20
                        ),),
                      color: Colors.white,
                    ),
                  ),
                ],
              );

            },
          ),
        ),
      ),
    );
  }
  void addVehicle(BuildContext context)
  {
    firRef.child("Vehicles")
        .limitToLast(1)
        .once()
        .then((DatabaseEvent datasnapshot) {
      try {
        int newKey = int.parse(datasnapshot.snapshot.children.first.key.toString()) + 1;
        int id=newKey+1;
        String vehicle_id=id.toString();
        firRef.child("Vehicles").child(newKey.toString()).set({
          "vehicle_id":vehicle_id.toString(),
          "driver_id":widget.driver_id,
          "date_added":DateTime.now().toIso8601String(),
          "brand":brand.text.toString(),
          "model":model.text.toString(),
          "year":year.text.toString(),
          "license":license.text.toString(),
          "colour":colour.text.toString(),
          "num_of_seats":num_of_seats.text.toString(),
          "status":Status,
          "reason":Status=="Disapproved"?reason.text:null,

        });
      } catch (e) {
        print(e.toString());
      }
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
  void updateVehicle(BuildContext context) async {

    //todo: check limitToLast logic
    firRef.child("Vehicles").orderByChild("driver_id").equalTo(widget.driver_id).limitToLast(1).once().then((DatabaseEvent datasnapshot) {
      try {
        Map<dynamic, dynamic> values = datasnapshot.snapshot.children.first.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          firRef.child("Vehicles").child(key.toString()).update({
            "brand":brand.text.toString(),
            "model":model.text.toString(),
            "year":year.text.toString(),
            "license":license.text.toString(),
            "colour":colour.text.toString(),
            "num_of_seats":num_of_seats.text.toString(),
            "status":Status,
            "reason":Status=="Disapproved"?reason.text:null,


          });
        });

      } catch (e) {
        print(e.toString());
      }
      Fluttertoast.showToast(msg: "Driver Assigned");
      Timer(Duration(seconds: 1),(){
        Navigator.pop(context);
      });
    });

    // try {
    //   firRef.child("Vehicles").orderByChild("driver_id").equalTo(widget.driver_id).limitToLast(1).once().then(
    //           (DataSnapshot datasnapshot){
    //         Map<dynamic,dynamic> values= datasnapshot.value;
    //         if(values!=null)
    //           values.forEach((key,value){
    //             firRef.child("Vehicles").child(key.toString()).update({
    //               "brand":brand.text.toString(),
    //               "model":model.text.toString(),
    //               "year":year.text.toString(),
    //               "license":license.text.toString(),
    //               "colour":colour.text.toString(),
    //               "num_of_seats":num_of_seats.text.toString(),
    //               "status":Status,
    //               "reason":Status=="Disapproved"?reason.text:null,
    //
    //
    //             });
    //
    //           });
    //         Navigator.pop(context);
    //       }
    //   );
    // } catch (e) {
    //   print(e.toString());
    // }
  }
}
