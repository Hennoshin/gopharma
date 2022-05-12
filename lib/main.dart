import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gopharma/ProfileScreen.dart';
import 'package:gopharma/firebase_options.dart';
import 'package:gopharma/screens/forgotpass.dart';
import 'package:gopharma/screens/login.dart';
import 'package:gopharma/screens/register/otp.dart';
import 'package:gopharma/viewmodel/login_viewmodel.dart';
import 'package:gopharma/viewmodel/otp_viewmodel.dart';
import 'package:provider/provider.dart';
import 'HomePage.dart';
import 'controller/auth_controller.dart';
import 'screens/register/signup.dart';
import 'routes_name.dart';
import 'viewmodel/register_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await AppDependecies.init();
  runApp(const MyApp());
}

Route<dynamic>? createRoute(settings) {
  switch (settings.name) {
    case routeHome:
      return MaterialPageRoute(builder: (context) => HomePage());
    case routeLogin:
      return MaterialPageRoute(builder: (context) => ChangeNotifierProvider(create: (_) => LoginViewModel(), child: const LoginDemo()));
    case routeResetPassword:
      return MaterialPageRoute(builder: (context) => ChangeNotifierProvider(create: (_) => LoginViewModel(), child: const ForgotPass()));
    case routeRegister:
      return MaterialPageRoute(builder: (context) => ChangeNotifierProvider(create: (_) => RegisterViewModel(), child: const SignUp()));
    case routeOTP:
      return MaterialPageRoute(builder: (context) => ChangeNotifierProvider(create: (_) => OTPViewModel(), child: const OTP()));
    case routeProfile:
      return MaterialPageRoute(builder: (context) => ProfileScreen());
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

class AppDependecies {
  static  Future<void> init() async{
    Get.lazyPut(() => AuthController());
  }
}

