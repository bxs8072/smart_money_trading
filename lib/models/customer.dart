import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_money_trading/models/address.dart';

class Customer {
  final String firstname;
  final String? middlename;
  final String lastname;
  final String email;
  final String phone;
  final Timestamp dateOfBirth;
  final String firebaseUID;
  final String stripeID;
  final Address address;

  Customer({
    required this.firstname,
    required this.middlename,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.firebaseUID,
    required this.stripeID,
    required this.address,
  });

  Map<String, dynamic> get toJson => {
        "firstname": firstname,
        "middlename": middlename ?? "",
        "lastname": lastname,
        "email": email,
        "phone": phone,
        "dateOfBirth": dateOfBirth,
        "firebaseUID": firebaseUID,
        "stripeID": stripeID,
        "address": address.toJson,
      };

  factory Customer.fromJson(dynamic jsonData) {
    return Customer(
      firstname: jsonData["firstname"],
      middlename: jsonData["middlename"],
      lastname: jsonData["lastname"],
      email: jsonData["email"],
      phone: jsonData["phone"],
      dateOfBirth: jsonData["dateOfBirth"],
      firebaseUID: jsonData["firebaseUID"],
      stripeID: jsonData["stripeID"],
      address: Address.fromJson(jsonData["address"]),
    );
  }
}
