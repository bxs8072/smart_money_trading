import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_money_trading/apis/benzinga_api.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_money_trading/models/trade_alert.dart';
import 'package:smart_money_trading/pages/dashboard/trades_slider.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/pages/dashboard/custom_tiles_builder/custom_tiles_builder.dart';

class Dashboard extends StatefulWidget {
  final Customer customer;
  const Dashboard({Key? key, required this.customer}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    BenzingaApi().getNews();
    return CustomScrollView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          key: widget.key,
          title: Row(
            children: [
              Image.asset(
                "assets/oxt_logo_dash.png",
                height: SizeService(context).height * 0.060,
                alignment: Alignment.topCenter,
              ),
              // Text(
              //   "OXT",
              //   style: GoogleFonts.righteous(
              //     fontSize: SizeService(context).height * 0.05,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 1,
              horizontal: 10,
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("optionAlerts")
                  .where("isClosed", isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<TradeAlert> list = snapshot.data!.docs
                      .map((e) => TradeAlert.fromDoc(e))
                      .toList();
                  return TradesSlider(list: list);
                }
              },
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
              person: widget.customer,
              key: widget.key,
            ),
          ),
        ),
      ],
    );
  }
}
