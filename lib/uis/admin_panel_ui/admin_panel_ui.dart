import 'package:flutter/material.dart';
import 'package:smart_money_trading/custom_widgets/custom_card.dart';
import 'package:smart_money_trading/services/navigation_service.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:smart_money_trading/uis/admin_panel_ui/create_insight_alert_ui/create_insight_alert_ui.dart';
import 'package:smart_money_trading/uis/admin_panel_ui/create_trade_alert_ui/create_trade_alert_ui.dart';
import 'package:smart_money_trading/uis/admin_panel_ui/manage_education_materials_ui/manage_education_materials_ui.dart';
import 'package:smart_money_trading/uis/admin_panel_ui/manage_quizes_ui/manage_quizes_ui.dart';

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
                CustomCard(
                  padding: const EdgeInsets.all(0.0),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 3.0,
                  ),
                  child: ListTile(
                    onTap: () {
                      NavigationService(context).push(
                        ManageQuizesUI(
                          key: key,
                        ),
                      );
                    },
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    leading: const Icon(Icons.question_answer),
                    title: const Text("Manage Quizes"),
                    subtitle: const Text("Manage OXT Quizes"),
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
                        ManageEducationMaterialsUI(key: key),
                      );
                    },
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    leading: const Icon(Icons.school),
                    title: const Text("Manage OXT Education Material"),
                    subtitle:
                        const Text("Create and Edit OXT Education Materials"),
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
