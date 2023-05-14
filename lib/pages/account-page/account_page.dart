import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:smart_money_trading/services/navigation_service.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:smart_money_trading/uis/admin_panel_ui/admin_panel_ui.dart';
import 'package:smart_money_trading/uis/subscription-ui/subscription_ui.dart';

class AccountPage extends StatefulWidget {
  final Customer customer;
  const AccountPage({super.key, required this.customer});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: widget.key,
      slivers: [
        SliverAppBar(
          key: widget.key,
          title: const Text("Account"),
          actions: [
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Text("Logout"),
            ),
          ],
        ),
        SliverToBoxAdapter(
          key: widget.key,
          child: Column(
            key: widget.key,
            children: [
              ListTile(
                onTap: () {
                  NavigationService(context).push(
                    AdminPanelUI(
                      key: widget.key,
                    ),
                  );
                },
                key: widget.key,
                leading: Icon(
                  Icons.admin_panel_settings,
                  key: widget.key,
                ),
                title: Text(
                  "Admin Panel",
                  key: widget.key,
                ),
                subtitle: Text(
                  "Create Alerts and Notifications",
                  key: widget.key,
                ),
              ),
              ListTile(
                onTap: () {
                  NavigationService(context).push(
                    SubscriptionUI(customer: widget.customer),
                  );
                },
                key: widget.key,
                leading: Icon(
                  Icons.subscriptions,
                  key: widget.key,
                ),
                title: Text(
                  "Subscriptions",
                  key: widget.key,
                ),
                subtitle: Text(
                  "Manage Your Subscriptions",
                  key: widget.key,
                ),
              ),
              ListTile(
                onTap: () {
                  NavigationService(context).push(
                    SubscriptionUI(customer: widget.customer),
                  );
                },
                key: widget.key,
                leading: Icon(
                  Icons.inventory_sharp,
                  key: widget.key,
                ),
                title: Text(
                  "Invoices",
                  key: widget.key,
                ),
                subtitle: Text(
                  "Check Your Invoices",
                  key: widget.key,
                ),
              ),

              // ListTile(
              //   leading: Icon(Icons.color_lens),
              //   title: Text("Light Mode Theme"),
              //   subtitle: Text("Switch Theme"),
              //   trailing: Switch(
              //       activeTrackColor: ThemeService.primary,
              //       inactiveTrackColor: ThemeService.primary,
              //       value: !ThemeService(context).isDark,
              //       onChanged: (val) => ThemeService(context).switchTheme),
              // ),
              // ListTile(
              //   onTap: () {
              //     NavigationService(context).push(
              //       SubscriptionUI(customer: widget.customer),
              //     );
              //   },
              //   key: widget.key,
              //   leading: Icon(
              //     Icons.payment,
              //     color: ThemeService.primary,
              //     key: widget.key,
              //   ),
              //   title: Text(
              //     "Charges",
              //     key: widget.key,
              //   ),
              //   subtitle: Text(
              //     "Check Your Charges",
              //     key: widget.key,
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
