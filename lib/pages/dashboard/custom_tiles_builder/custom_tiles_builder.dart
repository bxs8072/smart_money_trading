import 'package:flutter/material.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:smart_money_trading/pages/market_insight/market_insight_page.dart';
import 'package:smart_money_trading/services/navigation_service.dart';
import 'package:smart_money_trading/services/theme_services/dark_theme.dart';
import 'package:smart_money_trading/services/theme_services/light_theme.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:smart_money_trading/pages/dashboard/custom_tiles_builder/custom_tile/custom_tile.dart';

class CustomTilesBuilder extends StatelessWidget {
  final Customer person;
  const CustomTilesBuilder({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomTile(
          onTap: () {
            person.isSubscribed == false
                ? ''
                : NavigationService(context).push(const MarketInsight());
          },
          top: "",
          title: "Market Insights",
          color: ThemeService.dark,
          image: "assets/market-insight/market-insight.jpg",
        ),
        CustomTile(
          onTap: () {},
          top: "",
          title: "Educational Matrial",
          color: ThemeService.dark,
          image: "assets/trading-tips/trading-tips.jpg",
        ),
      ],
    );
  }
}
