import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_money_trading/services/navigation_service.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/uis/trade_detail_ui/trade_detail_ui.dart';

class TradeArchives extends StatelessWidget {
  const TradeArchives({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trade Archives',
          style: GoogleFonts.exo2(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('tradeAlerts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map(
              (DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                String optionType = data['optionType'].toString().toUpperCase();
                String textValue = '';
                if (optionType == 'SELL') {
                  textValue = 'Sold';
                } else if (optionType == 'BUY') {
                  textValue = 'Bought';
                }

                return Card(
                  elevation: 10,
                  margin: const EdgeInsets.all(2),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ListTile(
                          // onTap: () => NavigationService(context).push(const TradeDetailUI(tradeAler,)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 1.0, vertical: 2.0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                50.0), // Adjust the radius as needed
                            child: Image.asset(
                              data['ticker']['image'],
                            ),
                          ),
                          subtitle: Text(
                            '$textValue \n${data['prices'].map((price) => price.toStringAsFixed(0)).join('∕')}\n${data['strategy'].toString().toUpperCase()} for ${data['totalCost']} at ${Intl().date("hh:mm a").format(data['createdAt'].toDate())}',
                            style: GoogleFonts.exo2(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          title: Text(
                            data['ticker']['title'],
                            style: GoogleFonts.exo2(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Text(
                            '${data['pnl'].toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: SizeService(context).height * 0.02,
                              color:
                                  data['pnl'] >= 0 ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                        // Text(
                        //   '@${Intl().date("MM.dd.yyyy hh:mm a").format(data['createdAt'].toDate())}',
                        //   style: GoogleFonts.exo2(
                        //     fontSize: 14.0,
                        //     fontWeight: FontWeight.w700,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ).toList(),
          );
        },
      ),
    );
  }
}
