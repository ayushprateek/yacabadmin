import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yacabadmin/Components/Customs.dart';
Future<void> main()
async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: AddBanners(),
  ));
}

enum Status { enabled, disabled }

class AddBanners extends StatefulWidget {
  @override
  _AddBannersState createState() => _AddBannersState();
}

class _AddBannersState extends State<AddBanners> {
  String? fileName;
  bool hasUploaded = false;
  Status status = Status.enabled;
  String unit = 'g';
  List<Asset> imagesAssets = <Asset>[];
  List<File> imageFiles = <File>[];
  List<String> fillePath = <String>[];
  File? _imageFile;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null)
      setState(() {
        _imageFile = File(pickedFile.path);
      });
  }

  bool _isNumeric(String result) {
    if (result == null) {
      return false;
    }
    return double.tryParse(result) != null;
  }

  Future uploadImageToFirebase(BuildContext context) async {
    if (_imageFile == null) {
      hasUploaded = false;
      Fluttertoast.showToast(
          msg: "Please select an image!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    } else {
      fileName = basename(_imageFile?.path ?? "");

      fileName = 'product/$fileName';
      Reference firebaseStorageRef =
      FirebaseStorage.instance.ref().child(fileName ?? "");

      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile!);
      await uploadTask.then((p0) {
        p0.ref.getDownloadURL().then((value) {
          print(value);
        });
      });
      addProductImages(context);
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

  //--------------- MILTIPLE IMAGES -------------------------
  Widget buildGridView() {
    if (imagesAssets.length == 0)
      return Container(
        height: 0,
        width: 0,
      );
    // print("Path ="+images[0].name);
    return Container(
      height: 350,
      child: ListView.builder(
        physics: ScrollPhysics(),
        itemCount: imagesAssets.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          Asset asset = imagesAssets[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        },
      ),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];

    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: imagesAssets,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: MaterialOptions(
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;
    setState(() {
      imagesAssets = resultList;
    });
  }

  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
    File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    return file;
  }

  Future uploadImage(BuildContext context) async {
    if (imagesAssets.length == 0) {
      hasUploaded = false;
      Fluttertoast.showToast(
          msg: "Please select an image!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    } else {
      fillePath.clear();
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
      for (int i = 0; i <= imagesAssets.length; i++) {
        if (i == imagesAssets.length) {
          addProductImages(context);
          return;
        }
        File _imageFile = await getImageFileFromAssets(imagesAssets[i]);
        // imageFiles.add(file);
        // File _imageFile=imageFiles[index];
        String fileName = basename(_imageFile.path);
        fileName = 'Banners/$fileName';
        fillePath.add(fileName);

        Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName ?? "");

        UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
        await uploadTask.then((p0) {
          p0.ref.getDownloadURL().then((value) {
            print(value);
          });
        });

        // StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
        // StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
        // StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        // taskSnapshot.ref.getDownloadURL().then(
        //       (value) => print("Done: $value"),
        //     );

        Fluttertoast.showToast(
            msg: "Image ${i + 1} Uploaded",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        // uploadImage(index+1);
      }
    }
  }

  //--------------- MILTIPLE IMAGES -------------------------
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: StickyFooter(),
      appBar: AppBar(
        elevation: 10.0,
        title: Text(
          'Add Product',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   decoration: new BoxDecoration(
            //     color: Colors.white,
            //     shape: BoxShape.rectangle,
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black26,
            //         blurRadius: 10.0,
            //         offset: const Offset(5.0, 2.0),
            //       ),
            //     ],
            //   ),
            //   child: _imageFile != null
            //       ? Image.file(_imageFile,
            //     height: MediaQuery.of(context).size.width,
            //     width: MediaQuery.of(context).size.width,
            //   )
            //       : IconButton(
            //     iconSize: MediaQuery.of(context).size.width,
            //     icon: Icon(Icons.camera_alt,color: Theme.of(context).buttonColor,size: MediaQuery.of(context).size.width,
            //     ),
            //     onPressed: pickImage,
            //   ),
            // ),
            Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.add_a_photo,
                      size: 50,
                      color: HexColor("#4CD864"),
                    ),
                    onPressed: loadAssets,
                  ),
                ),
                buildGridView(),
              ],
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
          ],
        ),
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
            uploadImage(context);
          }
        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }

  void addProductImages(context) {
    int banner_id;
    firRef
        .child("Banners")
        .limitToLast(1)
        .once()
        .then((DatabaseEvent datasnapshot) {
      try {
        int newKey = int.parse(datasnapshot.snapshot.children.first.key.toString()) + 1;
        for (int i = 0; i < fillePath.length; i++, newKey++) {
          banner_id = newKey + 1;
          firRef.child("Banners").child(newKey.toString()).set({
            "banner_id": banner_id.toString(),
            "image": fillePath[i],
            "status": status == Status.enabled ? "True" : "False",
            "title": "HOME BANNER",
          });
        }
      } catch (e) {
        print(e.toString());
      }
      Fluttertoast.showToast(
          msg: "Images Uploaded",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      Navigator.pop(context);
      Timer(
          Duration(
            seconds: 1,
          ), () {
        Navigator.pop(context);
      });
    });

    // search.limitToLast(1).once().then(
    //         (DataSnapshot datasnapshot){
    //       Map<dynamic,dynamic> values= datasnapshot.value;
    //       values.forEach((key,value){
    //         int newKey=int.parse(key.toString())+1;
    //         for(int i=0;i<fillePath.length;i++,newKey++)
    //         {
    //           banner_id=newKey+1;
    //           search.child(newKey.toString()).set({
    //             "banner_id":banner_id.toString(),
    //             "image":fillePath[i],
    //             "status":status==Status.enabled?"True":"False",
    //             "title":"HOME BANNER",
    //
    //           });
    //
    //         }
    //       });
    //       Fluttertoast.showToast(
    //           msg:
    //           "Images Uploaded",
    //           toastLength: Toast
    //               .LENGTH_SHORT,
    //           gravity:
    //           ToastGravity
    //               .BOTTOM,
    //           timeInSecForIosWeb:
    //           1,
    //           fontSize: 16.0);
    //       Navigator.pop(context);
    //       Timer(
    //           Duration(seconds: 1,),
    //               (){
    //
    //             Navigator.pop(context);
    //           });
    //
    //     }
    // );
  }
// void addProduct(context)
// {
//   int product_id;
//   String product_status= status==Status.enabled?"In Stock":"Out of Stock";
//   String product_status_id= status==Status.enabled?"7":"6";
//   firRef.child("Banners").once().then(
//           (DataSnapshot datasnapshot){
//         Map<dynamic,dynamic> values= datasnapshot.value;
//         values.forEach((key,value){
//           int newKey=int.parse(key.toString())+1;
//           product_id=100+newKey;
//           firRef.child("Banners").child(newKey.toString()).set({
//
//             "product_id":product_id.toString(),
//             "name":name.text.toString(),
//             "quantity":quantity.text,
//             "parent_id":category_id.text,
//             "description":description.text.toString(),
//             "model":model.text.toString(),
//             "min_order_qty":min_order_qty.text,
//             "new_price":new_price.text,
//             "old_price":old_price.text,
//             "unit":unit.toString(),
//             "weight":weight.text.toString(),
//             "image":fillePath[0].toString(),
//             "stock_status":product_status,
//             "stock_status_id":product_status_id,
//           });
//         });
//
//
//
//       }
//   );
// }
}
