import 'package:flutter/material.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:smart_money_trading/pages/dashboard/custom_tiles_builder/custom_tile/custom_tile.dart';
import 'package:smart_money_trading/pages/dashboard/custom_tiles_builder/custom_tiles_builder.dart';

class Dashboard extends StatefulWidget {
  final Customer person;
  const Dashboard({Key? key, required this.person}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          key: widget.key,
          title: Row(
            children: [
              Text(
                "SMT",
                style: GoogleFonts.righteous(
                  fontSize: SizeService(context).height * 0.05,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: ListTile(
            leading: Text(
              "Hello, ${widget.person.firstname}",
              style: GoogleFonts.exo2(
                fontSize: SizeService(context).height * 0.03,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Text(
              "Recent trades",
              style: GoogleFonts.exo2(
                fontSize: SizeService(context).height * 0.02,
                fontWeight: FontWeight.w300,
                // color: Colors.black38,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 1,
              horizontal: 10,
            ),
            child: CustomTile(
              onTap: () {},
              image: Image.asset(
                "assets/trading-tips/biga-bull.jpg",
              ),
              top: "Daily Trade Notifications",
              title: "Daily Trades",
              height: .23,
              weight: double.infinity,
              color: ThemeService.dark,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: CustomTilesBuilder(
              person: widget.person,
              key: widget.key,
            ),
          ),
        ),
      ],
    );
  }
}
