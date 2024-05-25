import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/home_page.dart';
import 'package:flutterotpfield/flutterotpfield.dart';

class VerifyOtp extends StatefulWidget {
  String name;
  String date;
  String phonenumber;
  String expired;
  String status;
  VerifyOtp(this.name,this.phonenumber,this.status,this.date,this.expired);

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {

  @override
  void initState() {
    sendotp();
    // TODO: implement initState
    super.initState();
  }

  String otp = "";
  var verificationid;

  sendotp() async{

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phonenumber,
        verificationCompleted: (PhoneAuthCredential credential){
          print("Successfully verified");
        },
        verificationFailed: (FirebaseAuthException e){
          if (e.code == "Invalid Username") {
            print('The provided phone number is not valid.');
          }
        },
      codeSent: (String VerificationId, int? resendToken) {
        setState(() {
          verificationid = VerificationId;
        });
      },
      codeAutoRetrievalTimeout: (String VerificationId) {},
      timeout: Duration(milliseconds: 300),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FlutterOtpField(
            inputFieldLength: 6,
            spaceBetweenFields: 5,
            inputDecoration: InputDecoration(
                constraints: const BoxConstraints(maxHeight: 20),
                fillColor: Colors.transparent,
                filled: true,
                hintText: " ",
                counterText: "",
                hintStyle: TextStyle(
                    color: Color(0xff656565),
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Color(0xff37D1D3), width: 2.0),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Color(0xff37D1D3), width: 2.0),
                    borderRadius: BorderRadius.circular(10))),
            onValueChange: (String value) {
              print("otp changed $value");
            },
            onCompleted: (String value) {
              setState(() {
                otp = value;
              });
              print("otp  $value");
            },
          ),
          ElevatedButton(
              onPressed: () {
                verifyotp();
              },
              child: Text("Verify"))
        ],
      ),
    );
  }

  verifyotp() {
    FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential( 
        verificationId:verificationid , smsCode: otp)).then((value) {
      if(value.user != null){

        print(FirebaseAuth.instance.currentUser!.uid);
        FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).
        set({

          "name":widget.name,
          "phone":widget.phonenumber,
          "planeddate":widget.date,
          "status":widget.status,
          "expirydate":widget.expired,
          "userid":FirebaseAuth.instance.currentUser!.uid

        });

        Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>
                HomePage()));
      }
    });
  }
  
}
