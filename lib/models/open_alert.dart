import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_money_trading/models/ticker.dart';

class OpenAlert {
  final String? docId;
  final Ticker ticker;
  final String type;
  final String description;
  final Timestamp datetime;
  final Timestamp createdAt;

  OpenAlert(
      {this.docId,
      required this.ticker,
      required this.type,
      required this.description,
      required this.createdAt,
      required this.datetime});

  Map<String, dynamic> get toJson => {
        "ticker": ticker.toJson,
        "description": description,
        "type": type,
        "createdAt": createdAt,
        "datetime": datetime,
      };

  factory OpenAlert.fromJson(dynamic jsonData) {
    return OpenAlert(
      ticker: Ticker.fromJson(jsonData["ticker"]),
      description: jsonData["description"],
      type: jsonData["optionType"],
      createdAt: jsonData["createdAt"],
      datetime: jsonData["datetime"],
    );
  }

  factory OpenAlert.fromDoc(DocumentSnapshot jsonData) {
    return OpenAlert(
      ticker: Ticker.fromJson(jsonData["ticker"]),
      description: jsonData["description"],
      type: jsonData["optionType"],
      createdAt: jsonData["createdAt"],
      datetime: jsonData["datetime"],
    );
  }
}
