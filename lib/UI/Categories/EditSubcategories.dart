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

class EditSubcategories extends StatefulWidget {
  String category_id, name;

  EditSubcategories({required this.name, required this.category_id});

  @override
  _EditSubcategoriesState createState() => _EditSubcategoriesState();
}

class _EditSubcategoriesState extends State<EditSubcategories> {
  TextEditingController name = TextEditingController();
  TextEditingController rate = TextEditingController();
  TextEditingController seats = TextEditingController();
  List categoryList = [], driver = [];
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
      // print(_imageFile.path);
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
                    .child("Categories")
                    .orderByChild("category_id")
                    .equalTo(widget.category_id)
                    .onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  categoryList.clear();
                  DatabaseEvent? databaseEvent = snapshot.data as DatabaseEvent;
                  databaseEvent.snapshot.children.forEach((event) {
                    categoryList.add(event.value as Map);
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
                  if (categoryList.length != 0)
                    return ListView.builder(
                        itemCount: categoryList.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          String status =
                              categoryList[index]['status'] == "True"
                                  ? "Approved"
                                  : categoryList[index]['status'] == "False"
                                      ? "Disapproved"
                                      : categoryList[index]['status'];
                          Widget image = FutureBuilder(
                              future: imageurl(categoryList[index]['image']),
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
                                        //     child: MaterialButton(
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
                    .child("Categories")
                    .orderByChild("category_id")
                    .equalTo(widget.category_id)
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
                    name.text = driver[0]['name'] ?? "";
                    rate.text = driver[0]['rate'] ?? "";
                    seats.text = driver[0]['seats'] ?? "";

                    fileName = driver[0]['image'] ?? "";
                  }

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
                              "Category ID : " + driver[0]['category_id'],
                              style: new TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w900),
                            ),
                            SizedBox(
                              height: 15,
                            ),
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
                                  labelText: "Name",
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
                                controller: rate,
                                decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8),
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Rate",
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
                                controller: seats,
                                decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8),
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Seats",
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
                          ],
                        ),
                      ),
                    );
                  else
                    return Container();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      height: MediaQuery.of(context).size.height / 20,
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
                          showAnimatedDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return ClassicGeneralDialogWidget(
                                titleText: 'Delete',
                                contentText:
                                    "Are you sure you want to delete this category?",
                                negativeText: 'No',
                                onNegativeClick: () {
                                  Navigator.pop(context);
                                },
                                positiveText: "Delete",
                                onPositiveClick: () {
                                  Navigator.pop(context);
                                  delete(context);
                                },
                              );
                            },
                          );
                          // animated_dialog_box.showScaleAlertBox(
                          //   context: context,
                          //   title: Text("Delete"),
                          //   icon: Icon(Icons.delete_forever),
                          //   yourWidget: Text("Are you sure you want to delete this category?",
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
                          //
                          //       },
                          //       child:Text("No",
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
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.all(
                          //           Radius.circular(10),
                          //         ),
                          //       ),
                          //       onPressed: () {
                          //         Navigator.pop(context);
                          //         delete(context);
                          //
                          //
                          //       },
                          //       child:Text("Delete",
                          //         style: TextStyle(
                          //             color: Colors.white,
                          //
                          //             fontSize: 20
                          //         ),),
                          //       color: Colors.red,
                          //     ),
                          //   ),);
                        },
                        child: Text(
                          "Delete this category",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 20),
                        ),
                        color: Colors.red,
                      ),
                    )),
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
        .child("Categories")
        .orderByChild("category_id")
        .equalTo(widget.category_id)
        .once()
        .then((DatabaseEvent datasnapshot) {
      try {
        Map<dynamic, dynamic> values =
            datasnapshot.snapshot.children.first.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          if (value != null)
            firRef.child("Categories").child(key.toString()).update({
              "name": name.text,
              "rate": rate.text,
              "seats": seats.text,
              "image": fileName,
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
    // firRef.child("Categories").orderByChild("category_id").equalTo(widget.category_id).once().then((snapshot) {
    //   try
    //   {
    //     Map<dynamic,dynamic> values=snapshot.value;
    //     if(values!=null)
    //       values.forEach((key, value) {
    //         if(value!=null)
    //           firRef.child("Categories").child(key.toString()).update({
    //             "name":name.text,
    //             "rate":rate.text,
    //             "seats":seats.text,
    //             "image":fileName,
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

  void delete(BuildContext context) {
    firRef
        .child("Categories")
        .orderByChild("category_id")
        .equalTo(widget.category_id)
        .once()
        .then((DatabaseEvent datasnapshot) {
      try {
        Map<dynamic, dynamic> values =
            datasnapshot.snapshot.children.first.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          if (value != null)
            firRef.child("Categories").child(key.toString()).remove();
        });
      } catch (e) {
        print(e.toString());
      }
      Fluttertoast.showToast(msg: "Category Deleted");
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    });
    // firRef.child("Categories").orderByChild("category_id").equalTo(widget.category_id).once().then((snapshot) {
    //   try
    //   {
    //     Map<dynamic,dynamic> values=snapshot.value;
    //     if(values!=null)
    //       values.forEach((key, value) {
    //         if(value!=null)
    //           firRef.child("Categories").child(key.toString()).remove();
    //       });
    //   }
    //   catch(e)
    //   {
    //
    //   }
    //   Fluttertoast.showToast(msg: "Category Deleted");
    //   Timer(Duration(seconds: 2),(){
    //
    //     Navigator.pop(context);
    //   });
    //
    // });
  }
}
