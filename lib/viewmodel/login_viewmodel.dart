import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gopharma/controller/user_controller.dart';
import 'package:gopharma/utils/app_color.dart';

// TODO: Reset the _errorMessage when there's no error, consider adding hasError instead
class LoginViewModel extends ChangeNotifier {
  UserController userController = Get.find<UserController>();

  String? _email;
  String? _password;
  String? _errorMessage;

  String? get email => _email;
  String? get password => _password;
  String? get errorMessage => _errorMessage;

  set email(email) {
    _email = email;

    notifyListeners();
  }

  set password(password) {
    _password = password;


    notifyListeners();
  }

  // TODO: Refactor and move to repo/service
  Future<void> login() async {
    Get.focusScope!.unfocus();
    _errorMessage = null;

    if ((_email == null) || (_password == null)) {
      _errorMessage = "Email and password cannot be empty";
    }
    else {
      try {
        var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email!, password: password!);
        CollectionReference user = FirebaseFirestore.instance.collection('users');
        var data = await user.doc(_email).get();
        if (data.data() != null) {
          Map<String, dynamic> hasil = data.data() as Map<String, dynamic>;
          if (hasil['role'] == 'admin') {
            //GO TO ADMIN
            print("GO TO ADMIN");
            userController.name.value = hasil['name'] ?? '';
            userController.email.value = hasil['email'] ?? '';
            userController.role.value = hasil['role'] ?? '';
            userController.image.value = hasil['image'] ?? '';
            _errorMessage = 'isAdmin';

          } else {
            if (!credential.user!.emailVerified) {
              Get.defaultDialog(
                  title: "Error",
                  middleText: 'Email blm diverifikasi',
                  onConfirm: () async {
                    await credential.user!.sendEmailVerification();
                    Get.back();
                  },
                  textConfirm: "Kirim Ulang",
                  backgroundColor: Colors.pink);
              Get.snackbar("Info", "Email verifikasi telah dikirim");
            } else {
              print("GO TO HOME");
              userController.name.value = hasil['name'] ?? '';
              userController.email.value = hasil['email'] ?? '';
              userController.role.value = hasil['role'] ?? '';
              userController.image.value = hasil['image'] ?? '';
              userController.address.value = hasil['address'] ?? '';
              _errorMessage = 'isUser';
            }
          }
          final token = await FirebaseMessaging.instance.getToken();
          hasil["token"] = token;

          user.doc(_email).set(hasil);
        }else{
          print("blm ada di doc");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          _errorMessage = 'Email tidak terdaftar';
        } else if (e.code == 'wrong-password') {
          _errorMessage = 'Password Salah';
        } else if (e.code == 'invalid-email') {
          _errorMessage = 'Format email salah';
        } else {
          _errorMessage = e.code;
        }
      }
    }

    notifyListeners();
  }

  // TODO: Refactor and move to repo/service
  Future<void> resetPassword() async {
    if (_email == null) {
      _errorMessage = "Email cannot be empty";

      notifyListeners();
      return;
    }
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _email!);
  }
}