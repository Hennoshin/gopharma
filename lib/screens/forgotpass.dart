import 'package:flutter/material.dart';
import 'package:gopharma/screens/register/signup.dart';
import 'package:gopharma/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  void _resetPassword(BuildContext context) async {
    await context.read<LoginViewModel>().resetPassword();

    ScaffoldMessenger.of(context).showSnackBar(TextSnackBar(text: "Reset email has been sent"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade300,
      appBar: AppBar(
        title: const Text("Forgot Password"),
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
                  left: 100, right: 100, top: 15, bottom: 0),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 100, right: 100, top: 15, bottom: 0),
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white,
                    label: const Center(
                      child: Text('Put Your Email Here to reset your Password'),
                    ),
                    hintText: 'ex: johndoe@mail.domain'),
                onChanged: (value) {
                  context.read<LoginViewModel>().email = value;
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 100, right: 100, top: 15, bottom: 20),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 100, right: 100, top: 0, bottom: 40),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.pink, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  _resetPassword(context);
                },
                child: const Text(
                  'Reset Password',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
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
