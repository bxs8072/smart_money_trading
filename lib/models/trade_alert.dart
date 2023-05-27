import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_money_trading/models/ticker.dart';

class TradeAlert {
  final String? docId;
  final Ticker ticker;
  final String strategy;
  final bool isClosed;
  final String description;
  final List<double> prices;
  final double totalCost;
  final double pnl;
  final String optionType;
  String alertType;
  final Timestamp datetime;
  final Timestamp createdAt;

  TradeAlert({
    required this.docId,
    required this.ticker,
    required this.strategy,
    required this.createdAt,
    required this.isClosed,
    required this.description,
    required this.prices,
    required this.totalCost,
    required this.pnl,
    required this.optionType,
    required this.datetime,
    this.alertType = "INSIGHT_ALERT",
  });

  Map<String, dynamic> get toJson => {
        "ticker": ticker.toJson,
        "strategy": strategy,
        "isClosed": isClosed,
        "description": description,
        "prices": prices,
        "pnl": pnl,
        "totalCost": totalCost,
        "optionType": optionType,
        "datetime": datetime,
        "createdAt": createdAt,
        "alertType": alertType,
      };

  factory TradeAlert.fromDoc(DocumentSnapshot doc) {
    return TradeAlert(
      docId: doc.id,
      ticker: Ticker.fromJson(doc.get("ticker")),
      strategy: doc.get("strategy"),
      isClosed: doc.get("isClosed"),
      description: doc.get("description"),
      prices: List<double>.from(doc.get("prices")),
      totalCost: double.parse(doc.get("totalCost").toString()),
      pnl: double.parse(doc.get("pnl").toString()),
      optionType: doc.get("optionType"),
      datetime: doc.get("datetime"),
      createdAt: doc.get("createdAt"),
      alertType: doc.get('alertType'),
    );
  }
}
