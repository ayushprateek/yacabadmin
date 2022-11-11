import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:yacabadmin/Components/Customs.dart';
import 'package:yacabadmin/Services/CustomLaunchURL.dart';
import 'package:yacabadmin/UI/Customers/EditCustomers.dart';

import 'package:yacabadmin/UI/Admin/AllBookings.dart';
class CustomersAccount extends StatefulWidget {
  String customer_id,name;
  CustomersAccount({
    required this.name,
    required this.customer_id
});
  @override
  _CustomersAccountState createState() => _CustomersAccountState();
}
class _CustomersAccountState extends State<CustomersAccount> {
  List customer=[];

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
        title: Text(widget.name==null?"Customers's Account":widget.name,
          style: TextStyle(
            fontWeight: FontWeight.w900,

          ),),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 50,),
              StreamBuilder(
                stream: firRef.child("Customers").orderByChild("customer_id").equalTo(widget.customer_id).onValue,
                builder: (context,snapshot){
                  if(!snapshot.hasData)
                    return Container();
                  customer.clear();
                  DatabaseEvent? databaseEvent = snapshot.data as DatabaseEvent;
                  databaseEvent.snapshot.children.forEach((event) {
                    customer.add(event.value as Map);
                  });
                  // try
                  // {
                  //   List<dynamic> values=snapshot.data.snapshot.value;
                  //   if(values!=null)
                  //     values.forEach((value) {
                  //       if(value!=null)
                  //
                  //         {
                  //           customers.add(value);
                  //         }
                  //
                  //     });
                  //
                  // }
                  // catch(e)
                  // {
                  //   Map<dynamic,dynamic> values=snapshot.data.snapshot.value;
                  //   if(values!=null)
                  //     values.forEach((key,value) {
                  //       if(value!=null)
                  //         {
                  //           customers.add(value);
                  //         }
                  //     });
                  // }
                  if(customer.length!=0)
                  {
                    return ListView.builder(
                        itemCount: customer.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context,index){
                          String status=customer[index]['status']=="True"?"Active":"Inactive";
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>EditCustomer(customer_id: customer[index]['customer_id'],name: customer[index]['name'],)));
                            },
                            child: Padding(
                              padding:  EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("Name : ${customer[index]['name']}",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w900,

                                                  ),),
                                                Text("Customer ID : ${customer[index]['customer_id']} ",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w900,

                                                  ),),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text("EMAIL",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,

                                                  ),),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text("${customer[index]['email']}",
                                                  style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.w500,

                                                  ),),

                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Image.asset(
                                              'images/Logo2.png',
                                              fit: BoxFit.cover,

                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),

                                      Divider(thickness: 1,color: Colors.grey,),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text("MOBILE",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,

                                        ),),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      InkWell(
                                        onTap: (){
                                          customLaunchURL("tel:+91${customer[index]['mobile']}");
                                        },
                                        child: Text("${customer[index]['mobile']}",
                                          style: TextStyle(
                                            fontSize: 19,
                                            color: HexColor("#4CD864"),
                                            fontWeight: FontWeight.w500,

                                          ),),
                                      ),

                                      SizedBox(
                                        height: 8,
                                      ),
                                      Divider(thickness: 1,color: Colors.grey,),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text("STATUS",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,

                                                ),),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Text(status,
                                                style: TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w500,

                                                ),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Align(
                                            alignment: Alignment.centerRight,
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
                                                  onPressed: () {

                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AllBookings(id: customer[index]['customer_id'],keyName: "customer_id"),));
                                                  },
                                                  child:Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text("View Bookings",
                                                      style: TextStyle(
                                                          color: Colors.white,

                                                          fontSize: 20
                                                      ),),
                                                  ),
                                                  color: HexColor("#35B736")
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  }
                  else
                  {
                    return Container();
                  }

                },
              ),
              SizedBox(height: 20,),

            ],
          ),
        ),
      ),
    );
  }
}
