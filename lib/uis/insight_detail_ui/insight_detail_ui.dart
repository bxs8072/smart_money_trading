import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:smart_money_trading/models/comment.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:smart_money_trading/models/insight_alert.dart';
import 'package:smart_money_trading/services/navigation_service.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:smart_money_trading/uis/trade_detail_ui/trade_reply_ui/trade_reply_ui.dart';

class InsightDetailUI extends StatefulWidget {
  final InsightAlert insightAlert;
  const InsightDetailUI({super.key, required this.insightAlert});

  @override
  State<InsightDetailUI> createState() => _InsightDetailUIState();
}

class _InsightDetailUIState extends State<InsightDetailUI> {
  TextEditingController commentController = TextEditingController();

  String _getTimeDifference(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} secs ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} mins ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hrs ago";
    } else if (difference.inDays == 1) {
      return "${difference.inDays} day ago";
    } else {
      return "${difference.inDays} days ago";
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
                                .collection("insightComments")
                                .doc(widget.insightAlert.docId)
                                .collection("insightComments")
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
        child: const Icon(Icons.add),
      ),
      key: widget.key,
      body: CustomScrollView(
        key: widget.key,
        slivers: [
          SliverAppBar(
            key: widget.key,
            title: Text(widget.insightAlert.title),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.insightAlert.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.exo2(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.insightAlert.description,
                        style: GoogleFonts.exo2(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Published: ${_getTimeDifference(widget.insightAlert.createdAt.toDate())}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
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
                  .collection("insightComments")
                  .doc(widget.insightAlert.docId)
                  .collection("insightComments")
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
                                              .collection("insightComments")
                                              .doc(widget.insightAlert.docId)
                                              .collection("insightComments")
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
                                            .collection("insightComments")
                                            .doc(comment.docId)
                                            .collection("insightComments")
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
                                            ),
                                          );
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
