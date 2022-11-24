import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'tabs/bookmarks.dart';

class BookmarksDetail extends StatefulWidget {
  final int index1;
  const BookmarksDetail({Key key, @required this.index1}) : super(key: key);

  @override
  State<BookmarksDetail> createState() => _BookmarksDetailState(index1);
}

String timeUntil(DateTime date) {
  return timeago.format(date, allowFromNow: true, locale: 'en');
}

class _BookmarksDetailState extends State<BookmarksDetail> {
  final int index2;
  _BookmarksDetailState(this.index2);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("bookmarks")
                .doc(FirebaseAuth.instance.currentUser.email)
                .collection("items")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Something is wrong"),
                );
              }
              snapshot.data == null ? 0 : snapshot.data.docs.length;
              DocumentSnapshot _documentSnapshot = snapshot.data.docs[index2];
              Future addBookmarks() async {
                final FirebaseAuth _auth = FirebaseAuth.instance;
                var currentUser = _auth.currentUser;
                CollectionReference _collectionRef =
                    FirebaseFirestore.instance.collection("bookmarks");
                return _collectionRef
                    .doc(currentUser.email)
                    .collection("items")
                    .doc()
                    .set({
                  "content": _documentSnapshot['content'],
                  "description": _documentSnapshot['description'],
                  "publishedAt": _documentSnapshot['publishedAt'],
                  "title": _documentSnapshot['title'],
                  "url": _documentSnapshot['url'],
                  "urlToImage": _documentSnapshot['urlToImage'],
                }).then((value) => print("Added to bookmarks"));
              }

              Future deleteBookmarks() async {
                final FirebaseAuth _auth = FirebaseAuth.instance;
                var currentUser = _auth.currentUser;
                CollectionReference _collectionRef =
                    FirebaseFirestore.instance.collection("bookmarks");
                return _collectionRef
                    .doc(currentUser.email)
                    .collection("items")
                    .where("title", isEqualTo: _documentSnapshot['title'])
                    .get()
                    .then((snapshot) {
                  for (DocumentSnapshot ds in snapshot.docs) {
                    ds.reference.delete();
                    // return Bookmarks();
                  }
                });
              }

              return Scaffold(
                bottomNavigationBar: GestureDetector(
                  onTap: () {
                    launch(_documentSnapshot['url']);
                  },
                  child: Container(
                    height: 48.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        gradient: LinearGradient(
                          colors: const [Color(0xFFf6501c), Color(0xFFff7e00)],
                          stops: const [0.0, 1.0],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Read More",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "SFPro-Bold",
                              fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                ),
                appBar: AppBar(
                  backgroundColor: Color(0xff191826),
                  elevation: 0,
                  actions: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("bookmarks")
                          .doc(FirebaseAuth.instance.currentUser.email)
                          .collection("items")
                          .where("title", isEqualTo: _documentSnapshot['title'])
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return Text("");
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: IconButton(
                              onPressed: () => snapshot.data.docs.length == 0
                                  ? addBookmarks()
                                  : deleteBookmarks(),
                              icon: snapshot.data.docs.length == 0
                                  ? Icon(
                                      Icons.bookmark_add_outlined,
                                      color: Colors.white,
                                    )
                                  : Icon(
                                      Icons.bookmark,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                body: ListView(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: FadeInImage.assetNetwork(
                          alignment: Alignment.topCenter,
                          placeholder: 'assets/placeholder.jpg',
                          image: _documentSnapshot['urlToImage'] == null
                              ? "https://www.thensg.gov.za/wp-content/uploads/2020/07/No_Image-3-scaled-1.jpg"
                              : _documentSnapshot['urlToImage'],
                          fit: BoxFit.cover,
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height * 1 / 3),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  _documentSnapshot['publishedAt']
                                      .substring(0, 10),
                                  style: TextStyle(
                                      color: Color(0xff191826),
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(_documentSnapshot['title'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20.0)),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            timeUntil(DateTime.parse(
                                _documentSnapshot['publishedAt'])),
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Html(
                            data: _documentSnapshot['content'] == null
                                ? "No news detail provided by the API"
                                : _documentSnapshot['content'],
                            renderNewlines: true,
                            defaultTextStyle: TextStyle(
                                fontSize: 14.0, color: Colors.black87),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }));
  }
}
