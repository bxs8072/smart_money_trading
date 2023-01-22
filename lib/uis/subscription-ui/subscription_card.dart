import 'package:flutter/material.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:smart_money_trading/services/size_service.dart';

class SubscriptionCard extends StatelessWidget {
  final Customer customer;
  const SubscriptionCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Card(
      key: key,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeService(context).width * 0.03,
          vertical: SizeService(context).height * 0.03,
        ),
        child: Column(
          children: [
            Text("BUY SUBSCRIPTION", key: key),
          ],
        ),
      ),
    );
  }
}
