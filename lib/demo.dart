import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  @override
  void initState() {
    getdata();
    //subscribe();
    // TODO: implement initState
    super.initState();
  }

  bool status = false;
  DateTime date1 = DateTime.now();
  DateTime date2 = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo Page"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(docid)
              .snapshots(),
          builder: (context, snopshot) {

            if (diff.inDays > 0) {
              status = true;
            } else {
              status = false;
            }

            return Column(
              children: [
              Container(
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
            ),
                Text("You have remaining in : ${diff.inDays.toString()} Days"),
              ],
            );
          }),
    );
  }

  String? docid;
  String expiry = "";
  Duration diff = Duration(seconds: 0);
  getdata() async {
    var doc = await FirebaseFirestore.instance.collection("Users").get();
    for (int i = 0; i < doc.docs.length; i++) {
      if (doc.docs[i]["userid"] == FirebaseAuth.instance.currentUser!.uid) {
        setState(() {
          docid = doc.docs[i].id;
          expiry = doc.docs[i]["expirydate"];
          date1 = DateFormat("dd/MM/yyyy").parse("${expiry}");
          diff = date1.difference(date2);
        });
      }
    }
   // document();
  }

  // document() {
  //
  //   if(diff.inDays > 0) {
  //     status= true;
  //   } else {
  //     status= false;
  //   }
  //
  //   FirebaseFirestore.instance.collection("Users").doc(docid).update({
  //     "status":status,
  //   });
  // }

  // subscribe(){
  //   var newdate = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day + 90);
  //   FirebaseFirestore.instance.collection("Users").doc(docId).update({
  //     "planeddate":"${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
  //     "expirydate":"${newdate.day}/${newdate.month}/${newdate .year}",
  //     "status": true
  //   });
  // }

}
