import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({Key? key}) : super(key: key);

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  String? docId;
  bool status = false;

  @override
  void initState() {

    super.initState();
    getDocId();


  }

  doc() {
    print(status);
    if (difference.inDays > 0) {
      status = true;
    } else {
      status = false;
    }
    FirebaseFirestore.instance.collection("Users").doc(docId).update({
      "status": status,
    });
  }

  DateTime startdate = DateTime.now();
  DateTime enddate = DateFormat("dd/MM/yyyy").parse("12/04/2024");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Page"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(docId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (difference.inDays > 0) {
            status = true;
          } else {
            status = false;
          }

          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: status
                ? Column(
                    children: [
                      Text("You are a subscriber"),
                      Image.asset('assets/welcome.jpg'),
                    ],
                  )
                : Text("Your subscription is out of date"),
          );
        },
      ),
    );
  }

  String expiry = "";
  Duration difference = Duration(seconds: 0);
  getDocId() async {
    var user = await FirebaseFirestore.instance.collection("Users").get();
    for (int i = 0; i < user.docs.length; i++) {
      if (user.docs[i]["userid"] == FirebaseAuth.instance.currentUser!.uid) {
        setState(() {
          docId = user.docs[i].id;
          print(user.docs[i].id);
          expiry = user.docs[i]["expirydate"];
          startdate = DateFormat("dd/MM/yyyy").parse("${expiry}");
          difference = startdate.difference(enddate);
        });
      }
    }
    doc();
  }
}
