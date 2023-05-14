import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_money_trading/models/trade_alert.dart';
import 'package:smart_money_trading/services/navigation_service.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:smart_money_trading/uis/admin_panel_ui/create_trade_alert_ui/create_trade_alert_ui.dart';
import 'package:smart_money_trading/uis/admin_panel_ui/update_trade_alert_ui/update_trade_alert_ui.dart';

class AdminPanelUI extends StatelessWidget {
  const AdminPanelUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0.00,
        backgroundColor: ThemeService.primary,
        label: const Text("ADD"),
        onPressed: () {
          NavigationService(context).push(CreateTradeAlertUI(key: key));
        },
        icon: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        key: key,
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(
              "Admin Panel",
              key: key,
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "Opened Trades",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("optionAlerts")
                .where("isClosed", isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: CircularProgressIndicator(
                    key: key,
                  ),
                );
              } else {
                List<TradeAlert> list = snapshot.data!.docs
                    .map((e) => TradeAlert.fromDoc(e))
                    .toList();

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      TradeAlert tradeAlert = list[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 5.0,
                        ),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: ThemeService(context).isDark
                              ? Colors.black12
                              : Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 0.1,
                              blurRadius: 0.0,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap: () {
                            NavigationService(context).push(UpdateTradeAlertUI(
                              tradeAlert: tradeAlert,
                              key: key,
                            ));
                          },
                          title: Text(
                            tradeAlert.ticker.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            Intl()
                                .date("EEEE | M.d.y | hh:mm a")
                                .format(tradeAlert.openedAt.toDate()),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("optionAlerts")
                                  .doc(tradeAlert.docId)
                                  .delete();
                            },
                            icon: const Icon(
                              Icons.remove_circle,
                              color: ThemeService.error,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: list.length,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
