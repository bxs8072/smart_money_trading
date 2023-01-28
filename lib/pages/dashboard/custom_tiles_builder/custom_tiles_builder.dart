import 'package:flutter/material.dart';
import 'package:smart_money_trading/models/customer.dart';
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
              CustomTile(
                  onTap: () {},
                  top: "SM NEWS",
                  title: "NEWS",
                  height: .4,
                  weight: .25,
                  color: ThemeService.light),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  CustomTile(
                    onTap: () {},
                    top: "Market Insights",
                    title: "Market Insights",
                    height: 0.18,
                    weight: 0.20,
                    color: ThemeService.dark,
                  ),
                  CustomTile(
                    onTap: () {},
                    top: "Trading Tips",
                    title: "Trading Tips",
                    height: 0.18,
                    weight: 0.20,
                    color: ThemeService.dark,
                  ),
                ],
              ),
            ],
          ),
          // CustomTile(
          //   onTap: () {},
          //   top: "SM Charts",
          //   title: "Stock Ticker",
          //   height: 0.1,
          //   weight: .45,
          // ),
        ],
      ),
    );
  }
}
