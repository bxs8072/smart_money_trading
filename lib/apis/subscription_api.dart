import 'dart:convert';

import 'package:http/http.dart';
import 'package:smart_money_trading/models/subscription.dart';

class SubscriptionApi {
  static const String baseURL = "http://10.0.2.2:4242/api/v1";
  Client http = Client();

  Future<List<Subscription>> getSubscriptions(
      {required String customerId}) async {
    String url = "$baseURL/customers/subscriptions/$customerId";
    try {
      Response response = await http.get(Uri.parse(url));
      List<Subscription> result = [];
      for (Map<String, dynamic> item in json.decode(response.body)) {
        result.add(Subscription.fromJson(item));
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
