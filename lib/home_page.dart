import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/check_page.dart';
import 'package:flutter_task/demo.dart';
import 'package:flutter_task/view_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {

  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    getDocId();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => ViewPage()));
              },
              child: Text("View")),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {

                subscribe();
              },
              child: Text("Subscribe")),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => CheckPage()));
              },
              child: Text("Check")),
        ],
      ),
    );
  }
  String docId = "";

  subscribe(){
    var newdate = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day + 90);
    FirebaseFirestore.instance.collection("Users").doc(docId).update({
      "planeddate":"${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      "expirydate":"${newdate.day}/${newdate.month}/${newdate .year}",
      "status": true
    });
  }
  getDocId() async {
    var user = await FirebaseFirestore.instance.collection("Users").get();
    for (int i = 0; i < user.docs.length; i++) {
      if (user.docs[i]["userid"] == FirebaseAuth.instance.currentUser!.uid) {
        setState(() {
          docId = user.docs[i].id;

        });
      }
    }
  }

}
