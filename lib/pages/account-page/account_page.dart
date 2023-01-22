import 'package:flutter/material.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:smart_money_trading/services/navigation_service.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
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
        ),
        SliverToBoxAdapter(
          key: widget.key,
          child: Column(
            key: widget.key,
            children: [
              ListTile(
                onTap: () {
                  NavigationService(context).push(
                    SubscriptionUI(customer: widget.customer),
                  );
                },
                key: widget.key,
                leading: Icon(
                  Icons.subscriptions,
                  color: ThemeService.primary,
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
            ],
          ),
        ),
      ],
    );
  }
}
