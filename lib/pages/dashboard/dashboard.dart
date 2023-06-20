import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_money_trading/apis/benzinga_api.dart';
import 'package:smart_money_trading/app_drawer/app_drawer.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_money_trading/models/insight_alert.dart';
import 'package:smart_money_trading/models/trade_alert.dart';
import 'package:smart_money_trading/pages/dashboard/insights_slider.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/pages/dashboard/custom_tiles_builder/custom_tiles_builder.dart';
import 'package:smart_money_trading/uis/trade_detail_ui/trade_detail_ui.dart';

import '../../services/navigation_service.dart';
import '../../uis/trade_archives_ui/trade_archives_ui.dart';

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
      appBar: AppBar(
        centerTitle: true,

        title: Row(
          children: [
            Text(
              "OXT",
              style: GoogleFonts.righteous(
                fontSize: SizeService(context).height * 0.05,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        // leading: IconButton(
        //   icon: Icon(Icons.menu),
        //   onPressed: () {
        //     // Open the app drawer here
        //     const AppDrawer();
        //   },
        // ),
      ),
      body: CustomScrollView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // SliverAppBar(
          //   pinned: true,
          //   key: widget.key,
          //   title: Row(
          //     children: [
          //       Text(
          //         "OXT",
          //         style: GoogleFonts.righteous(
          //           fontSize: SizeService(context).height * 0.05,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("insights")
                    .where(
                      "createdAt",
                      isGreaterThan: Timestamp.fromDate(
                        DateTime(
                          today.year,
                          today.month,
                          today.day,
                          0,
                          0,
                          0,
                          0,
                        ),
                      ),
                    )
                    .where("type", isEqualTo: "daily")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    List<InsightAlert> list = snapshot.data!.docs
                        .map((e) => InsightAlert.fromDoc(e))
                        .toList();
                    return InsightsSlider(list: list);
                  }
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 10,
              ),
              child: CustomTilesBuilder(
                person: widget.customer,
                key: widget.key,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 0),
                    title: Text(
                      "Recent trades",
                      key: widget.key,
                      style: GoogleFonts.exo2(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        NavigationService(context).push(const TradeArchives());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black87.withOpacity(0.69)),
                        child: Text(
                          "Trade archives",
                          style: GoogleFonts.exo2(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          key: widget.key,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: SizeService(context).height * 0.30,
                    alignment: Alignment.topCenter,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("tradeAlerts")
                          .where(
                            "createdAt",
                            isGreaterThan: Timestamp.fromDate(
                              DateTime(
                                today.year,
                                today.month,
                                today.day,
                                0,
                                0,
                                0,
                                0,
                              ),
                            ),
                          )
                          .orderBy("createdAt", descending: true)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data?.docs.length ?? 0,
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) {
                            final document = snapshot.data?.docs[index];
                            if (document == null) {
                              return const SizedBox(); // or any other widget to handle null document
                            }

                            final data =
                                document.data() as Map<String, dynamic>?;

                            if (data == null) {
                              return const SizedBox(); // or any other widget to handle null data
                            }

                            String optionType =
                                data['optionType'].toString().toUpperCase();
                            String textValue = '';
                            if (optionType == 'SELL') {
                              textValue = 'Sold';
                            } else if (optionType == 'BUY') {
                              textValue = 'Bought';
                            }
                            TradeAlert tradeAlert =
                                TradeAlert.fromDoc(document);

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TradeDetailUI(tradeAlert: tradeAlert),
                                  ),
                                );
                              },
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: Text(
                                  data['ticker'] != null &&
                                          data['ticker']['title'] != null
                                      ? data['ticker']['title']
                                      : '',
                                  style: GoogleFonts.exo2(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$textValue ${data['prices'] != null ? data['prices'].map((price) => price.toStringAsFixed(0)).join('/') : ''}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      '${data['strategy'] != null ? data['strategy'].toString().toUpperCase() : ''} for ${data['totalCost']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  'at ${data['createdAt'] != null ? DateFormat('hh:mm a').format(data['createdAt'].toDate()) : ''}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                trailing: Text(
                                  '${data['pnl'] != null ? data['pnl'].toStringAsFixed(0) : ''}%',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color:
                                        data['pnl'] != null && data['pnl'] >= 0
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
