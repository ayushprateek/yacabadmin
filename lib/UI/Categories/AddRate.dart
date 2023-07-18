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
import 'package:yacabadmin/Components/isNumeric.dart';

enum Status { enabled, disabled }

enum Fixed { fixedPrice, variablePrice }

class AddRates extends StatefulWidget {
  String parent_id;

  AddRates({required this.parent_id});

  @override
  State<AddRates> createState() => _AddRatesState();
}

class _AddRatesState extends State<AddRates> {
  TextEditingController fromDistance = TextEditingController();
  TextEditingController toDistance = TextEditingController();
  TextEditingController fromTime = TextEditingController();
  TextEditingController toTime = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController rate = TextEditingController();
  TextEditingController seats = TextEditingController();
  Status status = Status.enabled;
  Fixed fixed = Fixed.fixedPrice;
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
      add(context);
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
      add(context);
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
          "Add",
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
              Stack(
                children: [
                  _imageFile == null
                      ? Icon(
                          Icons.camera_alt,
                          size: MediaQuery.of(context).size.width / 2,
                        )
                      : Image.file(_imageFile!),
                  Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black87, offset: Offset(-2, 3))
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
                                  contentText: 'How do you want to upload?',
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
                            //   yourWidget: Text(
                            //     "How do you want to upload?",
                            //     textAlign: TextAlign.center,
                            //     style: TextStyle(
                            //         color: Colors.black,
                            //         fontWeight: FontWeight.w600,
                            //         fontSize: 20),
                            //   ),
                            //   firstButton: Container(
                            //     decoration: BoxDecoration(
                            //         borderRadius:
                            //             BorderRadius.all(Radius.circular(10))),
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
                            //       child: Text(
                            //         "Camera",
                            //         style: TextStyle(
                            //             color: Colors.black, fontSize: 20),
                            //       ),
                            //       color: buttonColor,
                            //     ),
                            //   ),
                            //   secondButton: Container(
                            //     decoration: BoxDecoration(
                            //         borderRadius:
                            //             BorderRadius.all(Radius.circular(10))),
                            //     child: MaterialButton(
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.all(
                            //           Radius.circular(10),
                            //         ),
                            //       ),
                            //       onPressed: () {
                            //         Navigator.pop(context);
                            //         pickImage(ImageSource.gallery);
                            //       },
                            //       child: Text(
                            //         "Gallery",
                            //         style: TextStyle(
                            //             color: Colors.black, fontSize: 20),
                            //       ),
                            //       color: buttonColor,
                            //     ),
                            //   ),
                            // );
                          },
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
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
                        "Perent ID : " + widget.parent_id,
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
                        height: 15,
                      ),
                      Container(
                        child: TextFormField(
                          onTap: () {},
                          controller: fromDistance,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "From Distance",
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
                        height: 15,
                      ),
                      Container(
                        child: TextFormField(
                          onTap: () {},
                          controller: toDistance,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "To Distance",
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
                        height: 15,
                      ),
                      Container(
                        child: TextFormField(
                          onTap: () {},
                          controller: fromTime,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "From Time",
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
                        height: 15,
                      ),
                      Container(
                        child: TextFormField(
                          onTap: () {},
                          controller: toTime,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "To Time",
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
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    fixed = Fixed.fixedPrice;
                  });
                },
                child: Row(
                  children: [
                    Radio(
                      activeColor: Colors.black,
                      value: Fixed.fixedPrice,
                      groupValue: fixed,
                      onChanged: (value) {},
                    ),
                    Text('Fixed Price')
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    fixed = Fixed.variablePrice;
                  });
                },
                child: Row(
                  children: [
                    Radio(
                      activeColor: Colors.black,
                      value: Fixed.variablePrice,
                      groupValue: fixed,
                      onChanged: (value) {},
                    ),
                    Text('Calculate Rate based on Distance')
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.black,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    status = Status.enabled;
                  });
                },
                child: Row(
                  children: [
                    Radio(
                      activeColor: Colors.black,
                      value: Status.enabled,
                      groupValue: status,
                      onChanged: (value) {},
                    ),
                    Text('Enable')
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    status = Status.disabled;
                  });
                },
                child: Row(
                  children: [
                    Radio(
                      activeColor: Colors.black,
                      value: Status.disabled,
                      groupValue: status,
                      onChanged: (value) {},
                    ),
                    Text('Disable')
                  ],
                ),
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

  void add(BuildContext context) {
    if (!isNumeric(fromDistance.text)) {
      Fluttertoast.showToast(msg: "From Distance must be numeric");
      Navigator.pop(context);
    } else if (!isNumeric(toDistance.text)) {
      Fluttertoast.showToast(msg: "To Distance must be numeric");
      Navigator.pop(context);
    } else if (!isNumeric(fromTime.text)) {
      Fluttertoast.showToast(msg: "From Time must be numeric");
      Navigator.pop(context);
    } else if (!isNumeric(toTime.text)) {
      Fluttertoast.showToast(msg: "To Time must be numeric");
      Navigator.pop(context);
    } else {
      firRef
          .child("Categories")
          .limitToLast(1)
          .once()
          .then((DatabaseEvent datasnapshot) {
        try {
          int newKey =
              int.parse(datasnapshot.snapshot.children.first.key.toString()) +
                  1;
          int category_id = newKey + 1;

          firRef.child("Categories").child(newKey.toString()).set({
            "category_id": category_id.toString(),
            "from_distance": double.tryParse(fromDistance.text) ?? null,
            "to_distance": double.tryParse(toDistance.text) ?? null,
            "from_time": double.tryParse(fromTime.text) ?? null,
            "to_time": double.tryParse(toTime.text) ?? null,
            "status": status == Status.enabled ? "True" : "False",
            "fixed": fixed == Fixed.fixedPrice,
            "parent_id": widget.parent_id,
            "name": name.text,
            "rate": rate.text,
            "seats": seats.text,
            "image": fileName,
          });
          Fluttertoast.showToast(msg: "Data Updated");
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
          // Map<dynamic, dynamic> values = datasnapshot.snapshot.children.first.key as Map<dynamic, dynamic>;
          // values.forEach((key, value) {
          //   if(value!=null)
          //     firRef.child("Categories").child(key.toString()).update({
          //       "from_distance":fromDistance.text,
          //       "to_distance":toDistance.text,
          //       "from_time":fromTime.text,
          //       "to_time":toTime.text,
          //       "name":name.text,
          //       "rate":rate.text,
          //       "seats":seats.text,
          //       "image":fileName,
          //     });
          // });
        } catch (e) {
          print(e.toString());
        }
      });
    }

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
        .equalTo(widget.parent_id)
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
