import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:yacabadmin/Components/Customs.dart';
import 'package:yacabadmin/Components/GetImageURL.dart';
import 'package:yacabadmin/Components/element_dialog_box.dart';

class EditDriver extends StatefulWidget {
  String driver_id, name;

  EditDriver({required this.name, required this.driver_id});

  @override
  _EditDriverState createState() => _EditDriverState();
}

class _EditDriverState extends State<EditDriver> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController reason = TextEditingController();
  String Status = "Pending";
  List<String> status = ['Pending', 'Disapproved', 'Approved'];
  List driverImage = [], driver = [];
  File? _imageFile;
  String? fileName;
  bool hasUploaded = false, isSet = false;
  final picker = ImagePicker();

  Future pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null)
      setState(() {
        _imageFile = File(pickedFile.path);
      });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    if (_imageFile == null) {
      update(context);
    } else {
      fileName = basename(_imageFile?.path ?? "");
      print("fileName");
      print(_imageFile?.path ?? "");
      print(fileName);
      fileName = 'Drivers/$fileName';
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName ?? "");

      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile!);
      await uploadTask.then((p0) {
        p0.ref.getDownloadURL().then((value) {
          print(value);
        });
      });
      update(context);
      Fluttertoast.showToast(
          msg: "Image Uploaded",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      setState(() {
        _imageFile = null;
      });
    }
  }

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
                  driverImage.clear();
                  DatabaseEvent? databaseEvent = snapshot.data as DatabaseEvent;
                  databaseEvent.snapshot.children.forEach((event) {
                    driverImage.add(event.value as Map);
                  });
                  // try{
                  //   List<dynamic> values=snapshot.data.snapshot.value;
                  //   if(values!=null)
                  //     values.forEach((value) {
                  //       if(value!=null)
                  //         driverImage.add(value);
                  //     });
                  // }
                  // catch(e)
                  // {
                  //   Map<dynamic,dynamic> values=snapshot.data.snapshot.value;
                  //   if(values!=null)
                  //     values.forEach((key,value) {
                  //       if(value!=null)
                  //         driverImage.add(value);
                  //     });
                  // }
                  if (driverImage.length != 0)
                    return ListView.builder(
                        itemCount: driverImage.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          String status = driverImage[index]['status'] == "True"
                              ? "Approved"
                              : driverImage[index]['status'] == "False"
                                  ? "Disapproved"
                                  : driverImage[index]['status'];
                          Widget image = FutureBuilder(
                              future: imageurl(driverImage[index]['image']),
                              builder: (context, AsyncSnapshot<Url> snap) {
                                if (!snapshot.hasData)
                                  return Image.asset(
                                    'images/Logo2.png',
                                    fit: BoxFit.cover,
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    width: MediaQuery.of(context).size.width,
                                  );
                                try {
                                  return Image.network(
                                    snap.data?.image,
                                    fit: BoxFit.cover,
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    width: MediaQuery.of(context).size.width,
                                  );
                                } catch (e) {
                                  return Image.asset(
                                    'images/Logo2.png',
                                    fit: BoxFit.cover,
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    width: MediaQuery.of(context).size.width,
                                  );
                                }
                              });
                          return Stack(
                            children: [
                              _imageFile == null
                                  ? image
                                  : Image.file(_imageFile!),
                              Positioned(
                                  right: 10,
                                  top: 10,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black87,
                                              offset: Offset(-2, 3))
                                        ]),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: buttonColor,
                                      ),
                                      onPressed: () {
                                        showAnimatedDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return ClassicGeneralDialogWidget(
                                              titleText: 'Upload Image',
                                              contentText:
                                                  "How do you want to upload?",
                                              negativeText: 'Camera',
                                              onNegativeClick: () {
                                                Navigator.pop(context);
                                                pickImage(ImageSource.camera);
                                              },
                                              positiveText: "Gallery",
                                              onPositiveClick: () {
                                                Navigator.pop(context);
                                                pickImage(ImageSource.gallery);
                                              },
                                            );
                                          },
                                        );
                                        // animated_dialog_box.showScaleAlertBox(
                                        //   context: context,
                                        //   title: Text("Upload Image"),
                                        //   icon: Icon(Icons.upload_rounded),
                                        //   yourWidget: Text("How do you want to upload?",
                                        //     textAlign: TextAlign.center,
                                        //     style: TextStyle(
                                        //         color: Colors.black,
                                        //         fontWeight: FontWeight.w600,
                                        //
                                        //         fontSize: 20
                                        //     ),),
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
                                        //         Navigator.pop(context);
                                        //         pickImage(ImageSource.camera);
                                        //       },
                                        //       child:Text("Camera",
                                        //         style: TextStyle(
                                        //             color: Colors.black,
                                        //             fontSize: 20
                                        //         ),),
                                        //       color: buttonColor,
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
                                        //         Navigator.pop(context);
                                        //         pickImage(ImageSource.gallery);
                                        //
                                        //       },
                                        //       child:Text("Gallery",
                                        //         style: TextStyle(
                                        //             color: Colors.black,
                                        //
                                        //             fontSize: 20
                                        //         ),),
                                        //       color: buttonColor,
                                        //     ),
                                        //   ),);
                                      },
                                    ),
                                  )),
                            ],
                          );
                        });
                  else
                    return Container();
                },
              ),
              SizedBox(
                height: 20,
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
                  if (!isSet) {
                    isSet = true;
                    name.text = driver[0]['name'];
                    email.text = driver[0]['email'];
                    mobile.text = driver[0]['mobile'];
                    fileName = driver[0]['image'];
                    Status = driver[0]['status'];
                  }
                  var date = DateTime.parse(driver[0]['date_added']);

                  if (driver.length != 0)
                    return Container(
                      decoration: BoxDecoration(border: Border.all()),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Driver ID : " + driver[0]['driver_id'],
                              style: new TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w900),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Registration Time : " +
                                  date.hour.toString() +
                                  ":" +
                                  date.minute.toString() +
                                  " " +
                                  date.day.toString() +
                                  "/" +
                                  date.month.toString() +
                                  "/" +
                                  date.year.toString(),
                              style: new TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w900),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    "Status :",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  DropdownButton<String>(
                                    items: status.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        Status = val ?? "";
                                        if (Status == status[1]) {
                                          showRejectionDialog(
                                                  context: context,
                                                  onRejection: () {
                                                    if (reason.text.isEmpty)
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Please tell the reason of rejection");
                                                    else {
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  onCancel: () {
                                                    if (reason.text.isEmpty) {
                                                      Status =
                                                          driver[0]['status'];
                                                    }
                                                    Navigator.pop(context);
                                                  },
                                                  controller: reason)
                                              .then((value) {
                                            setState(() {});
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
                                          //         //labelStyle: TextStyle(color: Color(0XFF27ab87")),
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
                                          //           Status=driver[0]['status'];
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
                                          //       color: buttonColor,
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
                                          //       color: buttonColor,
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
                            SizedBox(
                              height: 10,
                            ),
                            driver[0]['status'].toString().toUpperCase() ==
                                        "DISAPPROVED" &&
                                    driver[0]['reason'] != null
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "Reason of disapproval :",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 20),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            driver[0]['reason']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              child: TextFormField(
                                onTap: () {},
                                controller: name,
                                decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8),
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Driver Name",
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(0.0),
                                    borderSide:
                                        new BorderSide(color: Colors.grey),
                                  ),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(0.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  //fillColor: Colors.green
                                ),
                                style: new TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w900),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              child: TextFormField(
                                onTap: () {},
                                controller: mobile,
                                decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8),
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Driver Mobile",
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(0.0),
                                    borderSide:
                                        new BorderSide(color: Colors.grey),
                                  ),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(0.0),
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
                              height: 15,
                            ),
                            Container(
                              child: TextFormField(
                                onTap: () {},
                                controller: email,
                                decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8),
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Driver Email",
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(0.0),
                                    borderSide:
                                        new BorderSide(color: Colors.grey),
                                  ),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(0.0),
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
                              height: 15,
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
        onPressed: () {
          // update(context);
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
          uploadImageToFirebase(context);
        },
        child: Icon(
          Icons.save,
          color: buttonColor,
        ),
      ),
    );
  }

  void update(BuildContext context) {
    firRef
        .child("Drivers")
        .orderByChild("driver_id")
        .equalTo(widget.driver_id)
        .once()
        .then((DatabaseEvent datasnapshot) {
      try {
        Map<dynamic, dynamic> values =
            datasnapshot.snapshot.children.first.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          if (value != null)
            firRef.child("Drivers").child(key.toString()).update({
              "name": name.text,
              "email": email.text,
              "mobile": mobile.text,
              "image": fileName,
              "status": Status,
              "reason": Status == "Disapproved" ? reason.text : null
            });
        });
      } catch (e) {
        print(e.toString());
      }
      Fluttertoast.showToast(msg: "Data Updated");
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    });
    // firRef.child("Drivers").orderByChild("driver_id").equalTo(widget.driver_id).once().then((snapshot) {
    //   try
    //       {
    //         Map<dynamic,dynamic> values=snapshot.value;
    //         if(values!=null)
    //           values.forEach((key, value) {
    //             if(value!=null)
    //               firRef.child("Drivers").child(key.toString()).update({
    //                 "name":name.text,
    //                 "email":email.text,
    //                 "mobile":mobile.text,
    //                 "image":fileName,
    //                 "status":Status,
    //                 "reason":Status=="Disapproved"?reason.text:null
    //               });
    //           });
    //       }
    //       catch(e)
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
