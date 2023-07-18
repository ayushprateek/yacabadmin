import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:yacabadmin/UI/Admin/AllBookings.dart';
import 'package:yacabadmin/UI/Admin/AllDriversLocation.dart';
import 'package:yacabadmin/UI/Admin/SendEmailUI.dart';
import 'package:yacabadmin/UI/Banners/Banners.dart';
import 'package:yacabadmin/UI/Categories/Categories.dart';
import 'package:yacabadmin/UI/Customers/AllCustomers.dart';
import 'package:yacabadmin/UI/Drivers/AllDrivers.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              'Ya Cab Admin',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text('contact@yacab.com',
                style: TextStyle(fontWeight: FontWeight.bold)),
            currentAccountPicture: GestureDetector(
              child: new CircleAvatar(
                child: ClipRRect(
                  child: Image.asset('images/Logo2.png'),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            decoration: new BoxDecoration(),
          ),
          InkWell(
            child: ListTile(
              leading: Icon(
                MdiIcons.genderMale,
              ),
              trailing: Icon(
                MdiIcons.genderMale,
              ),
              title: Text('Dashboard'),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ExpansionTile(
            title: Text('Masters'),
            leading: Icon(
              MdiIcons.genderMale,
            ),
            children: [
              InkWell(
                child: ListTile(
                  leading: Icon(
                    MdiIcons.genderMale,
                  ),
                  trailing: Icon(
                    MdiIcons.genderMale,
                  ),
                  title: Text('Banners'),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Banners()));
                },
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(
                    MdiIcons.genderMale,
                  ),
                  trailing: Icon(
                    MdiIcons.genderMale,
                  ),
                  title: Text('Categories'),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Categories()));
                },
              ),
            ],
          ),
          InkWell(
            child: ListTile(
              leading: Icon(
                MdiIcons.genderMale,
              ),
              trailing: Icon(
                MdiIcons.genderMale,
              ),
              title: Text('Customers'),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => AllCustomers())));
            },
          ),
          ExpansionTile(
            title: Text('System'),
            leading: Icon(
              MdiIcons.genderMale,
            ),
            children: [
              InkWell(
                child: ListTile(
                  leading: Icon(
                    Icons.wallet_giftcard,
                  ),
                  trailing: Icon(
                    MdiIcons.genderMale,
                  ),
                  title: Text('Bookings'),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => AllBookings())));
                },
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                  ),
                  trailing: Icon(
                    MdiIcons.genderMale,
                  ),
                  title: Text('Drivers'),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => AllDrivers())));
                },
              ),
              // InkWell(
              //   child: ListTile(
              //     leading: Icon(
              //       Icons.person,
              //     ),
              //     trailing: Icon(
              //       MdiIcons.genderMale,
              //     ),
              //     title: Text("All Driver's Location"),
              //   ),
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: ((context) => AllDriversLocation())));
              //   },
              // ),
              // InkWell(
              //   child: ListTile(
              //     leading: Icon(Icons.person, ),
              //     trailing: Icon(FlutterIcons.rightcircle_ant, ),
              //     title: Text('Empty Requests'),
              //   ),
              //   onTap: (){
              //     Navigator.push(context, MaterialPageRoute(builder: ((context)=> EmptyRequest())));
              //   },
              // ),
              InkWell(
                child: ListTile(
                  leading: Icon(
                    Icons.email,
                  ),
                  trailing: Icon(
                    MdiIcons.genderMale,
                  ),
                  title: Text('Send Email'),
                ),
                onTap: () {
                  SendEmailUI.recipient = null;
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SendEmailUI()));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
