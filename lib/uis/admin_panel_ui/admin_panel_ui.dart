import 'package:flutter/material.dart';
import 'package:smart_money_trading/services/navigation_service.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:smart_money_trading/uis/admin_panel_ui/create_alert_ui/create_alert_ui.dart';

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
                ListTile(
                  onTap: () {
                    NavigationService(context).push(CreateAlertUI(key: key));
                  },
                  leading: const Icon(
                    Icons.add_alert_sharp,
                    color: ThemeService.primary,
                  ),
                  title: Text(
                    "Create Alert",
                    key: key,
                  ),
                  subtitle: Text(
                    "Create Oprions Alert",
                    key: key,
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
