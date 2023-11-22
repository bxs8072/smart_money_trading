import 'package:flutter/material.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:smart_money_trading/pages/market_insight/market_insight_page.dart';
import 'package:smart_money_trading/services/navigation_service.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:smart_money_trading/pages/dashboard/custom_tiles_builder/custom_tile.dart';
import 'package:smart_money_trading/uis/educational_material_ui/educational_material_ui.dart';
import 'package:smart_money_trading/uis/quizes_builder_ui/quizes_builder_ui.dart';

class CustomTilesBuilder extends StatelessWidget {
  final Customer customer;
  const CustomTilesBuilder({Key? key, required this.customer})
      : super(key: key);

  List<CustomTile> customTiles(BuildContext context) => [
        CustomTile(
          onTap: () {
            customer.isSubscribed == false
                ? ''
                : NavigationService(context).push(const MarketInsight());
          },
          title: "Market Insights",
          color: ThemeService.dark,
          image: "assets/market-insight/market-insight.jpg",
        ),
        CustomTile(
          onTap: () {
            NavigationService(context).push(EducationalMaterialUI(key: key));
          },
          title: "Educational Material",
          color: ThemeService.dark,
          image: "assets/trading-tips/trading-tips.jpg",
        ),
        CustomTile(
          onTap: () {
            NavigationService(context).push(QuizesBuilderUI(
              key: key,
              customer: customer,
            ));
          },
          title: "OXT Quizes",
          color: ThemeService.dark,
          image: "assets/quiz_dash.jpg",
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(12.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return customTiles(context)[index];
          },
          childCount: customTiles(context).length,
        ),
      ),
    );
  }
}
