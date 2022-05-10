import 'package:flutter/material.dart';
import '../../main.dart';
import 'signup.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';


class OTP extends StatefulWidget {
  @override
  _OTP createState() => _OTP();
}

class _OTP extends State<OTP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade300,
       appBar: AppBar(
        title: Text("OTP Verification"),
        backgroundColor: Colors.cyan.shade400,
      ),
      
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: Container(
                    width: 100,
                    height: 100,
                    child: Image.asset('asset/images/login.png')),
                    
              ),
            ),
             Padding(
              padding: const EdgeInsets.only(
                left: 100, right: 100, top: 15, bottom: 0
              ),
              
              child: Center(
                child: Container(
                  child: Text("We've sent OTP Number Through Your Input Email",
                  textAlign: TextAlign.center),
                ),
              ),
             ),
            Padding(
              padding: const EdgeInsets.only(
                left: 100, right: 100, top: 15, bottom: 30
              ),
              // child: TextField(
              //   textAlign: TextAlign.center,      
              //   decoration: InputDecoration(
              //        border: OutlineInputBorder( 
              //          borderRadius: BorderRadius.circular(10.0),
              //          borderSide: BorderSide.none
              //          ),
              //       filled: true,
              //       fillColor: Colors.white,
              //       label: const Center(
              //         child: Text('Username'),
              //       ),
              //       hintText: 'Input Username'),
              // ),
              child: OTPTextField(
                  length: 6,
                  width: MediaQuery.of(context).size.width,
                  
                  style: TextStyle(
                    fontSize: 17
                  ),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.underline,
                  onCompleted: (pin) {
                    print("Completed: " + pin);
                  },
                ),
            ),
           Padding(
             padding: const EdgeInsets.only(
               bottom: 10
             ),
           ), 
           FlatButton(
              onPressed: (){
                 Navigator.push(
                      context, MaterialPageRoute(builder: (_) => SignUp ()));
              },
              child: Text(
                " Wrong Email? Change Email",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            Padding(
             padding: const EdgeInsets.only(
               bottom: 130
             ),
           ), 
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.pink, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
               onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => LoginDemo()));
                },
                child: Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            
            
          ],
        ),
      ),
    );
  }
}
