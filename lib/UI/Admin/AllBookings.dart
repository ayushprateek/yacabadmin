import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:yacabadmin/Components/Customs.dart';
import 'package:yacabadmin/UI/Admin/Booking.dart';

enum Filter { all, today, this_month, this_year }

Filter filter = Filter.all;

class AllBookings extends StatefulWidget {
  String? id, keyName;

  AllBookings({this.id, this.keyName});

  @override
  _AllBookingsState createState() => _AllBookingsState();
}

class _AllBookingsState extends State<AllBookings> {
  List bookings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: buttonColor,
      appBar: AppBar(
        backgroundColor: buttonColor,
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
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "All Bookings",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return FilterClass();
                },
              );
            },
            icon: Icon(Icons.filter),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
                stream: widget.id == null
                    ? firRef.child("Bookings").onValue
                    : firRef
                        .child("Bookings")
                        .orderByChild(widget.keyName!)
                        .equalTo(widget.id)
                        .onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  bookings.clear();
                  DatabaseEvent? databaseEvent = snapshot.data as DatabaseEvent;
                  databaseEvent.snapshot.children.forEach((event) {
                    bookings.add(event.value as Map);
                  });

                  // try
                  // {
                  //  List<dynamic> values=snapshot.data.snapshot.value;
                  //  if(values!=null)
                  //    values.forEach((value) {
                  //      if(value!=null && value['booking_id']!=null)
                  //        bookings.add(value);
                  //    });
                  // }
                  // catch(e)
                  //   {
                  //     Map<dynamic,dynamic> values=snapshot.data.snapshot.value;
                  //     if(values!=null)
                  //       values.forEach((key,value) {
                  //         if(value!=null && value['booking_id']!=null)
                  //           bookings.add(value);
                  //       });
                  //   }
                  return ListView.builder(
                      itemCount: bookings.length,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        index = bookings.length - (index + 1);

                        DateTime dateTime =
                            DateTime.parse(bookings[index]['date_added']);
                        int day, month, year;
                        day = dateTime.day;
                        month = dateTime.month;
                        year = dateTime.year;
                        String date = day.toString() +
                            "/" +
                            month.toString() +
                            "/" +
                            year.toString();
                        int this_day, this_month, this_year;
                        this_day = DateTime.now().day;
                        this_month = DateTime.now().month;
                        this_year = DateTime.now().year;

                        if (filter == Filter.today
                            ? day == this_day &&
                                month == this_month &&
                                year == this_year
                            : filter == Filter.this_month
                                ? month == this_month && year == this_year
                                : filter == Filter.this_year
                                    ? year == this_year
                                    : true) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Booking(
                                                  booking_id: bookings[index]
                                                      ['booking_id'],
                                                  date: date)));
                                    },
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "BOOKING ID ${bookings[index]['booking_id']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 20),
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "DATE $date",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black,
                                            fontSize: 16),
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return Container();
                      });
                }),
          ],
        ),
      ),
    );
  }
}

class FilterClass extends StatefulWidget {
  @override
  _FilterClassState createState() => _FilterClassState();
}

class _FilterClassState extends State<FilterClass> {
  //TODO:USE PROVIDER TO SET THE STATE
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                filter = Filter.all;
              });
            },
            child: Row(
              children: [
                Radio(
                  activeColor: buttonColor,
                  onChanged: (val) {
                    setState(() {
                      filter = Filter.all;
                    });
                  },
                  value: filter,
                  groupValue: Filter.all,
                ),
                Flexible(
                    child: Text(
                  'All',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                )),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                filter = Filter.today;
              });
            },
            child: Row(
              children: [
                Radio(
                  onChanged: (val) {
                    setState(() {
                      filter = Filter.today;
                    });
                  },
                  activeColor: buttonColor,
                  value: filter,
                  groupValue: Filter.today,
                ),
                Flexible(
                    child: Text(
                  'Today',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                )),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                filter = Filter.this_month;
              });
            },
            child: Row(
              children: [
                Radio(
                  onChanged: (val) {
                    setState(() {
                      filter = Filter.this_month;
                    });
                  },
                  activeColor: buttonColor,
                  value: filter,
                  groupValue: Filter.this_month,
                ),
                Flexible(
                    child: Text(
                  'This Month',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                )),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                filter = Filter.this_year;
              });
            },
            child: Row(
              children: [
                Radio(
                  onChanged: (val) {
                    setState(() {
                      filter = Filter.this_year;
                    });
                  },
                  activeColor: buttonColor,
                  value: filter,
                  groupValue: Filter.this_year,
                ),
                Flexible(
                    child: Text(
                  'This Year',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
