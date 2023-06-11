import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TradeArchives extends StatelessWidget {
  const TradeArchives({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trade Archives'),
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
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              return Card(
                elevation: 10,
                child: ListTile(
                  title: Text(data['ticker']['title']),
                  subtitle: Text(data['description']),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
