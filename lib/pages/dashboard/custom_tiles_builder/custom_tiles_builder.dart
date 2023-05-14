import 'package:flutter/material.dart';
import 'package:smart_money_trading/apis/benzinga_api.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:smart_money_trading/pages/dashboard/news_slider.dart';
import 'package:smart_money_trading/services/navigation_service.dart';
import 'package:smart_money_trading/services/theme_services/dark_theme.dart';
import 'package:smart_money_trading/services/theme_services/light_theme.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:smart_money_trading/pages/dashboard/custom_tiles_builder/custom_tile/custom_tile.dart';
import 'package:smart_money_trading/uis/trade_detail_ui/trade_detail_ui.dart';

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
              FutureBuilder<List<Map<String, dynamic>>>(
                  initialData: [],
                  future: BenzingaApi().getNews(),
                  builder: (context, snapshot) {
                    return Expanded(child: NewsSlider(list: snapshot.data!));
                  }),
              const SizedBox(
                width: 8,
              ),
              Column(
                children: [
                  CustomTile(
                    onTap: () {},
                    top: "",
                    title: "Market Insights",
                    height: 0.20,
                    weight: 0.20,
                    color: ThemeService.dark,
                    image: Image.asset(
                      "assets/market-insight/market-insight.jpg",
                    ),
                  ),
                  CustomTile(
                    onTap: () {},
                    top: "",
                    title: "Trading Strategies \n& Risk Management",
                    height: 0.20,
                    weight: 0.20,
                    color: ThemeService.dark,
                    image: Image.asset(
                      "assets/trading-tips/trading-tips.jpg",
                    ),
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
