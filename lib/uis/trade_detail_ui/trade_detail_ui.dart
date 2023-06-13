import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_money_trading/models/comment.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:smart_money_trading/models/trade_alert.dart';
import 'package:smart_money_trading/services/navigation_service.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:smart_money_trading/uis/trade_detail_ui/trade_reply_ui/trade_reply_ui.dart';

class TradeDetailUI extends StatefulWidget {
  final TradeAlert tradeAlert;
  const TradeDetailUI({super.key, required this.tradeAlert});

  @override
  State<TradeDetailUI> createState() => _TradeDetailUIState();
}

class _TradeDetailUIState extends State<TradeDetailUI> {
  TextEditingController commentController = TextEditingController();
  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds}s";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h";
    } else {
      return "${difference.inDays}d";
    }
  }

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
                      style: GoogleFonts.exo2(
                          fontSize: SizeService(context).height * 0.02),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("tradeComments")
                                .doc(widget.tradeAlert.docId)
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
                            style: GoogleFonts.exo2(
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
        child: const Icon(
          Icons.comment_outlined,
        ),
      ),
      key: widget.key,
      body: CustomScrollView(
        key: widget.key,
        slivers: [
          SliverAppBar(
            key: widget.key,
            title: Text(
              widget.tradeAlert.ticker.title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            // centerTitle: true,
            // leadingWidth: SizeService(context).height * 0.2,
            // leading: ClipRRect(
            //   borderRadius: BorderRadius.circular(24),
            //   child: Image.asset(
            //     widget.tradeAlert.ticker.image,
            //     // alignment: Alignment.centerLeft,
            //     width: 48,
            //     height: 48,
            //   ),
            // ),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8.0),
                      Text(
                        widget.tradeAlert.description,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        "Total Cost:",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "\$${widget.tradeAlert.totalCost}",
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        "Strikes:",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.tradeAlert.prices.join("/"),
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[800],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        "P&L:",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '${widget.tradeAlert.pnl.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: widget.tradeAlert.pnl >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        "Published: ${formatDateTime(widget.tradeAlert.datetime.toDate())} ago",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
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
                  .doc(widget.tradeAlert.docId)
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

                return comments.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Center(
                            child: Text(
                              "Be First To Comment !!!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.exo2(
                                  fontWeight: FontWeight.w900, fontSize: 20.0),
                            ),
                          ),
                        ),
                      )
                    : SliverList(
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
                                          style: GoogleFonts.exo2(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          Intl().date().format(
                                              comment.createdAt.toDate()),
                                          style: GoogleFonts.exo2(
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
                                    style: GoogleFonts.exo2(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () {
                                          if (comment.likes!.containsKey(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid)) {
                                            comment.likes!.remove(FirebaseAuth
                                                .instance.currentUser!.uid);
                                          } else {
                                            comment.likes!.addAll({
                                              FirebaseAuth.instance.currentUser!
                                                      .uid:
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
                                            });
                                          }
                                          FirebaseFirestore.instance
                                              .collection("tradeComments")
                                              .doc(widget.tradeAlert.docId)
                                              .collection("tradeComments")
                                              .doc(comment.docId)
                                              .update({
                                            "likes": comment.likes!,
                                          });
                                        },
                                        label: Text(
                                          comment.likes!.length.toString(),
                                          style: GoogleFonts.exo2(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        icon: Icon(
                                          comment.likes!.containsKey(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          size: 16.0,
                                          color: ThemeService.primary,
                                        ),
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("tradeComments")
                                            .doc(comment.docId)
                                            .collection("tradeComments")
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(key: widget.key);
                                          }
                                          return TextButton.icon(
                                              onPressed: () {
                                                NavigationService(context).push(
                                                    TradeReplyUI(
                                                        comment: comment));
                                              },
                                              icon: const Icon(
                                                Icons.comment,
                                                size: 18.0,
                                              ),
                                              label: Text(
                                                snapshot.data!.docs.length
                                                    .toString(),
                                                style: GoogleFonts.exo2(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ));
                                        },
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
