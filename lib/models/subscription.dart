import 'package:cloud_firestore/cloud_firestore.dart';

class Subscription {
  final String subscriptionId;
  final String subscriptionName;
  final Timestamp createdAt;
  final Timestamp startAt;
  final Timestamp endAt;
  final String status;
  final String productId;
  final String priceId;
  final String invoiceId;
  final String interval;
  final String defaultPaymentMethodId;
  final String customerId;
  final String currency;
  final String collectionMethod;
  final int amount;

  Subscription({
    required this.subscriptionId,
    required this.subscriptionName,
    required this.createdAt,
    required this.startAt,
    required this.endAt,
    required this.status,
    required this.productId,
    required this.priceId,
    required this.invoiceId,
    required this.interval,
    required this.defaultPaymentMethodId,
    required this.customerId,
    required this.currency,
    required this.collectionMethod,
    required this.amount,
  });

  Map<String, dynamic> get toJson => {
        "subscriptionId": subscriptionId,
        "subscriptionName": subscriptionName,
        "createdAt": createdAt,
        "startAt": startAt,
        "endAt": endAt,
        "status": status,
        "productId": productId,
        "priceId": priceId,
        "invoiceId": invoiceId,
        "interval": interval,
        "defaultPaymentMethodId": defaultPaymentMethodId,
        "customerId": customerId,
        "currency": currency,
        "collectionMethod": collectionMethod,
        "amount": amount,
      };

  factory Subscription.fromJson(Map<String, dynamic> jsonData) {
    return Subscription(
      subscriptionId: jsonData["subscriptionId"],
      subscriptionName: jsonData["subscriptionName"],
      createdAt: Timestamp.fromMillisecondsSinceEpoch(
          jsonData["createdAt"]["_seconds"] * 1000),
      startAt: Timestamp.fromMillisecondsSinceEpoch(
          jsonData["startAt"]["_seconds"] * 1000),
      endAt: Timestamp.fromMillisecondsSinceEpoch(
          jsonData["endAt"]["_seconds"] * 1000),
      status: jsonData["status"],
      productId: jsonData["productId"],
      priceId: jsonData["priceId"],
      invoiceId: jsonData["invoiceId"],
      interval: jsonData["interval"],
      defaultPaymentMethodId: jsonData["defaultPaymentMethodId"],
      customerId: jsonData["customerId"],
      currency: jsonData["currency"],
      collectionMethod: jsonData["collectionMethod"],
      amount: jsonData["amount"],
    );
  }

  factory Subscription.fromDocumentSnapshot(dynamic jsonData) {
    return Subscription(
      subscriptionId: jsonData["subscriptionId"],
      subscriptionName: jsonData["subscriptionName"],
      createdAt: jsonData["createdAt"],
      startAt: jsonData["startAt"],
      endAt: jsonData["endAt"],
      status: jsonData["status"],
      productId: jsonData["productId"],
      priceId: jsonData["priceId"],
      invoiceId: jsonData["invoiceId"],
      interval: jsonData["interval"],
      defaultPaymentMethodId: jsonData["defaultPaymentMethodId"],
      customerId: jsonData["customerId"],
      currency: jsonData["currency"],
      collectionMethod: jsonData["collectionMethod"],
      amount: jsonData["amount"],
    );
  }
}
