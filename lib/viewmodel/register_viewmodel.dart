import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../model/registration_form.dart';

class RegisterViewModel extends ChangeNotifier {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  RegistrationForm form = RegistrationForm();

  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;

  bool get isEmailValid => _isEmailValid;
  bool get isPasswordValid => _isPasswordValid;
  bool get isConfirmPasswordValid => _isConfirmPasswordValid;

  bool _validateForm() {
    return _isEmailValid && _isPasswordValid && _isConfirmPasswordValid;
  }

  void setEmail(String email) {
    _isEmailValid = form.setEmail(email);

    notifyListeners();
  }

  void setPassword(String password) {
    _isPasswordValid = form.setPassword(password);
    _isConfirmPasswordValid = form.setConfirmPassword(form.confirmPassword ?? "");

    notifyListeners();
  }

  void setConfirmPassword(String confirmPassword) {
    _isConfirmPasswordValid = form.setConfirmPassword(confirmPassword);

    notifyListeners();
  }

  void setAddress(String address) {
    form.address = address;

    notifyListeners();
  }

  Future<String?> registerUser() async {

    // TODO: Move this operation to repository, not supposed to be ViewModel responsibility
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final credential = await auth.createUserWithEmailAndPassword(email: form.email!, password: form.password!);
      if(credential.user != null && !credential.user!.emailVerified){
        await credential.user!.sendEmailVerification();
        //add users doc by email
        users.doc(form.email!).set({
          "name" : form.firstName,
          "email" : form.email,
          "lastName" : form.lastName,
          "address" : form.address,
          "role" : "user",
          "image" : "no_image.jpg"
        });
      }

    } on FirebaseAuthException catch (error) {
      return Future.value(error.message);
    }

    // FirebaseAuth.instance.currentUser!.sendEmailVerification();
    return Future.value(null);
  }
}