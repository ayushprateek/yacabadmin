import 'package:flutter/material.dart';
Future showRejectionDialog(
    {
      required BuildContext context,
      required Function onRejection,
      required Function onCancel,
      required TextEditingController controller,
    })
{
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Reason of Rejection"),
        content: Container(

          width: MediaQuery.of(context).size.width/1.5,
          child: TextFormField(
            controller: controller,

            decoration: new InputDecoration(

              filled: true,

              fillColor: Colors.white,
              hoverColor: Colors.red,

              labelText: "Reason",

              // fillColor: Colors.red,
              focusedBorder: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(0.0),
                borderSide: new BorderSide(
                    color: Colors.grey
                ),
              ) ,
              //labelStyle: TextStyle(color: HexColor("#27ab87")),

              border: new OutlineInputBorder(

                borderRadius: new BorderRadius.circular(0.0),
                borderSide: new BorderSide(


                ),
              ),
              //fillColor: Colors.green
            ),

            style: new TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900
            ),
          ),
        ),
        actions: [
          TextButton(onPressed:()=> onCancel, child: Text("Cancel")),
          TextButton(onPressed:()=> onRejection, child: Text("Reject")),
        ],
      );
    },
  );
}

// void call(){
//   // showRejectionDialog(context: context,
//   //     onRejection: (){
//   //       if(reason.text.isEmpty)
//   //         Fluttertoast.showToast(msg: "Please tell the reason of rejection");
//   //       else
//   //       {
//   //         Navigator.pop(context);
//   //       }
//   //     },
//   //     onCancel: (){
//   //       if(reason.text.isEmpty)
//   //       {
//   //         Status=image[0]['status'];
//   //       }
//   //       Navigator.pop(context);
//   //     }, controller: reason).then((value){
//   //   setState(() {
//   //
//   //   });
//   // });
// }
// void callImage()
// {
//   showAnimatedDialog(
//     context: context,
//     barrierDismissible: true,
//     builder: (BuildContext context) {
//       return ClassicGeneralDialogWidget(
//         titleText: 'Upload Image',
//         contentText: "How do you want to upload?",
//         negativeText: 'Camera',
//         onNegativeClick: () {
//           Navigator.pop(context);
//           pickImage(ImageSource.camera);
//
//         },
//         positiveText: "Gallery",
//         onPositiveClick: () {
//           Navigator.pop(context);
//           pickImage(ImageSource.gallery);
//         },
//       );
//     },
//   );
// }

