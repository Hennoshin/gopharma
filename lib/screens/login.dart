import 'package:flutter/material.dart';
import 'package:gopharma/screens/register/signup.dart';
import 'package:gopharma/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';

import '../routes_name.dart';

class LoginDemo extends StatefulWidget {
  const LoginDemo({Key? key}) : super(key: key);

  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  void _login(BuildContext context) async {
    await context.read<LoginViewModel>().login();

    String? error = context.read<LoginViewModel>().errorMessage;

    print("error");
    print(error.toString());

    if(error == 'isAdmin'){
      Navigator.pushReplacementNamed(context, routeHomeAdmin);
    }
    else if(error == 'isUser'){
      Navigator.pushReplacementNamed(context, routeHome);
    }
    else{
      if (error != null) {

        ScaffoldMessenger.of(context).showSnackBar(TextSnackBar(text: error));
        return;
      }
    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade300,

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: SizedBox(
                    width: 400,
                    height: 300,
                    child: Image.asset('asset/images/login.png')),

              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 100, right: 100, top: 15, bottom: 0
              ),
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    label: const Center(
                      child: Text('Email'),
                    ),
                    hintText: 'Input Email'),
                onChanged: (value) {
                  context.read<LoginViewModel>().email = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 100, right: 100, top: 15, bottom: 20),
              child: TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    label: const Center(
                      child: Text('Password'),
                    ),
                    hintText: 'Input Password'),
                onChanged: (value) {
                  context.read<LoginViewModel>().password = value;
                },
              ),
            ),
            TextButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, routeRegister);
              },

              child: const Text(
                "Don't Have an Account? Register",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, routeResetPassword);
              },
              child: const Text(
                'Forgot Your Password',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  color: Colors.pink, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: (){
                  _login(context);
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}