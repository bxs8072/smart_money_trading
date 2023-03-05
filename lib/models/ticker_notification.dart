import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_money_trading/models/ticker.dart';

class TickerNotification {
  final String? docId;
  final Ticker ticker;
  final String strategy;
  final String description;
  final List<double> prices;
  final double totalCost;
  final String optionType;
  final Timestamp createdAt;
  final Timestamp expiresAt;

  TickerNotification(
      {this.docId,
      required this.ticker,
      required this.strategy,
      required this.description,
      required this.prices,
      required this.totalCost,
      required this.optionType,
      required this.createdAt,
      required this.expiresAt});

  Map<String, dynamic> get toJson => {
        "ticker": ticker.toJson,
        "strategy": strategy,
        "description": description,
        "prices": prices,
        "totalCost": totalCost,
        "optionType": optionType,
        "createdAt": createdAt,
        "expiresAt": expiresAt,
      };

  factory TickerNotification.fromJson(dynamic jsonData) {
    return TickerNotification(
      ticker: Ticker.fromJson(jsonData["ticker"]),
      strategy: jsonData["strategy"],
      description: jsonData["description"],
      prices: List<double>.from(jsonData["prices"]),
      totalCost: double.parse(jsonData["totalCost"].toString()),
      optionType: jsonData["optionType"],
      createdAt: jsonData["createdAt"],
      expiresAt: jsonData["expiresAt"],
    );
  }

  factory TickerNotification.fromDoc(DocumentSnapshot jsonData) {
    return TickerNotification(
      docId: jsonData.id,
      ticker: Ticker.fromJson(jsonData["ticker"]),
      strategy: jsonData["strategy"],
      description: jsonData["description"],
      prices: List<double>.from(jsonData["prices"]),
      totalCost: double.parse(jsonData["totalCost"].toString()),
      optionType: jsonData["optionType"],
      createdAt: jsonData["createdAt"],
      expiresAt: jsonData["expiresAt"],
    );
  }
}
