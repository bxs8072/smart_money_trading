import 'dart:convert';

import 'package:http/http.dart';

class StripeApi {
  static const String baseURL = "http://10.0.2.2:4242/api/v1";
  Client http = Client();

  Future<Map<String, dynamic>> getCheckoutSession(
      {required String plan, required String customerId}) async {
    String url = "$baseURL/customers/checkout-session/$plan/$customerId";
    const headers = {"Content-Type": "application/json"};
    try {
      Response response = await http.get(Uri.parse(url), headers: headers);
      return jsonDecode(response.body);
    } catch (e) {
      rethrow;
    }
  }
}
