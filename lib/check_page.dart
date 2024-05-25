import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckPage extends StatefulWidget {
  const CheckPage({Key? key}) : super(key: key);

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  @override
  void initState() {
    getdocid();
    // TODO: implement initState
    super.initState();
  }

  DateTime startdate = DateTime.now();
  DateTime enddate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Difference between DateTime"),
          backgroundColor: Colors.redAccent,
        ),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          child: Column(children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(docid)
                    .snapshots(),
                builder: (context, snopshots) {
                  return Center(
                    child: Column(
                      children: [
                        Text("Planed date: ${planeddate}"),
                        Text("Expiry Date : ${expiry}"),
                        Text(
                            "You have remaining in : ${diff.inDays.toString()} Days"),
                      ],
                    ),
                  );
                }),
          ]),
        ));
  }

  String planeddate = "";
  String date = "";
  String expiry = "";
  String docid = "";
  Duration diff = Duration(seconds: 0);
  getdocid() async {
    var user = await FirebaseFirestore.instance.collection("Users").get();
    for (int i = 0; i < user.docs.length; i++) {
      if (user.docs[i]["userid"] == FirebaseAuth.instance.currentUser!.uid) {
        setState(() {
          docid = user.docs[i].id;
          planeddate = user.docs[i]["planeddate"];
          expiry = user.docs[i]["expirydate"];
          startdate = DateFormat("dd/MM/yyyy").parse("${expiry}");
          diff = startdate.difference(enddate);
        });
        print(diff.inDays);
      }
    }
  }
}
