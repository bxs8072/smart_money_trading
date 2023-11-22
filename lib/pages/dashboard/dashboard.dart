import 'package:flutter/material.dart';
import 'package:smart_money_trading/app_drawer/app_drawer.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/pages/dashboard/custom_tiles_builder/custom_tiles_builder.dart';

class Dashboard extends StatefulWidget {
  final Customer customer;
  const Dashboard({Key? key, required this.customer}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    // BenzingaApi().getNews();
    return Scaffold(
      // drawer: const AppDrawer(),
      endDrawer: const AppDrawer(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            centerTitle: false,
            pinned: true,
            title: Text(
              "OXT",
              style: GoogleFonts.righteous(
                fontSize: SizeService(context).height * 0.05,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ListTile(
              leading: const Icon(
                Icons.school,
                size: 35,
              ),
              title: Text(
                "OXT Learning",
                style: GoogleFonts.exo2(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          CustomTilesBuilder(
            customer: widget.customer,
            key: widget.key,
          ),
        ],
      ),
    );
  }
}
