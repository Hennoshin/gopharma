import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gopharma/firebase_options.dart';
import 'package:provider/provider.dart';
import 'HomePage.dart';
import 'screens/register/signup.dart';
import 'routes_name.dart';
import 'viewmodel/register_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

Route<dynamic>? createRoute(settings) {
  switch (settings.name) {
    case routeHome:
      return MaterialPageRoute(builder: (context) => HomePage());
    case routeLogin:
      return MaterialPageRoute(builder: (context) => const LoginDemo());
    case routeRegister:
      return MaterialPageRoute(builder: (context) => ChangeNotifierProvider(create: (_) => RegisterViewModel(), child: const SignUp()));
  }

  return null;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final String initialRoute = routeLogin;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      initialRoute: initialRoute,
      onGenerateRoute: createRoute,
    );
  }
}


class LoginDemo extends StatefulWidget {
  const LoginDemo({Key? key}) : super(key: key);

  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
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
                child: Container(
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
                      child: Text('Username'),
                    ),
                    hintText: 'Input Username'),
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
              ),
            ),
            FlatButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, routeRegister);
              },
            
              child: Text(
                "Don't Have an Account? Register",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            FlatButton(
              onPressed: (){
                 //belum
              },
              child: Text(
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
              child: FlatButton(

              onPressed: (){
                 Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomePage()));
              },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}
