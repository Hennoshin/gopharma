class RegistrationForm {
  String? _email;
  String? _password, _confirmPassword;

  String? _firstName, _lastName;
  String? _address;

  bool setEmail(String email) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");

    if (!emailRegex.hasMatch(email)) {
      return false;
    }

    _email = email;
    return true;
  }

  bool setPassword(String password) {
    if (password.length < 8) {
      return false;
    }

    _password = password;
    return true;
  }

  bool setConfirmPassword(String confirmPassword) {
    if (confirmPassword != _password) {
      return false;
    }

    _confirmPassword = confirmPassword;
    return true;
  }

  set address(value) => _address;

  String? get email => _email;
  String? get password => _password;
  String? get confirmPassword => _confirmPassword;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get address => _address;
}