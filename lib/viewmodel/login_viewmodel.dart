import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// TODO: Reset the _errorMessage when there's no error, consider adding hasError instead
class LoginViewModel extends ChangeNotifier {
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
    _errorMessage = null;

    if ((_email == null) || (_password == null)) {
      _errorMessage = "Email and password cannot be empty";
    }
    else {
      try {
        var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email!, password: password!);
      } on FirebaseAuthException catch (error) {
        _errorMessage = error.message;

        if (error.message == "invalid-email") {
          _errorMessage = "Email is not valid";
        }
        if ((error.message == "wrong-password") || (error.message == "user-not-found")) {
          _errorMessage = "Email and password does not match any credential";
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