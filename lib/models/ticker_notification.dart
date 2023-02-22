import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_money_trading/models/ticker.dart';

class TickerNotification {
  final Ticker ticker;
  final String strategy;
  final String description;
  final List<double> strikeprices;
  final String totalcost;
  final String optiontype;
  final Timestamp createdAt;
  final Timestamp expoDate;

  TickerNotification(
      {required this.ticker,
      required this.strategy,
      required this.description,
      required this.strikeprices,
      required this.totalcost,
      required this.optiontype,
      required this.createdAt,
      required this.expoDate});

  Map<String, dynamic> get toJson => {
        "ticker": ticker.toJson,
        "strategy": strategy,
        "description": description,
        "strikeprices": strikeprices,
        "totalcost": totalcost,
        "optiontype": optiontype,
        "createdAt": createdAt,
        "expoDate": expoDate,
      };

  factory TickerNotification.fromJson(dynamic jsonData) {
    return TickerNotification(
      ticker: Ticker.fromJson(jsonData["ticker"]),
      strategy: jsonData["strategy"],
      description: jsonData["description"],
      strikeprices: jsonData["strikeprices"],
      totalcost: jsonData["totalcost"],
      optiontype: jsonData["optiontype"],
      createdAt: jsonData["createdAt"],
      expoDate: jsonData["expoDate"],
    );
  }

  factory TickerNotification.fromDoc(DocumentSnapshot jsonData) {
    return TickerNotification(
      ticker: Ticker.fromJson(jsonData.get('ticker')),
      strategy: jsonData.get('strategy'),
      description: jsonData.get('description'),
      totalcost: jsonData.get('totalcost'),
      optiontype: jsonData.get('optiontype'),
      strikeprices: List<double>.from(jsonData.get('strikeprices')),
      createdAt: jsonData.get('createdAt'),
      expoDate: jsonData.get('expoDate'),
    );
  }
}
