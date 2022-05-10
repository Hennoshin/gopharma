import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class User {
  User({
    required this.firstName,
    required this.lastName,
    Address? address,
    required this.credential,
    required this.isAdmin
  });

  firebase_auth.User credential;
  String firstName;
  String lastName;
  Address? address;
  final bool isAdmin;
}

class Address {
  Address({
    required this.address,
    required this.zipCode,
    required this.province,
    required this.country
  });

  String address;
  String province;
  String zipCode;
  String country;
}