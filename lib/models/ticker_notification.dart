import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_money_trading/models/ticker.dart';

class TickerNotification {
  final Ticker ticker;
  final String strategy;
  final String description;
  final List<double> prices;
  final Timestamp createdAt;

  TickerNotification({
    required this.ticker,
    required this.strategy,
    required this.description,
    required this.prices,
    required this.createdAt,
  });

  Map<String, dynamic> get toJson => {
        "ticker": ticker.toJson,
        "strategy": strategy,
        "description": description,
        "prices": prices,
        "createdAt": createdAt,
      };

  factory TickerNotification.fromJson(dynamic jsonData) {
    return TickerNotification(
        ticker: Ticker.fromJson(jsonData["ticker"]),
        strategy: jsonData["strategy"],
        description: jsonData["description"],
        prices: jsonData["prices"],
        createdAt: jsonData["createdAt"]);
  }

  factory TickerNotification.fromDoc(DocumentSnapshot jsonData) {
    return TickerNotification(
      ticker: Ticker.fromJson(jsonData.get('ticker')),
      strategy: jsonData.get('strategy'),
      description: jsonData.get('description'),
      prices: List<double>.from(jsonData.get('prices')),
      createdAt: jsonData.get('createdAt'),
    );
  }
}
