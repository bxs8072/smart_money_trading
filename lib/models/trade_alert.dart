import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_money_trading/models/ticker.dart';

class TradeAlert {
  final String? docId;
  final Ticker ticker;
  final String strategy;
  final bool isClosed;
  final String openedDescription;
  final String closedDescription;
  final List<double> prices;
  final double totalCost;
  final double pnl;
  final String optionType;
  final Timestamp openedAt;
  final Timestamp closedAt;

  TradeAlert({
    required this.docId,
    required this.ticker,
    required this.strategy,
    required this.isClosed,
    required this.openedDescription,
    required this.closedDescription,
    required this.prices,
    required this.totalCost,
    required this.pnl,
    required this.optionType,
    required this.openedAt,
    required this.closedAt,
  });

  Map<String, dynamic> get toJson => {
        "ticker": ticker.toJson,
        "strategy": strategy,
        "isClosed": isClosed,
        "openedDescription": openedDescription,
        "closedDescription": closedDescription,
        "prices": prices,
        "pnl": pnl,
        "totalCost": totalCost,
        "optionType": optionType,
        "openedAt": openedAt,
        "closedAt": closedAt,
      };

  factory TradeAlert.fromDoc(DocumentSnapshot doc) {
    return TradeAlert(
      docId: doc.id,
      ticker: Ticker.fromJson(doc.get("ticker")),
      strategy: doc.get("strategy"),
      isClosed: doc.get("isClosed"),
      openedDescription: doc.get("openedDescription"),
      closedDescription: doc.get("closedDescription"),
      prices: List<double>.from(doc.get("prices")),
      totalCost: double.parse(doc.get("totalCost").toString()),
      pnl: double.parse(doc.get("pnl").toString()),
      optionType: doc.get("optionType"),
      openedAt: doc.get("openedAt"),
      closedAt: doc.get("closedAt"),
    );
  }
}
