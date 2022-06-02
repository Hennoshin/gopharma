import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gopharma/ProfileScreen.dart';
import 'package:gopharma/controller/user_controller.dart';
import 'package:gopharma/firebase_options.dart';
import 'package:gopharma/screens/admin/add_barang.dart';
import 'package:gopharma/screens/admin/admin_page.dart';
import 'package:gopharma/screens/admin/controller/barang_controller.dart';
import 'package:gopharma/screens/admin/controller/konfirmasi_pembelian_controller.dart';
import 'package:gopharma/screens/admin/edit_barang.dart';
import 'package:gopharma/screens/forgotpass.dart';
import 'package:gopharma/screens/home/controller/carttab_controller.dart';
import 'package:gopharma/screens/home/controller/historytab_controller.dart';
import 'package:gopharma/screens/home/controller/hometab_controller.dart';
import 'package:gopharma/screens/home/detail_historytab_page.dart';
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
      return MaterialPageRoute(builder: (context) => const HomePage());
    case routeHomeAdmin:
      return MaterialPageRoute(builder: (context) => const AdminPage());
    case routeAddBarang:
      return MaterialPageRoute(builder: (context) => const AddBarang());
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
    return GetMaterialApp(
      debugShowCheckedModeBanner: true,
      initialRoute: initialRoute,
      onGenerateRoute: createRoute,
    );
  }
}

class AppDependecies {
  static  Future<void> init() async{
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => UserController());
    Get.lazyPut(() => BarangController());
    Get.lazyPut(() => HomeTabController());
    Get.lazyPut(() => CartController());
    Get.lazyPut(() => HistoryTabController());
    Get.lazyPut(() => KonfirmasiPembelianController());
  }
}

