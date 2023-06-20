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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 5,
              ),
              Row(
                children: [
                  CustomTile(
                    onTap: () {
                      NavigationService(context).push(const MarketInsight());
                    },
                    top: "",
                    title: "Market Insights",
                    height: 0.10,
                    weight: 0.22,
                    color: ThemeService.dark,
                    image: Image.asset(
                      "assets/market-insight/market-insight.jpg",
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  CustomTile(
                    onTap: () {},
                    top: "",
                    title: "Educational Matrial",
                    height: 0.10,
                    weight: 0.22,
                    color: ThemeService.dark,
                    image: Image.asset(
                      "assets/trading-tips/trading-tips.jpg",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
