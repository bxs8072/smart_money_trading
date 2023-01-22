import 'dart:convert';

import 'package:http/http.dart';

class StripeApi {
  static const String baseURL = "http://10.0.2.2:4242/api/v1";
  Client http = Client();

  Future<Map<String, dynamic>> getCheckoutSession(
      {required String plan, required String customerId}) async {
    String url = "$baseURL/sessions";

    try {
      Response response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "plan": plan,
          "customerId": customerId,
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );

      print(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      rethrow;
    }
  }
}
