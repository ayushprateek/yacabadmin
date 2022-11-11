import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:yacabadmin/Services/SendEmail.dart';
class SendEmailUI extends StatefulWidget {
  static String? recipient;
  @override
  _SendEmailUIState createState() => _SendEmailUIState();
}
class _SendEmailUIState extends State<SendEmailUI> {
  TextEditingController recipient=TextEditingController(text: SendEmailUI.recipient);
  TextEditingController subject=TextEditingController();
  TextEditingController header=TextEditingController();
  TextEditingController body=TextEditingController();
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
        title: Text("Send Email",
          style: TextStyle(
            fontWeight: FontWeight.w900,

          ),),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 8,),
              Container(
                decoration: BoxDecoration(
                    border:Border.all()
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      SizedBox(height: 8,),
                      Container(
                        child: TextFormField(
                          onTap: (){

                          },
                          controller: recipient,

                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Recipient",
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w700
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
                      SizedBox(height: 8,),
                      Container(
                        child: TextFormField(
                          onTap: (){

                          },
                          controller: subject,

                          decoration: new InputDecoration(

                            contentPadding: EdgeInsets.only(left: 8),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Subject",

                            labelStyle: TextStyle(
                                color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w700
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
                      SizedBox(height: 8,),
                      Container(
                        child: TextFormField(
                          onTap: (){

                          },
                          controller: header,

                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Header",
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w700
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
                      SizedBox(height: 8,),
                      Container(
                        child: TextFormField(
                          onTap: (){

                          },
                          maxLines: 20,
                          controller: body,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8,top: 15),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Body",
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w700
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
                      SizedBox(height: 8,),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(

                            ),
                          ),

                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5))),
                              margin: EdgeInsets.only(
                                  left: 8, top: 8, right: 8, bottom: 10),
                              child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  onPressed: () async {
                                   if(recipient.text.isEmpty)
                                     {
                                       Fluttertoast.showToast(msg:"Recipient cannot be empty");
                                     }
                                   else
                                   if(subject.text.isEmpty)
                                   {
                                     Fluttertoast.showToast(msg:"Subject cannot be empty");
                                   }
                                   else
                                   if(header.text.isEmpty)
                                   {
                                     Fluttertoast.showToast(msg:"Header cannot be empty");
                                   }
                                   else
                                   if(body.text.isEmpty)
                                   {
                                     Fluttertoast.showToast(msg:"Body cannot be empty");
                                   }
                                   else
                                     {
                                       showDialog(
                                         context: context,
                                         builder: (BuildContext context) {
                                           return AlertDialog(
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
                                      await sendEmail(recipient.text, subject.text,"Hi", header.text, body.text);
                                      clearTextFields();
                                      Fluttertoast.showToast(msg: "Email sent");

                                      Navigator.pop(context);
                                      setState(() {

                                      });
                                     }
                                  },
                                  child:Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FittedBox(
                                      child: Text("Send",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20
                                        ),),
                                    ),
                                  ),
                                  color: HexColor("#35B736")
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8,),
            ],
          ),
        ),
      ),
    );
  }

  void clearTextFields() {
    recipient.clear();
    subject.clear();
    header.clear();
    body.clear();
  }
}
