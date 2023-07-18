import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yacabadmin/Components/Customs.dart';
import 'package:yacabadmin/UI/Dashboard.dart';

bool OTPsent = false;

class LoginPage extends StatefulWidget {
  static bool isComingFromCart = false;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double div = 1.35;

  final key = GlobalKey<ScaffoldState>();
  TextEditingController username = TextEditingController(text: "yacabadmin");
  TextEditingController password = TextEditingController(text: "yacab@123");
  bool accountExists = false,_isLoading=false;
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 30,
        ),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            flex: _keyboardIsVisible() ? 2 : 4,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20),
                child: Text(
                  "Login using username and password",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 35),
                ),
              ),
            ),
          ),
          Expanded(
            flex: _keyboardIsVisible() ? 2 : 3,
            child: Container(
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: TextFormField(
                        onTap: () {
                          setState(() {
                            div = 1.9;
                          });
                        },
                        controller: username,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          labelText: "username",
                          prefixIcon: Icon(
                            Icons.person,
                            color: buttonColor,
                          ),
                          fillColor: Colors.white,
                          hoverColor: Colors.red,

                          // fillColor: Colors.red,
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(0.0),
                            borderSide: new BorderSide(color: Colors.grey),
                          ),
                          //labelStyle: TextStyle(color: Color(0XFF27ab87")),

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
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: TextFormField(
                        onTap: () {
                          setState(() {
                            div = 1.9;
                          });
                        },
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(10),
                        ],
                        controller: password,
                        obscureText: obscureText,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          prefixIcon: Icon(Icons.password, color: buttonColor),
                          fillColor: Colors.white,
                          hoverColor: Colors.red,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: obscureText
                                ? Icon(Icons.visibility, color: buttonColor)
                                : Icon(Icons.visibility_off,
                                    color: buttonColor),
                          ),
                          labelText: "password",

                          // fillColor: Colors.red,
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(0.0),
                            borderSide: new BorderSide(color: Colors.grey),
                          ),
                          //labelStyle: TextStyle(color: Color(0XFF27ab87")),

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
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, top: 8, bottom: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.3,
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
                                if(!_isLoading)
                                  {
                                    setState(() {
                                      _isLoading=true;
                                    });
                                    login(context);

                                  }


                                //Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new Dashboard()));
                              },
                              child: _isLoading?
                              CircularProgressIndicator(color: Colors.black,):Text(
                                "Log In",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20),
                              ),
                              color: buttonColor,
                            ),
                          )),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  bool _keyboardIsVisible() {
    if (MediaQuery.of(context).viewInsets.bottom == 0.0) {
      setState(() {
        div = 1.35;
      });
    } else {
      setState(() {
        div = 1.9;
      });
    }
    print(!(MediaQuery.of(context).viewInsets.bottom == 0.0));
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  void login(BuildContext context) {
    firRef.child("Admin").once().then((DatabaseEvent datasnapshot) {
      bool loginSuccessfull = false;
      try {
        Map<dynamic, dynamic> value =
            datasnapshot.snapshot.children.first.value as Map<dynamic, dynamic>;
        print(value);
        if (value != null &&
            value['username'].toString().toLowerCase() ==
                username.text.toLowerCase() &&
            value['password'].toString() == password.text) {
          loginSuccessfull = true;
          Navigator.pushReplacement(context,
              new MaterialPageRoute(builder: (context) => new Dashboard()));
        }
      } catch (e) {
        print(e.toString());
      }
      setState(() {
        _isLoading=false;
      });
      if (!loginSuccessfull) {

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Invalid Credentials!"),
          backgroundColor: Colors.red,
        ));
      }
    });
    // firRef.child("Admin").once().then((snapshot){
    //   try
    //       {
    //         List<dynamic> val=snapshot.value;
    //         if(val!=null)
    //           val.forEach((value) {
    //             if(value!=null
    //                 && value['username'].toString().toLowerCase()==username.text.toLowerCase()
    //             && value['password'].toString()==password.text)
    //               {
    //                 loginSuccessfull=true;
    //                 Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new Dashboard()));
    //               }
    //           });
    //       }
    //       catch(e)
    //   {
    //     Map<dynamic,dynamic> val=snapshot.value;
    //     if(val!=null)
    //       val.forEach((key,value) {
    //         if(value!=null
    //             && value['username'].toString().toLowerCase()==username.text.toLowerCase()
    //             && value['password'].toString()==password.text)
    //         {
    //           loginSuccessfull=true;
    //           Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new Dashboard()));
    //         }
    //       });
    //   }
    //   if(!loginSuccessfull)
    //     {
    //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Credentials!"),backgroundColor: Colors.red,));
    //     }
    // });
  }
}
