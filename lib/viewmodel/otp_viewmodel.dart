import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class OTPViewModel extends ChangeNotifier {
  bool _isVerificationDone = false;
  late Timer _listener;

  bool get isVerificationDone => _isVerificationDone;

  // TODO: Move to repo/service class, not ViewModel responsibility
  Future<bool> checkEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }
    await user.reload();

    return user.emailVerified;
  }

  void _listenToVerification(Timer timer) async {
    _isVerificationDone = await checkEmailVerification();
    if (!_isVerificationDone) {
      return;
    }

    timer.cancel();
    notifyListeners();
  }

  OTPViewModel() {
    _listener = Timer.periodic(const Duration(seconds: 5), _listenToVerification);
  }
}