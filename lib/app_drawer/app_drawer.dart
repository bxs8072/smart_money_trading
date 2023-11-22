import 'package:flutter/material.dart';
import 'package:smart_money_trading/apis/auth_api.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:theme_provider/theme_provider.dart';

class AppDrawer extends StatelessWidget {
  final Customer? person;
  const AppDrawer({Key? key, this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: key,
      child: SafeArea(
        child: Scaffold(
          key: key,
          body: Column(
            children: [
              Expanded(
                  child: ListView(
                children: [
                  ListTile(
                    leading: Icon(
                      ThemeService(context).isDark
                          ? Icons.light_rounded
                          : Icons.light_outlined,
                      color: ThemeService(context).isDark
                          ? Colors.white
                          : Colors.black87,
                    ),
                    title: const Text("Dark Mode"),
                    subtitle: Text(ThemeService.darkId ==
                            ThemeProvider.controllerOf(context).currentThemeId
                        ? "Active"
                        : "Inactive"),
                    trailing: Switch(
                      activeColor: ThemeService.secondary,
                      value: ThemeService.darkId ==
                          ThemeProvider.controllerOf(context).currentThemeId,
                      onChanged: (val) {
                        ThemeProvider.controllerOf(context).nextTheme();
                      },
                    ),
                  ),
                ],
              )),
              ListTile(
                key: key,
                onTap: () {
                  AuthApi().logout();
                },
                leading: Icon(
                  Icons.door_back_door_outlined,
                  color: ThemeService(context).isDark
                      ? Colors.white
                      : Colors.black54,
                  key: key,
                ),
                title: Text(
                  "Logout",
                  key: key,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
