import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_money_trading/models/comment.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:smart_money_trading/models/ticker_notification.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';

class TradeDetailUI extends StatefulWidget {
  final TickerNotification tickerNotification;
  const TradeDetailUI({super.key, required this.tickerNotification});

  @override
  State<TradeDetailUI> createState() => _TradeDetailUIState();
}

class _TradeDetailUIState extends State<TradeDetailUI> {
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    leading: CloseButton(key: widget.key),
                    title: Text(
                      "Write Your Comment",
                      style: GoogleFonts.lato(
                          fontSize: SizeService(context).height * 0.02),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("tradeComments")
                                .doc(widget.tickerNotification.docId)
                                .collection("tradeComments")
                                .doc()
                                .set(Comment(
                                  uid: FirebaseAuth.instance.currentUser!.uid,
                                  comment: commentController.text.trim(),
                                  createdAt: Timestamp.now(),
                                  likes: {},
                                ).toJson)
                                .then((value) => Navigator.pop(context));
                          },
                          child: Text(
                            "Post",
                            style: GoogleFonts.lato(
                              color: Colors.blue,
                              fontWeight: FontWeight.w700,
                            ),
                          ))
                    ],
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: commentController,
                          decoration: const InputDecoration(
                            labelText: "Comment",
                            border: OutlineInputBorder(),
                          ),
                          minLines: 10,
                          maxLines: 10,
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      key: widget.key,
      body: CustomScrollView(
        key: widget.key,
        slivers: [
          SliverAppBar(
            key: widget.key,
            title: Text(widget.tickerNotification.ticker.title),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 0.00,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        widget.tickerNotification.ticker.title,
                        style: GoogleFonts.lato(
                          color: ThemeService.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(widget.tickerNotification.description),
                      Text(
                          "Total Cost: \$ ${widget.tickerNotification.totalCost}"),
                      Column(
                        children: widget.tickerNotification.prices
                            .map((item) => Text(
                                "Strike Price ${widget.tickerNotification.prices.indexOf(item) + 1}: \$ $item"))
                            .toList(),
                      ),
                      Text(
                        "Expires At: ${Intl().date().format(widget.tickerNotification.expiresAt.toDate())}",
                        style: GoogleFonts.lato(
                          color: ThemeService.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Comments",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("tradeComments")
                  .doc(widget.tickerNotification.docId)
                  .collection("tradeComments")
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                List<Comment> comments = snapshot.data!.docs
                    .map((e) => Comment.fromDocumentSnapshot(e))
                    .toList();

                return SliverList(
                    delegate: SliverChildBuilderDelegate((context, i) {
                  Comment comment = comments[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 2.0, vertical: 0.0),
                    child: Card(
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: ListTile(
                        title: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("customers")
                                .doc(comment.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(key: widget.key);
                              }
                              Customer customer =
                                  Customer.fromJson(snapshot.data);

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${customer.firstname} ${customer.lastname}",
                                    style: GoogleFonts.lato(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    Intl()
                                        .date()
                                        .format(comment.createdAt.toDate()),
                                    style: GoogleFonts.lato(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              );
                            }),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.comment,
                              style: GoogleFonts.lato(
                                fontSize: 12.0,
                              ),
                            ),
                            Wrap(
                              alignment: WrapAlignment.start,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    if (comment.likes!.containsKey(FirebaseAuth
                                        .instance.currentUser!.uid)) {
                                      comment.likes!.remove(FirebaseAuth
                                          .instance.currentUser!.uid);
                                    } else {
                                      comment.likes!.addAll({
                                        FirebaseAuth.instance.currentUser!.uid:
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                      });
                                    }
                                    FirebaseFirestore.instance
                                        .collection("tradeComments")
                                        .doc(widget.tickerNotification.docId)
                                        .collection("tradeComments")
                                        .doc(comment.docId)
                                        .update({
                                      "likes": comment.likes!,
                                    });
                                  },
                                  label: Text(
                                    comment.likes!.length.toString(),
                                    style: GoogleFonts.lato(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  icon: Icon(
                                    comment.likes!.containsKey(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 16.0,
                                    color: ThemeService.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }, childCount: comments.length));
              }),
        ],
      ),
    );
  }
}
