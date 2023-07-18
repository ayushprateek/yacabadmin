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

class AdhaarDetails extends StatefulWidget {
  String driver_id;

  AdhaarDetails({required this.driver_id});

  @override
  _AdhaarDetailsState createState() => _AdhaarDetailsState();
}

class _AdhaarDetailsState extends State<AdhaarDetails> {
  String Status = "Pending";
  List<String> status = ['Pending', 'Disapproved', 'Approved'];
  TextEditingController reason = TextEditingController();
  File? _imageFile;
  String? fileName;
  bool hasUploaded = false, isSet = false;
  final picker = ImagePicker();

  Future pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null)
      setState(() {
        _imageFile = File(pickedFile.path);
      });
  }

  Future uploadImageToFirebase(BuildContext context, bool isUpdating) async {
    if (_imageFile == null) {
      if (isUpdating)
        update(context);
      else
        add(context);
    } else {
      fileName = basename(_imageFile?.path ?? "");
      print("fileName");
      print(_imageFile?.path ?? "");
      print(fileName);
      fileName = 'Documents/$fileName';
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName ?? "");

      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile!);
      await uploadTask.then((p0) {
        p0.ref.getDownloadURL().then((value) {
          print(value);
        });
      });
      if (isUpdating)
        update(context);
      else
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

  List image = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Adhaar Details",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 23),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: firRef
                  .child("AdhaarDetails")
                  .orderByChild("driver_id")
                  .equalTo(widget.driver_id)
                  .onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                image.clear();
                DatabaseEvent? databaseEvent = snapshot.data as DatabaseEvent;
                databaseEvent.snapshot.children.forEach((event) {
                  image.add(event.value as Map);
                });
                // try
                // {
                //   Map<dynamic,dynamic> values=snapshot.data.snapshot.value;
                //   if(values!=null)
                //     values.forEach((key, value) {
                //       if(value!=null)
                //         image.add(value);
                //     });
                // }
                // catch(e)
                // {
                //   List<dynamic> values=snapshot.data.snapshot.value;
                //   if(values!=null)
                //     values.forEach(( value) {
                //       if(value!=null)
                //         image.add(value);
                //     });
                // }
                if (image.length != 0) {
                  Widget imageWidget = Container();
                  if (!isSet) {
                    isSet = true;
                    fileName = image[0]['image'];
                    Status = image[0]['status'];
                  }
                  imageWidget = FutureBuilder(
                      future: imageurl(image[0]['image']),
                      builder: (context, AsyncSnapshot<Url> snap) {
                        if (!snap.hasData) return Container();
                        try {
                          return Image.network(snap.data?.image);
                        } catch (e) {}
                        return Container();
                      });
                  if (image[0]['status'].toString().toUpperCase() ==
                          "PENDING" ||
                      image[0]['status'].toString().toUpperCase() ==
                          "DISAPPROVED") {
                    imageWidget = Stack(
                      children: [
                        imageWidget,
                        Positioned(
                          right: 20,
                          top: 10,
                          child: Container(
                            color: Colors.white,
                            child: Center(
                              child: IconButton(
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
                                icon: Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: buttonColor,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }

                  return Column(
                    children: [
                      _imageFile != null
                          ? Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 10,
                                  right: MediaQuery.of(context).size.width / 10,
                                  top: 20),
                              child: Stack(
                                children: [
                                  Image.file(_imageFile!),
                                  Positioned(
                                    right: 20,
                                    top: 10,
                                    child: Container(
                                      color: Colors.white,
                                      child: Center(
                                        child: IconButton(
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
                                                    pickImage(
                                                        ImageSource.camera);
                                                  },
                                                  positiveText: "Gallery",
                                                  onPositiveClick: () {
                                                    Navigator.pop(context);
                                                    pickImage(
                                                        ImageSource.gallery);
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
                                          icon: Icon(
                                            Icons.camera_alt,
                                            size: 30,
                                            color: buttonColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : imageWidget,
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 10,
                            right: MediaQuery.of(context).size.width / 10,
                            top: 20),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
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
                                                          image[0]['status'];
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
                                          //           Status=image[0]['status'];
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
                            image[0]['status'].toString().toUpperCase() ==
                                        "DISAPPROVED" &&
                                    image[0]['reason'] != null
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
                                            image[0]['reason']
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
                              height: 70,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        height: MediaQuery.of(context).size.height / 15,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        margin: EdgeInsets.only(
                            left: 8, top: 8, right: 8, bottom: 10),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (!hasUploaded) {
                              hasUploaded = true;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              20,
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  );
                                },
                              );
                              if (Status == "Disapproved" &&
                                  reason.text.isEmpty) {
                                hasUploaded = false;
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    msg:
                                        "Please enter the reason of disapproval");
                              } else
                                uploadImageToFirebase(context, true);
                            }
                          },
                          child: Text(
                            "Update",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 20),
                          ),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    Center(
                        child: _imageFile != null
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width / 10,
                                    right:
                                        MediaQuery.of(context).size.width / 10,
                                    top: 20),
                                child: Image.file(_imageFile!),
                              )
                            : InkWell(
                                onTap: () {
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
                                child: Icon(
                                  Icons.image,
                                  size: MediaQuery.of(context).size.width,
                                  color: Colors.grey,
                                ))),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 10,
                          right: MediaQuery.of(context).size.width / 10,
                          top: 20),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
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
                                Text(
                                  "PENDING ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 70,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      height: MediaQuery.of(context).size.height / 15,
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
                          if (_imageFile == null) {
                            Fluttertoast.showToast(
                                msg: "Please Select an Image");
                          } else if (!hasUploaded) {
                            hasUploaded = true;
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 20,
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                );
                              },
                            );
                            uploadImageToFirebase(context, false);
                          }
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 20),
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void add(BuildContext context) {
    firRef
        .child("AdhaarDetails")
        .limitToLast(1)
        .once()
        .then((DatabaseEvent datasnapshot) {
      try {
        int newKey =
            int.parse(datasnapshot.snapshot.children.first.key.toString()) + 1;
        firRef.child("AdhaarDetails").child(newKey.toString()).set({
          "image": fileName,
          "id": (newKey + 1).toString(),
          "driver_id": widget.driver_id,
          "date_added": DateTime.now().toIso8601String(),
          "status": "Pending",
        });
      } catch (e) {
        print(e.toString());
      }
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  void update(BuildContext context) {
    //todo:CHECK WHY IS IT LIMIT TO LAST 1 it should be widget.driver_id

    firRef
        .child("AdhaarDetails")
        .limitToLast(1)
        .once()
        .then((DatabaseEvent datasnapshot) {
      try {
        Map<dynamic, dynamic> values =
            datasnapshot.snapshot.children.first.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          firRef.child("AdhaarDetails").child(key.toString()).update({
            "image": fileName,
            "status": Status,
            "date_updated": DateTime.now().toIso8601String(),
            "reason": Status == "Disapproved" ? reason.text : null,
          });
        });
      } catch (e) {
        print(e.toString());
      }
      Navigator.pop(context);
      setState(() {});
    });
  }
// void add(BuildContext context)
// {
//   firRef.child("AdhaarDetails")
//       .limitToLast(1)
//       .once().then((snapshot){
//     Map<dynamic,dynamic> values=snapshot.value;
//     if(values!=null)
//       values.forEach((key, value) {
//         int newKey=int.parse(key.toString());
//         newKey++;
//         firRef.child("AdhaarDetails").child(newKey.toString()).set({
//           "image":fileName,
//           "id":(newKey+1).toString(),
//           "driver_id":widget.driver_id,
//           "date_added":DateTime.now().toIso8601String(),
//           "status":"Pending",
//         });
//       });
//   });
//
//   Navigator.pop(context);
//   Navigator.pop(context);
// }
// void update(BuildContext context)
// {
//   firRef.child("AdhaarDetails")
//       .limitToLast(1)
//       .once().then((snapshot){
//     Map<dynamic,dynamic> values=snapshot.value;
//     if(values!=null)
//       values.forEach((key, value) {
//         firRef.child("AdhaarDetails").child(key.toString()).update({
//           "image":fileName,
//           "status":Status,
//           "date_updated":DateTime.now().toIso8601String(),
//           "reason":Status=="Disapproved"?reason.text:null,
//         });
//       });
//   });
//   Navigator.pop(context);
//   setState(() {
//
//   });
//
//
// }
}
