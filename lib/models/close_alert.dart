import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_money_trading/models/ticker.dart';

class CloseAlert {
  final String? docId;
  final Ticker ticker;
  final String strategy;
  final String type;
  final String description;
  final List<double> prices;
  final double totalCost;
  final double pnl;
  final String optionType;
  final Timestamp createdAt;
  final Timestamp expiresAt;

  CloseAlert(
      {this.docId,
      required this.ticker,
      required this.strategy,
      required this.type,
      required this.description,
      required this.prices,
      required this.totalCost,
      required this.pnl,
      required this.optionType,
      required this.createdAt,
      required this.expiresAt});

  Map<String, dynamic> get toJson => {
        "ticker": ticker.toJson,
        "strategy": strategy,
        "type": type,
        "description": description,
        "prices": prices,
        "pnl": pnl,
        "totalCost": totalCost,
        "optionType": optionType,
        "createdAt": createdAt,
        "expiresAt": expiresAt,
      };

  factory CloseAlert.fromJson(dynamic jsonData) {
    return CloseAlert(
      ticker: Ticker.fromJson(jsonData["ticker"]),
      strategy: jsonData["strategy"],
      type: jsonData["type"],
      description: jsonData["description"],
      prices: List<double>.from(jsonData["prices"]),
      totalCost: double.parse(jsonData["totalCost"].toString()),
      pnl: double.parse(jsonData["pnl"].toString()),
      optionType: jsonData["optionType"],
      createdAt: jsonData["createdAt"],
      expiresAt: jsonData["expiresAt"],
    );
  }

  factory CloseAlert.fromDoc(DocumentSnapshot jsonData) {
    return CloseAlert(
      docId: jsonData.id,
      ticker: Ticker.fromJson(jsonData["ticker"]),
      strategy: jsonData["strategy"],
      type: jsonData["type"],
      description: jsonData["description"],
      prices: List<double>.from(jsonData["prices"]),
      totalCost: double.parse(jsonData["totalCost"].toString()),
      pnl: double.parse(jsonData["pnl"].toString()),
      optionType: jsonData["optionType"],
      createdAt: jsonData["createdAt"],
      expiresAt: jsonData["expiresAt"],
    );
  }
}
