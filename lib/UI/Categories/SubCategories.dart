import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:yacabadmin/Components/Customs.dart';
import 'package:yacabadmin/Components/GetImageURL.dart';
import 'package:yacabadmin/UI/Categories/AddCategory.dart';
import 'package:yacabadmin/UI/Categories/EditSubcategories.dart';
import 'package:yacabadmin/UI/Categories/Rates.dart';

class SubCategories extends StatefulWidget {
  String category_id, name;

  SubCategories({required this.category_id, required this.name});

  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  List categories = [];

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
          widget.name,
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              StreamBuilder(
                stream: firRef
                    .child("Categories")
                    .orderByChild("parent_id")
                    .equalTo(widget.category_id)
                    .onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  categories.clear();
                  DatabaseEvent? databaseEvent = snapshot.data as DatabaseEvent;
                  databaseEvent.snapshot.children.forEach((event) {
                    categories.add(event.value as Map);
                  });
                  // try{
                  //   List<dynamic> values=snapshot.data.snapshot.value;
                  //   if(values!=null)
                  //     values.forEach((value) {
                  //       if(value!=null)
                  //         categories.add(value);
                  //     });
                  // }
                  // catch(e)
                  // {
                  //   Map<dynamic,dynamic> values=snapshot.data.snapshot.value;
                  //   if(values!=null)
                  //     values.forEach((key,value) {
                  //       if(value!=null)
                  //         categories.add(value);
                  //     });
                  // }
                  if (categories.length != 0)
                    return ListView.builder(
                        itemCount: categories.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          String status = categories[index]['status'] == "True"
                              ? "Active"
                              : "Inactive";
                          Widget image = FutureBuilder(
                              future: imageurl(categories[index]['image']),
                              builder: (context, AsyncSnapshot<Url> snap) {
                                if (!snap.hasData)
                                  return Image.asset(
                                    'images/Logo2.png',
                                    fit: BoxFit.cover,
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    width: MediaQuery.of(context).size.width,
                                  );
                                try {
                                  return Image.network(
                                    snap.data?.image,
                                    fit: BoxFit.cover,
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    width: MediaQuery.of(context).size.width,
                                  );
                                } catch (e) {
                                  return Image.asset(
                                    'images/Logo2.png',
                                    fit: BoxFit.cover,
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    width: MediaQuery.of(context).size.width,
                                  );
                                }
                              });
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: InkWell(
                              onTap: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>EditSubcategories(category_id: categories[index]['category_id'],name: categories[index]['name'],)));
                                showAnimatedDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return ClassicGeneralDialogWidget(
                                      titleText: '',
                                      contentText: 'Please select',
                                      negativeText: 'Edit',
                                      onNegativeClick: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditSubcategories(
                                                      category_id:
                                                          categories[index]
                                                              ['category_id'],
                                                      name: categories[index]
                                                          ['name'],
                                                    )));
                                      },
                                      positiveText: "View Subcategories",
                                      onPositiveClick: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Rates(
                                                      category_id:
                                                          categories[index]
                                                              ['category_id'],
                                                      name: categories[index]
                                                          ['name'],
                                                    )));
                                      },
                                    );
                                  },
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height / 5,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: image,
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Spacer(),
                                                Flexible(
                                                  flex: 2,
                                                  child: Text(
                                                    categories[index]['name'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 23),
                                                  ),
                                                ),
                                                Spacer(),
                                                Flexible(
                                                  child: Text(
                                                    status,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  else
                    return Container();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        tooltip: "Add a category",
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddCategory(
                        parent_id: widget.category_id,
                      )));
        },
        child: Icon(
          Icons.add,
          color: buttonColor,
        ),
      ),
    );
  }
}
