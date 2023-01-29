import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_money_trading/models/ticker.dart';

class TickerNotification {
  final Ticker ticker;
  final String strategy;
  final String description;
  final double price;
  final Timestamp createdAt;

  TickerNotification({
    required this.ticker,
    required this.strategy,
    required this.description,
    required this.price,
    required this.createdAt,
  });

  Map<String, dynamic> get toJson => {
        "ticker": ticker.toJson,
        "strategy": strategy,
        "description": description,
        "price": price,
        "createdAt": createdAt,
      };

  factory TickerNotification.fromJson(dynamic jsonData) {
    return TickerNotification(
        ticker: Ticker.fromJson(jsonData["ticker"]),
        strategy: jsonData["strategy"],
        description: jsonData["description"],
        price: jsonData["price"],
        createdAt: jsonData["createdAt"]);
  }
}
