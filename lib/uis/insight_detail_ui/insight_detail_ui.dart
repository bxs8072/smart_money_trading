import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:smart_money_trading/models/insight_alert.dart';

class InsightDetailUI extends StatefulWidget {
  final InsightAlert insightAlert;
  const InsightDetailUI({super.key, required this.insightAlert});

  @override
  State<InsightDetailUI> createState() => _InsightDetailUIState();
}

class _InsightDetailUIState extends State<InsightDetailUI> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
