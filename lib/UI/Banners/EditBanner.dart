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

enum Status { enabled, disabled }

Status status = Status.disabled;

class EditBanner extends StatefulWidget {
  var banner_id, title;

  EditBanner({this.banner_id, this.title});

  @override
  _EditBannerState createState() => _EditBannerState();
}

class _EditBannerState extends State<EditBanner> {
  File? _imageFile;
  final picker = ImagePicker();
  String? fileName;
  bool hasUploaded = false;

  Future pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      // print(_imageFile?.lengthSync().toString()+"KB");
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future uploadImageToFirebase(BuildContext context) async {
    if (_imageFile == null) {
      hasUploaded = false;
      updateBanner(context);
    } else {
      fileName = basename(_imageFile?.path ?? "");
      fileName = 'Banners/$fileName';
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName ?? "");

      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile!);
      await uploadTask.then((p0) {
        p0.ref.getDownloadURL().then((value) {
          print(value);
        });
      });
      updateBanner(context);
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

  var connection;
  List lists = [];
  List imagelists = [];

  @override
  void initState() {
    connection = firRef
        .child("Banners")
        .orderByChild("banner_id")
        .equalTo(widget.banner_id)
        .onValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        children: [
          StreamBuilder(
            stream: connection,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                imagelists.clear();
                DatabaseEvent? databaseEvent = snapshot.data as DatabaseEvent;
                databaseEvent.snapshot.children.forEach((event) {
                  imagelists.add(event.value as Map);
                });

                // try{
                //   List<dynamic> values  = snapshot.data.snapshot.value;
                //   values.forEach((values) {
                //     try{
                //       if(values!=null && values['banner_id']==widget.banner_id)
                //       {
                //         imagelists.add(values);
                //       }
                //     }
                //     catch(e){
                //     }
                //   });
                // }catch(e){
                //
                //   Map<dynamic,dynamic> values  = snapshot.data.snapshot.value;
                //   values.forEach((key,values) {
                //     try{
                //       if( values!=null && values['banner_id']==widget.banner_id )
                //       {
                //         imagelists.add(values);
                //       }
                //     }
                //     catch(e){
                //     }
                //   });
                // }
                if (imagelists.isEmpty) return Container();

                if (_imageFile == null) fileName = imagelists[0]["image"];
                Widget image;
                image = FutureBuilder(
                  future: imageurl(imagelists[0]["image"]),
                  builder: (context, AsyncSnapshot<Url> snap) {
                    if (snap.hasData) {
                      Widget image;
                      try {
                        image = Image.network(snap.data?.image,
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width);
                      } catch (e) {
                        image = IconButton(
                          iconSize: MediaQuery.of(context).size.width,
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: MediaQuery.of(context).size.width,
                          ),
                          onPressed: () {},
                        );
                      }

                      return image;
                    }
                    return IconButton(
                      iconSize: MediaQuery.of(context).size.width,
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: MediaQuery.of(context).size.width,
                      ),
                      onPressed: () {},
                    );
                  },
                );
                image = imagelists[0]['status'] == "True"
                    ? image
                    : Center(
                        child: Stack(
                          children: [
                            //lists[index].image
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              foregroundDecoration: BoxDecoration(
                                color: Colors.grey,
                                backgroundBlendMode: BlendMode.saturation,
                              ),
                              child: image,
                            ),
                            Positioned(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width / 4,
                                color: Colors.red,
                                child: Center(
                                  child: Text(
                                    "Banner disabled",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              bottom: 0,
                            )
                          ],
                        ),
                      );

                return Column(
                  children: [
                    _imageFile != null
                        ? Image.file(
                            _imageFile!,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 3,
                          )
                        : Container(
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10.0,
                                  offset: const Offset(5.0, 2.0),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                image,
                                Positioned(
                                  top: 15,
                                  right: 15,
                                  //give the values according to your requirement
                                  child: Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.rectangle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 10.0,
                                          offset: const Offset(5.0, 2.0),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: Colors.black,
                                        size: 35,
                                      ),
                                      onPressed: () {
                                        showAnimatedDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return ClassicGeneralDialogWidget(
                                              titleText: 'Use',
                                              contentText:
                                                  'How do u want to upload?',
                                              negativeText: 'Camera',
                                              onNegativeClick: () {
                                                pickImage(ImageSource.camera);
                                                Navigator.pop(context);
                                              },
                                              positiveText: "Gallery",
                                              onPositiveClick: () {
                                                pickImage(ImageSource.gallery);
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                        );
                                        // animated_dialog_box.showScaleAlertBox(
                                        //     title: Center(child: Text("Use")),
                                        //     context: context,
                                        //     firstButton: MaterialButton(
                                        //       // OPTIONAL BUTTON
                                        //       shape: RoundedRectangleBorder(
                                        //         borderRadius:
                                        //             BorderRadius.circular(40),
                                        //       ),
                                        //       color: Colors.black,
                                        //       child: Text('Camera',
                                        //           style: TextStyle(
                                        //               color: Colors.white)),
                                        //       onPressed: () {
                                        //         pickImage(ImageSource.camera);
                                        //         Navigator.pop(context);
                                        //       },
                                        //     ),
                                        //     secondButton: MaterialButton(
                                        //       // FIRST BUTTON IS REQUIRED
                                        //       shape: RoundedRectangleBorder(
                                        //         borderRadius:
                                        //             BorderRadius.circular(40),
                                        //       ),
                                        //       color: Colors.black,
                                        //       child: Text('Gallery',
                                        //           style: TextStyle(
                                        //               color: Colors.white)),
                                        //       onPressed: () {
                                        //         pickImage(ImageSource.gallery);
                                        //         Navigator.pop(context);
                                        //       },
                                        //     ),
                                        //     icon: Icon(
                                        //       Icons.info,
                                        //       color: Colors.red,
                                        //     ),
                                        //     // IF YOU WANT TO ADD ICON
                                        //     yourWidget: Container(
                                        //       child: Text(
                                        //           'How do u want to upload?'),
                                        //     ));
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                );
              }
              return Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(5.0, 2.0),
                    ),
                  ],
                ),
                child: IconButton(
                  iconSize: MediaQuery.of(context).size.width,
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.width,
                  ),
                  onPressed: () {},
                ),
              );
            },
          ),
          StreamBuilder(
            stream: connection,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                lists.clear();
                DatabaseEvent? databaseEvent = snapshot.data as DatabaseEvent;
                databaseEvent.snapshot.children.forEach((event) {
                  lists.add(event.value as Map);
                });
                // try{
                //   List<dynamic> values  = snapshot.data.snapshot.value;
                //   values.forEach((values) {
                //     try{
                //       if(values!=null && values['banner_id']==widget.banner_id)
                //       {
                //         lists.add(values);
                //       }
                //     }
                //     catch(e){
                //     }
                //   });
                // }catch(e)
                // {
                //   Map<dynamic,dynamic> values  = snapshot.data.snapshot.value;
                //   values.forEach((key,values) {
                //     try{
                //       if( values!=null && values['banner_id']==widget.banner_id )
                //       {
                //         lists.add(values);
                //       }
                //     }
                //     catch(e){
                //     }
                //   });
                // }
                if (lists.isNotEmpty) {
                  status = lists[0]['status'] == "True"
                      ? Status.enabled
                      : Status.disabled;
                  return ListView.builder(
                    physics: ScrollPhysics(),
                    itemCount: lists.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, index) {
                      var data = snapshot.data;
                      return Column(
                        children: [
                          BannerStatus(
                            status: status,
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return Container();
                }
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            margin: EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 10),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
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
                          'Are you sure you want to Delete this banner?',
                      negativeText: 'Cancel',
                      onNegativeClick: () {
                        Navigator.pop(context);
                      },
                      positiveText: "Delete",
                      onPositiveClick: () {
                        delete(context);
                      },
                    );
                  },
                );
                // animated_dialog_box.showScaleAlertBox(
                //     title: Center(child: Text("Delete")),
                //     // IF YOU WANT TO ADD
                //     context: context,
                //     firstButton: MaterialButton(
                //       // OPTIONAL BUTTON
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(40),
                //       ),
                //       color: Colors.white,
                //       child: Text('Cancel'),
                //       onPressed: () {
                //         Navigator.of(context).pop();
                //       },
                //     ),
                //     secondButton: MaterialButton(
                //       // FIRST BUTTON IS REQUIRED
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(40),
                //       ),
                //       color: Colors.red,
                //       child: Text(
                //         'Delete',
                //         style: TextStyle(color: Colors.white),
                //       ),
                //       onPressed: () {
                //         delete(context); //***********************************************************DELETE CALLED
                //       },
                //     ),
                //     icon: Icon(
                //       Icons.info_outline,
                //       color: Colors.red,
                //     ),
                //     // IF YOU WANT TO ADD ICON
                //     yourWidget: Container(
                //       child:
                //           Text('Are you sure you want to Delete this banner?'),
                //     ));
              },
              child: Text(
                "Delete this banner",
                style: new TextStyle(color: Colors.white),
              ),
              color: Colors.red,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!hasUploaded) {
            hasUploaded = true;
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
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }

  void updateBanner(context) {
    String bannerStatus = status == Status.enabled ? "True" : "False";

    firRef
        .child("Banners")
        .orderByChild("banner_id")
        .equalTo(widget.banner_id)
        .once()
        .then((DatabaseEvent datasnapshot) {
      try {
        Map<dynamic, dynamic> values =
            datasnapshot.snapshot.children.first.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          try {
            if (value != null &&
                value['banner_id'].toString() == widget.banner_id.toString()) {
              // deleteImage(value['image']);
              firRef.child("Banners").child(key.toString()).update({
                "status": bannerStatus.toString(),
                "image": fileName.toString(),
              });
            }
          } catch (e) {
            print(e.toString());
          }
        });
      } catch (e) {
        print(e.toString());
      }
      Navigator.pop(context);
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Banner updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    });

    // firRef.child("Banners").orderByChild("banner_id").equalTo(widget.banner_id).once().then(
    //         (DataSnapshot datasnapshot) {
    //       try{
    //         List<dynamic> values = datasnapshot.value;
    //         if(values!=null)
    //         for (int i = 0; i < values.length; i++) {
    //           try{
    //             if (values[i]!=null && values[i]['banner_id'].toString() == widget.banner_id.toString()) {
    //               // deleteImage(values[i]['image']);
    //               firRef.child("Banners").child(i.toString()).update(
    //                   {
    //                     "status":bannerStatus.toString(),
    //                     "image":fileName.toString(),
    //                   });
    //             }
    //           }
    //           catch(e) {
    //             print(e.toString());
    //           }
    //         }
    //       }
    //       catch(e)
    //       {
    //         Map<dynamic,dynamic> values = datasnapshot.value;
    //         if(values!=null)
    //         values.forEach((key, value) {
    //           try{
    //             if (value!=null && value['banner_id'].toString() == widget.banner_id.toString()) {
    //               // deleteImage(value['image']);
    //               firRef.child("Banners").child(key.toString()).update(
    //                   {
    //                     "status":bannerStatus.toString(),
    //                     "image":fileName.toString(),
    //                   });
    //             }
    //           }
    //           catch(e) {
    //             print(e.toString());
    //           }
    //         });
    //
    //       }
    //
    //       Navigator.pop(context);
    //       Navigator.pop(context);
    //       Fluttertoast.showToast(
    //           msg:
    //           "Banner updated",
    //           toastLength: Toast
    //               .LENGTH_SHORT,
    //           gravity:
    //           ToastGravity
    //               .BOTTOM,
    //           timeInSecForIosWeb:
    //           1,
    //           fontSize: 16.0);
    //     });
  }

  void delete(BuildContext context) {
    firRef
        .child("Banners")
        .orderByChild("banner_id")
        .equalTo(widget.banner_id)
        .once()
        .then((DatabaseEvent datasnapshot) {
      try {
        Map<dynamic, dynamic> values =
            datasnapshot.snapshot.children.first.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          if (values['banner_id'].toString() == widget.banner_id) {
            // deleteImage(values['image']);
            firRef.child("Banners").child(key).remove();
          }
        });
      } catch (e) {
        print(e.toString());
      }

      Timer(Duration(seconds: 2), () {
        Navigator.of(context).pop(context);
        Navigator.of(context).pop(context);
      });
    });
    // firRef.child("Banners").orderByChild("banner_id").equalTo(widget.banner_id).once().then(
    //         (DataSnapshot datasnapshot) {
    //       try{
    //         List<dynamic> values = datasnapshot.value;
    //         for (int i = 0; i < values.length; i++) {
    //           try{
    //             if (values[i]['banner_id'].toString() == widget.banner_id) {
    //               // deleteImage(values[i]['image']);
    //               firRef.child("Banners").child(i.toString()).remove();
    //
    //             }
    //           }
    //           catch(e)
    //           {
    //           }
    //
    //         }
    //       }
    //       catch(e)
    //       {
    //         Map<dynamic,dynamic> values = datasnapshot.value;
    //         values.forEach((key, value) {
    //           if (values['banner_id'].toString() == widget.banner_id)
    //           {
    //             // deleteImage(values['image']);
    //             firRef.child("Banners").child(key).remove();
    //           }
    //
    //
    //         });
    //
    //       }
    //       Navigator.of(context).pop(context);
    //       Navigator.of(context).pop(context);
    //
    //     }
    //
    // );
  }
}

class BannerStatus extends StatefulWidget {
  Status status;

  BannerStatus({required this.status});

  @override
  _BannerStatusState createState() => _BannerStatusState();
}

class _BannerStatusState extends State<BannerStatus> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (status != Status.enabled) {
              showAnimatedDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return ClassicGeneralDialogWidget(
                    titleText: 'Enable',
                    contentText: 'Enable this banner?',
                    negativeText: 'No',
                    onNegativeClick: () {
                      Navigator.pop(context);
                    },
                    positiveText: "Yes",
                    onPositiveClick: () {
                      setState(() {
                        status = Status.enabled;
                      });
                      Navigator.of(context).pop();
                    },
                  );
                },
              );
            }
            // animated_dialog_box.showScaleAlertBox(
            //     title: Center(child: Text("Enable")),
            //     // IF YOU WANT TO ADD
            //     context: context,
            //     firstButton: MaterialButton(
            //       // OPTIONAL BUTTON
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(40),
            //       ),
            //       color: Colors.white,
            //       child: Text('No'),
            //       onPressed: () {
            //         Navigator.of(context).pop();
            //       },
            //     ),
            //     secondButton: MaterialButton(
            //       // FIRST BUTTON IS REQUIRED
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(40),
            //       ),
            //       color: Colors.black,
            //       child: Text(
            //         'Yes',
            //         style: TextStyle(color: Colors.white),
            //       ),
            //       onPressed: () {
            //         setState(() {
            //           status = Status.enabled;
            //         });
            //         Navigator.of(context).pop();
            //       },
            //     ),
            //     icon: Icon(
            //       Icons.info_outline,
            //       color: Colors.red,
            //     ),
            //     // IF YOU WANT TO ADD ICON
            //     yourWidget: Container(
            //       child: Text('Enable this banner?'),
            //     ));
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
            if (status != Status.disabled) {
              showAnimatedDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return ClassicGeneralDialogWidget(
                    titleText: 'Disable',
                    contentText: 'Disable this banner?',
                    negativeText: 'No',
                    onNegativeClick: () {
                      Navigator.pop(context);
                    },
                    positiveText: "Yes",
                    onPositiveClick: () {
                      setState(() {
                        status = Status.disabled;
                      });
                      Navigator.of(context).pop();
                    },
                  );
                },
              );
            }
            // animated_dialog_box.showScaleAlertBox(
            //     title: Center(child: Text("Disable")),
            //     // IF YOU WANT TO ADD
            //     context: context,
            //     firstButton: MaterialButton(
            //       // OPTIONAL BUTTON
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(40),
            //       ),
            //       color: Colors.white,
            //       child: Text('No'),
            //       onPressed: () {
            //         Navigator.of(context).pop();
            //       },
            //     ),
            //     secondButton: MaterialButton(
            //       // FIRST BUTTON IS REQUIRED
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(40),
            //       ),
            //       color: Colors.black,
            //       child: Text(
            //         'Yes',
            //         style: TextStyle(color: Colors.white),
            //       ),
            //       onPressed: () {
            //         setState(() {
            //           status = Status.disabled;
            //         });
            //         Navigator.of(context).pop();
            //       },
            //     ),
            //     icon: Icon(
            //       Icons.info_outline,
            //       color: Colors.red,
            //     ),
            //     // IF YOU WANT TO ADD ICON
            //     yourWidget: Container(
            //       child: Text('Disable this banner?'),
            //     ));
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
      ],
    );
  }
}
