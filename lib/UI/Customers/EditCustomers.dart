import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:yacabadmin/Components/Customs.dart';
import 'package:yacabadmin/Components/GetImageURL.dart';

class EditCustomer extends StatefulWidget {
  String customer_id,name;
  EditCustomer({
    required this.customer_id,
    required this.name
});
  @override
  _EditCustomerState createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  TextEditingController name=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController mobile=TextEditingController();
  TextEditingController reason=TextEditingController();
  String Status="Active";
  List<String> status=['Active','Inactive'];
  List customer=[];
  bool hasUploaded=false,isSet=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black,size: 30,),
        ),
        title: Text(widget.name==null?"Customer's Account":widget.name,
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 50,),
              StreamBuilder(
                stream: firRef.child("Customers").orderByChild("customer_id").equalTo(widget.customer_id).onValue,
                builder: (context,snapshot){
                  if(!snapshot.hasData)
                    return Container();
                  customer.clear();
                  DatabaseEvent? databaseEvent = snapshot.data as DatabaseEvent;
                  databaseEvent.snapshot.children.forEach((event) {
                    customer.add(event.value as Map);
                  });
                  // try{
                  //   List<dynamic> values=snapshot.data.snapshot.value;
                  //   if(values!=null)
                  //     values.forEach((value) {
                  //       if(value!=null)
                  //         customer.add(value);
                  //     });
                  // }
                  // catch(e)
                  // {
                  //   Map<dynamic,dynamic> values=snapshot.data.snapshot.value;
                  //   if(values!=null)
                  //     values.forEach((key,value) {
                  //       if(value!=null)
                  //         customer.add(value);
                  //     });
                  // }
                  if(!isSet)
                  {
                    isSet=true;
                    name.text=customer[0]['name'];
                    email.text=customer[0]['email'];
                    mobile.text=customer[0]['mobile'];
                    Status=customer[0]['status']=="True"?"Active":"Inactive";

                  }
                  var date=DateTime.parse(customer[0]['date_added']);

                  if(customer.length!=0)
                    return Container(
                      decoration: BoxDecoration(
                          border:Border.all()
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15,),
                            Text("Customer ID : "+customer[0]['customer_id'],
                              style: new TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900
                              ),),
                            SizedBox(height: 15,),
                            Text("Registration Time : "
                                +date.hour.toString()+":"
                                +date.minute.toString()+" "
                                +date.day.toString()+"/"
                                +date.month.toString()+"/"
                                +date.year.toString()
                              ,
                              style: new TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900
                              ),),
                            SizedBox(height: 15,),
                            Container(
                              child: TextFormField(
                                onTap: (){

                                },
                                controller: name,

                                decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8),
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Customer Name",
                                  labelStyle: TextStyle(
                                      color: Colors.black
                                  ),
                                  focusedBorder: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(0.0),
                                    borderSide: new BorderSide(
                                        color: Colors.grey
                                    ),
                                  ) ,
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(0.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  //fillColor: Colors.green
                                ),
                                style: new TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900
                                ),
                              ),
                            ),
                            SizedBox(height: 15,),
                            Container(
                              child: TextFormField(
                                onTap: (){

                                },
                                controller: mobile,

                                decoration: new InputDecoration(

                                  contentPadding: EdgeInsets.only(left: 8),
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Customer Mobile",
                                  labelStyle: TextStyle(
                                      color: Colors.black
                                  ),
                                  focusedBorder: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(0.0),
                                    borderSide: new BorderSide(
                                        color: Colors.grey
                                    ),
                                  ) ,
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(0.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  //fillColor: Colors.green
                                ),
                                keyboardType: TextInputType.number,
                                style: new TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900
                                ),
                              ),
                            ),
                            SizedBox(height: 15,),
                            Container(
                              child: TextFormField(
                                onTap: (){

                                },
                                controller: email,

                                decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8),
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Customer Email",
                                  labelStyle: TextStyle(
                                      color: Colors.black
                                  ),
                                  focusedBorder: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(0.0),
                                    borderSide: new BorderSide(
                                        color: Colors.grey
                                    ),
                                  ) ,
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(0.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  //fillColor: Colors.green
                                ),
                                keyboardType: TextInputType.emailAddress,
                                style: new TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900
                                ),
                              ),
                            ),
                            SizedBox(height: 15,),
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
                                  SizedBox(width: 20,),
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
                                          //todo: Animated box here
                                          // showAnimatedDialog(
                                          //   context: context,
                                          //   barrierDismissible: true,
                                          //   builder: (BuildContext context) {
                                          //     return ClassicGeneralDialogWidget(
                                          //       titleText: 'Reason of Rejection',
                                          //       contentText: "Are you sure you want to delete this category?",
                                          //       negativeText: 'No',
                                          //       onNegativeClick: () {
                                          //         Navigator.pop(context);
                                          //
                                          //       },
                                          //       positiveText: "Delete",
                                          //       onPositiveClick: () {
                                          //         Navigator.pop(context);
                                          //         delete(context);
                                          //       },
                                          //     );
                                          //   },
                                          // );
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
                                          //           Status=customer[0]['status']=="True"?"Active":"Inactive";
                                          //         }
                                          //         Navigator.pop(context);
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
                          ],
                        ),
                      ),
                    );
                  else
                    return Container();
                },
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: (){
          // update(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                // backgroundColor: Colors.transparent,
                content: Container(
                  height: MediaQuery.of(context).size.height/20,
                  width: MediaQuery.of(context).size.width/1.5,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

              );
            },
          );
          update(context);

        },
        child: Icon(Icons.save,color: Theme.of(context).buttonColor,),
      ),

    );
  }
  void update(BuildContext context){
    firRef.child("Customers").orderByChild("customer_id").equalTo(widget.customer_id).once().then((DatabaseEvent datasnapshot) {
      try {
        Map<dynamic, dynamic> values = datasnapshot.snapshot.children.first.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          if(value!=null)
            firRef.child("Bookings").child(key.toString()).update({
              "name":name.text,
              "email":email.text,
              "mobile":mobile.text,
              "status":Status=="Active"?"True":"False",
              "reason":Status!="Active"?reason.text:null,
            });
        });

      } catch (e) {
        print(e.toString());
      }
      Fluttertoast.showToast(msg: "Data Updated");
      Timer(Duration(seconds: 2),(){
        Navigator.pop(context);
        Navigator.pop(context);
      });
    });
    // firRef.child("Customers").orderByChild("customer_id").equalTo(widget.customer_id).once().then((snapshot) {
    //   try
    //   {
    //     Map<dynamic,dynamic> values=snapshot.value;
    //     if(values!=null)
    //       values.forEach((key, value) {
    //         if(value!=null)
    //           firRef.child("Customers").child(key.toString()).update({
    //             "name":name.text,
    //             "email":email.text,
    //             "mobile":mobile.text,
    //             "status":Status=="Active"?"True":"False",
    //             "reason":Status!="Active"?reason.text:null,
    //
    //           });
    //       });
    //   }
    //   catch(e)
    //   {
    //
    //   }
    //   Fluttertoast.showToast(msg: "Data Updated");
    //   Timer(Duration(seconds: 2),(){
    //     Navigator.pop(context);
    //     Navigator.pop(context);
    //   });
    //
    // });
  }
}
