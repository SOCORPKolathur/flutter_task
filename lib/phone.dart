import 'package:flutter/material.dart';
import 'package:flutter_task/verify.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneNumberVerification extends StatefulWidget {
  const PhoneNumberVerification({super.key});

  @override
  State<PhoneNumberVerification> createState() => _PhoneNumberVerificationState();
}

class _PhoneNumberVerificationState extends State<PhoneNumberVerification> {
  TextEditingController name = TextEditingController();
  TextEditingController date = TextEditingController();

  TextEditingController expired = TextEditingController();
  TextEditingController status = TextEditingController();

  String phonenumber = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          TextFormField(
            controller: name,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: "Name",
              hintText: "Enter the name",
            ),
          ),
          IntlPhoneField(
            decoration: InputDecoration(
              labelText: "Phone Number",
            ),
            initialCountryCode: "IN",
            onChanged: (phone){
             print(phone.completeNumber);
             setState(() {
               phonenumber = phone.completeNumber;
             });
            },
          ),
          TextFormField(
            controller: date,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: "Planed Date",
              hintText: "Enter the planed date",
            ),
          ),
          TextFormField(
            controller: status,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: "Status",
              hintText: "Enter the Status",
            ),
          ),
          TextFormField(
            controller: expired,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: "Expired ",
              hintText: "Enter the expired ",
            ),
          ),
          ElevatedButton(onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>
                    VerifyOtp(name.text, phonenumber, status.text, date.text, expired.text)));
          }, child: Text("Submit"))
        ],
      ),
    );
  }
}
