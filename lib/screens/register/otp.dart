import 'package:flutter/material.dart';
import 'package:gopharma/routes_name.dart';
import '../../viewmodel/otp_viewmodel.dart';
import 'package:provider/provider.dart';
import 'signup.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';


class OTP extends StatelessWidget {
  const OTP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade300,
       appBar: AppBar(
        title: const Text("OTP Verification"),
        backgroundColor: Colors.cyan.shade400,
      ),
      
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset('asset/images/login.png')),
                    
              ),
            ),
             const Padding(
              padding: EdgeInsets.only(
                left: 100, right: 100, top: 15, bottom: 0
              ),
              
              child: Center(
                child: Text("We've sent OTP Number Through Your Input Email",
                textAlign: TextAlign.center),
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
                  
                  style: const TextStyle(
                    fontSize: 17
                  ),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.underline,
                  onCompleted: (pin) {
                    print("Completed: " + pin);
                  },
                ),
            ),
           const Padding(
             padding: EdgeInsets.only(
               bottom: 10
             ),
           ), 
           TextButton(
              onPressed: (){
                 Navigator.push(
                      context, MaterialPageRoute(builder: (_) => SignUp ()));
              },
              child: const Text(
                " Wrong Email? Change Email",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            const Padding(
             padding: EdgeInsets.only(
               bottom: 130
             ),
           ), 
            SizedBox(
              height: 50,
              width: 250,
              child: Consumer<OTPViewModel>(
                builder: (context, viewModel, child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.pink),
                    onPressed: viewModel.isVerificationDone ? () {
                      Navigator.pushReplacementNamed(context, routeHome);
                    } : null,
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  );
                },
              )
            ),
            const SizedBox(
              height: 40,
            ),
            
            
          ],
        ),
      ),
    );
  }
}
