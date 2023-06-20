import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_money_trading/models/insight_alert.dart';
import 'package:smart_money_trading/uis/insight_detail_ui/insight_detail_ui.dart';

class MarketInsight extends StatefulWidget {
  const MarketInsight({Key? key}) : super(key: key);

  @override
  State<MarketInsight> createState() => _MarketInsightState();
}

class _MarketInsightState extends State<MarketInsight> {
  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} secs";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} mins";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hrs";
    } else {
      return "${difference.inDays} days";
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'OXT Insights',
            style: GoogleFonts.exo2(
              fontWeight: FontWeight.w600,
            ),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            tabs: [
              Tab(text: 'Daily'),
              Tab(text: 'Weekly'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildInsightsList('daily'),
            _buildInsightsList('weekly'),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsList(String value) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('insights')
          .orderBy("createdAt", descending: true)
          .where('type', isEqualTo: value)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final insightList = snapshot.data?.docs.map((document) {
          final data = document.data() as Map<String, dynamic>?;

          if (data == null) {
            return const SizedBox();
          }

          InsightAlert insightAlert = InsightAlert.fromDoc(document);

          return Card(
            elevation: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Stack(
              children: [
                ListTile(
                  title: Text(
                    data['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      '${data['description']}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  trailing: Text(
                    '${formatDateTime(data['createdAt'].toDate())} ago',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            InsightDetailUI(insightAlert: insightAlert),
                      ),
                    ); // Handle tile onTap action
                  },
                ),
              ],
            ),
          );
        }).toList();

        return ListView(
          children: insightList ?? [],
        );
      },
    );
  }
}
