import 'package:flutter/material.dart';
import 'package:smart_money_trading/custom_widgets/custom_card.dart';
import 'package:smart_money_trading/services/navigation_service.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:smart_money_trading/uis/admin_panel_ui/create_insight_alert_ui/create_insight_alert_ui.dart';
import 'package:smart_money_trading/uis/admin_panel_ui/create_trade_alert_ui/create_trade_alert_ui.dart';

class AdminPanelUI extends StatelessWidget {
  const AdminPanelUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        key: key,
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(
              "Admin Panel",
              key: key,
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                CustomCard(
                  padding: const EdgeInsets.all(0.0),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 3.0,
                  ),
                  child: ListTile(
                    onTap: () {
                      NavigationService(context).push(
                        CreateTradeAlertUI(
                          key: key,
                        ),
                      );
                    },
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    leading: const Icon(Icons.notification_add),
                    title: const Text("Create Trade Alert"),
                    subtitle: const Text("Create closing trade alerts"),
                  ),
                ),
                CustomCard(
                  padding: const EdgeInsets.all(0.0),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 3.0,
                  ),
                  child: ListTile(
                    onTap: () {
                      NavigationService(context).push(
                        CreateInsightAlertUI(
                          key: key,
                        ),
                      );
                    },
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    leading: const Icon(Icons.insights),
                    title: const Text("Create Insight Alert"),
                    subtitle: const Text("Create market insights alerts"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
