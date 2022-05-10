import 'package:flutter/material.dart';
import 'package:gopharma/viewmodel/register_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import 'otp.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _confirmKey = GlobalKey<FormFieldState>();


  void _registerUser(BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return const Dialog(
            backgroundColor: Colors.white,
            child: CircularProgressIndicator(),
          );
        }
    );

    String? result = await context.read<RegisterViewModel>().registerUser();
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(TextSnackBar(text: result));
      Navigator.pop(context);
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade300,
       appBar: AppBar(
        title: const Text("Register"),
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
            Padding(
              padding: const EdgeInsets.only(
                left: 100, right: 100, top: 15, bottom: 0
              ),
              child: TextFormField(
                textAlign: TextAlign.center,      
                decoration: InputDecoration(
                     border: OutlineInputBorder( 
                       borderRadius: BorderRadius.circular(10.0),
                       borderSide: BorderSide.none
                       ),
                    filled: true,
                    fillColor: Colors.white,
                    label: const Center(
                      child: Text('Username'),
                    ),
                    hintText: 'Input Username'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 100, right: 100, top: 15, bottom: 0
              ),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    hintText: 'ex: johndoe@mail.domain'),
                validator: (_) {
                  return context.read<RegisterViewModel>().isEmailValid ? null : "Email is not valid";
                },
                onChanged: (value) {
                  context.read<RegisterViewModel>().setEmail(value);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 100, right: 100, top: 15, bottom: 20),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                validator: (_) {
                  return context.read<RegisterViewModel>().isPasswordValid ? null : "Password must be at least 8 characters";
                },
                onChanged: (value) {
                  context.read<RegisterViewModel>().setPassword(value);
                  _confirmKey.currentState!.validate();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 100, right: 100, top: 0, bottom: 40),
              child: TextFormField(
                key: _confirmKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      child: Text('Confirm Password'),
                    ),
                    hintText: 'Input Password Confirmation'),
                validator: (_) {
                  return context.read<RegisterViewModel>().isConfirmPasswordValid ? null : "Confirm password must be same";
                },
                onChanged: (value) {
                  context.read<RegisterViewModel>().setConfirmPassword(value);
                },
              ),
            ),
           
            SizedBox(
              height: 50,
              width: 250,
              child: Consumer<RegisterViewModel>(
                builder: (context, viewModel, child) {
                  final bool isButtonEnabled =
                      viewModel.isEmailValid &&
                      viewModel.isPasswordValid &&
                      viewModel.isConfirmPasswordValid;

                  return ElevatedButton(
                    onPressed: isButtonEnabled ? () {
                      _registerUser(context);
                    } : null,
                    style: ElevatedButton.styleFrom(primary: Colors.pink),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            TextButton(
              onPressed: (){
                 Navigator.push(
                      context, MaterialPageRoute(builder: (_) => LoginDemo()));
              },
              child: const Text(
                " Already have an account? Login Here",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

class TextSnackBar extends SnackBar {

  TextSnackBar({Key? key, required String text}) : super(key: key, content: Text(text));
}