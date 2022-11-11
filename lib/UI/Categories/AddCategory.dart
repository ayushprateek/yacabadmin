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

class AddCategory extends StatefulWidget {
  String parent_id;

  AddCategory({required this.parent_id});

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController name = TextEditingController();
  TextEditingController rate = TextEditingController();
  TextEditingController seats = TextEditingController();

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
      add(context);
    } else {
      fileName = basename(_imageFile?.path ?? "");
      // print("fileName");
      // print(_imageFile.path);
      print(fileName);
      fileName = 'Drivers/$fileName';
      Reference firebaseStorageRef =FirebaseStorage.instance.ref().child(fileName ?? "");

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
          "Add Category",
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
                            color: Theme.of(context).buttonColor,
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
                            //       color: Theme.of(context).buttonColor,
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
                            //       color: Theme.of(context).buttonColor,
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
                      Container(
                        child: TextFormField(
                          onTap: () {},
                          controller: name,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Category Name",
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
                      widget.parent_id == "0"
                          ? Container()
                          : Container(
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
                                keyboardType: TextInputType.number,
                                style: new TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w900),
                              ),
                            ),
                      widget.parent_id == "0"
                          ? Container()
                          : SizedBox(
                              height: 15,
                            ),
                      widget.parent_id == "0"
                          ? Container()
                          : Container(
                              child: TextFormField(
                                onTap: () {},
                                controller: seats,
                                decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8),
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Number of Seats",
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
                      widget.parent_id == "0"
                          ? Container()
                          : SizedBox(
                              height: 15,
                            ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        tooltip: "Add category",
        onPressed: () {
          if (_imageFile == null) {
            Fluttertoast.showToast(msg: "Please select the image");
          } else if (name.text.isEmpty) {
            Fluttertoast.showToast(msg: "Name cannot be empty");
          } else {
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
          }
        },
        child: Icon(
          Icons.save,
          color: Theme.of(context).buttonColor,
        ),
      ),
    );
  }

  void add(BuildContext context) {
    int category_id;
    firRef
        .child("Categories")
        .limitToLast(1)
        .once()
        .then((DatabaseEvent datasnapshot) {
      try {
        int newKey =
            int.parse(datasnapshot.snapshot.children.first.key.toString()) + 1;
        category_id = newKey + 1;
        firRef.child("Categories").child(newKey.toString()).set({
          "name": name.text,
          "rate": widget.parent_id == "0" ? null : rate.text,
          "seats": widget.parent_id == "0" ? null : seats.text,
          "parent_id": widget.parent_id,
          "image": fileName == null ? "Categories/Car.png" : fileName,
          "category_id": category_id.toString(),
          "status": "True",
        });
      } catch (e) {
        print(e.toString());
      }
      Fluttertoast.showToast(
          msg: "Images Uploaded",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      Fluttertoast.showToast(msg: "Category Added");
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    });

    // firRef.child("Categories").limitToLast(1).once().then((snapshot) {
    //   try
    //   {
    //     Map<dynamic,dynamic> values=snapshot.value;
    //     if(values!=null)
    //       values.forEach((key, value) {
    //         int newKey=int.parse(key.toString());
    //         newKey++;
    //         int category_id=newKey+1;
    //         firRef.child("Categories").child(newKey.toString()).set({
    //           "name":name.text,
    //           "rate":widget.parent_id=="0"?null:rate.text,
    //           "seats":widget.parent_id=="0"?null:seats.text,
    //           "parent_id":widget.parent_id,
    //           "image":fileName==null?"Categories/Car.png":fileName,
    //           "category_id":category_id.toString(),
    //           "status":"True",
    //         });
    //
    //       });
    //   }
    //   catch(e)
    //   {
    //
    //   }
    //   Fluttertoast.showToast(msg: "Category Added");
    //   Timer(Duration(seconds: 2),(){
    //     Navigator.pop(context);
    //     Navigator.pop(context);
    //   });
    //
    // });
  }
}
