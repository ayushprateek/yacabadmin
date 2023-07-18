import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:yacabadmin/Components/Customs.dart';

class Send extends StatefulWidget {
  @override
  _SendState createState() => _SendState();
}

class _SendState extends State<Send> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(
        child: MaterialButton(
          color: Colors.white,
          child: Text(
            "Send Email",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
          ),
          onPressed: () {
            //anuj.kan@gmail.com
            //sendEmailToAdmin("ORDER#1111","Your order has been placed","Hi Ayush, we're getting your order ready to be shipped. We will notify you when it has been sent.<br><br>Thanks,<br>ECOMANDI.");
            sendEmail(
                "ayushpratiksrivastava@gmail.com",
                "Test",
                "ORDER#1111",
                "Your order has been placed",
                "Hi Ayush, we're getting your order ready to be shipped. We will notify you when it has been sent.<br><br>Thanks,<br>YA CAB.");
          },
        ),
      ),
    ));
  }
}

Future<void> sendEmail(
    var recipient, var subject, var h1, var h2, var body) async {
  firRef.child("Admin").once().then((DatabaseEvent dataSnapshot) async {
    bool loginSuccessfull = false;
    try {
      Map<dynamic, dynamic> value =
          dataSnapshot.snapshot.children.first.value as Map<dynamic, dynamic>;
      print(value);
      String imagePath =
          "https://firebasestorage.googleapis.com/v0/b/YA CAB-fa718.appspot.com/o/logo%20and%20others%2FLogo.jpeg?alt=media&token=e2bd50c4-6c4a-4d06-b8d1-267822b902a3";
      body +=
          "<br><I>If you have any query then kindly reply to this email or contact us at support@yacab.in</I>";
      String username = value['email_username'];
      String password = value['email_password'];
      //also use for gmail smtp
      //final smtpServer = gmail(username, password);
      final domainSmtp = value['email_domain_smtp'];
      //user for your own domain
      final smtpServer = SmtpServer(domainSmtp,
          username: username, password: password, port: value['email_port']);
      final message = Message()
        ..from = Address(username, 'YA CAB')
        ..recipients.add(recipient)
        //..recipients=[recipient]
        ..subject = subject
        ..text = 'This is the plain text.\nThis is line 2 of the text part.'
        ..html =
            "<img src=$imagePath width=180><h1>$h1</h1>\n\n<h2>$h2</h2>\n\n<p>$body </p>";

      try {
        print(smtpServer.toString());
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
        Fluttertoast.showToast(msg: 'Email sent');
      } catch (e) {
        print('Message not sent.');
        print(e.toString());

        Fluttertoast.showToast(msg: e.toString());
        // for (var p in e.problems) {
        //   print('Problem: ${p.code}: ${p.msg}');
        // }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  });
}

Future<void> sendEmailToAdmin(var h1, var h2, var body) async {
  String imagePath =
      "https://firebasestorage.googleapis.com/v0/b/YA CAB-fa718.appspot.com/o/logo%20and%20others%2FLogo.jpeg?alt=media&token=e2bd50c4-6c4a-4d06-b8d1-267822b902a3";
  body +=
      "<br><I>If you have any query then kindly reply to this email or contact us at support@yacab.in</I>";
  String username = 'ispsupport@YA CABed.com';
  String password = 'Atharva22082017';
  //also use for gmail smtp
  //final smtpServer = gmail(username, password);
  final domainSmtp = "smtpout.secureserver.net";
  final smtpServer = SmtpServer(domainSmtp,
      username: username, password: password, port: 465, ssl: true);
  //YA CABisp@gmail.com
  final message = Message()
    ..from = Address(username, 'YA CABED')
    ..recipients.add("YA CABisp@gmail.com")
    //..recipients=['ecomandiorganics@gmail.com','admin@ecomandi.com']
    //..recipients=['ayushpratik08041999@gmail.com','shrisolutions04@gmail.com']
    ..subject = 'YA CABED'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html =
        "<img src=$imagePath width=180><h1>$h1</h1>\n\n<h2>$h2</h2>\n\n<p>$body </p>";

  try {
    print(smtpServer.toString());
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } catch (e) {
    print('Message not sent.');
    print(e.toString());
  }
}
