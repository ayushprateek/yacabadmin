import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:yacabadmin/Components/Customs.dart';
import 'package:yacabadmin/Components/GetImageURL.dart';
import 'package:yacabadmin/UI/Banners/AddBanners.dart';
import 'package:yacabadmin/UI/Banners/EditBanner.dart';

class Banners extends StatefulWidget {
  @override
  _BannersState createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  List banners = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Banners"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
                stream: firRef.child("Banners").onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  banners.clear();
                  DatabaseEvent? databaseEvent = snapshot.data as DatabaseEvent;
                  databaseEvent.snapshot.children.forEach((event) {
                    Map banner = event.value as Map;
                    if (banner['title'] != null) {
                      banners.add(banner);
                    }
                  });
                  // try
                  //     {
                  //       Map<dynamic,dynamic> values=snapshot.data.snapshot.value;
                  //       if(values!=null)
                  //         values.forEach((key, value) {
                  //           if(value!=null && value['title']!=null)
                  //             banners.add(value);
                  //         });
                  //     }
                  //     catch(e)
                  //     {
                  //       List<dynamic> values=snapshot.data.snapshot.value;
                  //       if(values!=null)
                  //         values.forEach((value) {
                  //           if(value!=null && value['title']!=null)
                  //             banners.add(value);
                  //         });
                  //     }
                  return ListView.builder(
                      itemCount: banners.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        Widget image = FutureBuilder(
                            future: imageurl(banners[index]['image']),
                            builder: (context, AsyncSnapshot<Url> snap) {
                              try {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    snap.data?.image ?? "",
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fill,
                                  ),
                                );
                              } catch (e) {
                                return Container();
                              }
                            });
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditBanner(
                                              title: "Home Banner",
                                              banner_id: banners[index]
                                                  ['banner_id'],
                                            )));
                              },
                              child: banners[index]['status'] == "True"
                                  ? image
                                  : Center(
                                      child: Stack(
                                        children: [
                                          //lists[index].image
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            foregroundDecoration: BoxDecoration(
                                              color: Colors.grey,
                                              backgroundBlendMode:
                                                  BlendMode.saturation,
                                            ),
                                            child: image,
                                          ),
                                          Positioned(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              color: Colors.red,
                                              child: Center(
                                                child: Text(
                                                  "Banner disabled",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            bottom: 0,
                                          )
                                        ],
                                      ),
                                    )),
                        );
                      });
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0XFF4CD864),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddBanners()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
