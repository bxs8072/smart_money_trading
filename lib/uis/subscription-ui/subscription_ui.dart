import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_money_trading/apis/stripe_api.dart';
import 'package:smart_money_trading/apis/subscription_api.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:smart_money_trading/models/subscription.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionUI extends StatefulWidget {
  final Customer customer;
  const SubscriptionUI({super.key, required this.customer});

  @override
  State<SubscriptionUI> createState() => _SubscriptionUIState();
}

class _SubscriptionUIState extends State<SubscriptionUI> {
  StripeApi stripeApi = StripeApi();
  SubscriptionApi subscriptionApi = SubscriptionApi();

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              key: widget.key,
              title: Text(
                "Subscriptions",
                key: widget.key,
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("subscriptions")
                    .doc(widget.customer.stripeCustomerId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SliverToBoxAdapter(
                      child: Center(
                        key: widget.key,
                        child: CircularProgressIndicator(
                          key: widget.key,
                        ),
                      ),
                    );
                  } else {
                    if (!snapshot.data!.exists) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  Map<String, dynamic> response =
                                      await stripeApi.getCheckoutSession(
                                    plan: "monthly",
                                    customerId:
                                        widget.customer.stripeCustomerId!,
                                  );
                                  String checkoutUrl = response["url"];
                                  await launchUrl(
                                    Uri.parse(checkoutUrl),
                                    mode: LaunchMode.inAppWebView,
                                  );
                                },
                                child: Text(
                                  "Buy Monthly Subscription",
                                  key: widget.key,
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ThemeService.warning,
                                ),
                                onPressed: () async {
                                  Map<String, dynamic> response =
                                      await stripeApi.getCheckoutSession(
                                    plan: "yearly",
                                    customerId:
                                        widget.customer.stripeCustomerId!,
                                  );
                                  String checkoutUrl = response["url"];
                                  await launchUrl(
                                    Uri.parse(checkoutUrl),
                                    mode: LaunchMode.inAppWebView,
                                  );
                                },
                                child: Text(
                                  "Buy Yearly Subscription",
                                  key: widget.key,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      Subscription subscription =
                          Subscription.fromDocumentSnapshot(snapshot.data);
                      return SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        subscription.subscriptionName,
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        "\$${(subscription.amount / 100).toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            SizeService(context).height * 0.03,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "STATUS",
                                                style: TextStyle(
                                                  color: subscription.status ==
                                                          "active"
                                                      ? ThemeService.success
                                                      : ThemeService.error,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              Text(
                                                subscription.status
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  color: subscription.status ==
                                                          "active"
                                                      ? ThemeService.success
                                                      : ThemeService.error,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              const Text(
                                                "STARTS",
                                                style: TextStyle(
                                                  color: ThemeService.primary,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              Text(
                                                Intl()
                                                    .date("MM.dd.yyyy")
                                                    .format(subscription.startAt
                                                        .toDate()),
                                                style: const TextStyle(
                                                  color: ThemeService.primary,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              const Text(
                                                "ENDS",
                                                style: TextStyle(
                                                  color: ThemeService.error,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              Text(
                                                Intl()
                                                    .date("MM.dd.yyyy")
                                                    .format(subscription.endAt
                                                        .toDate()),
                                                style: const TextStyle(
                                                  color: ThemeService.error,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                }),
            const SliverToBoxAdapter(
              child: Text(
                "Previous Subscriptions",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            FutureBuilder<List<Subscription>>(
                future: subscriptionApi.getSubscriptions(
                    customerId: widget.customer.stripeCustomerId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(
                          key: widget.key,
                        ),
                      ),
                    );
                  } else {
                    List<Subscription> list = snapshot.data!;

                    return list.isEmpty
                        ? SliverToBoxAdapter(
                            key: widget.key,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                "Caught Up!",
                                key: widget.key,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )
                        : SliverPadding(
                            padding: const EdgeInsets.all(12.0),
                            sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                              (context, i) {
                                Subscription subscription = list[i];
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      child: Text(
                                        subscription.interval == "month"
                                            ? "M"
                                            : "Y",
                                      ),
                                    ),
                                    title: Text(subscription.subscriptionName),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "\$${(subscription.amount / 100).toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              Intl().date("MM.dd.yyyy").format(
                                                  subscription.startAt
                                                      .toDate()),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: ThemeService.primary,
                                              ),
                                            ),
                                            const Text(
                                              " - ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            Text(
                                              Intl().date("MM.dd.yyyy").format(
                                                  subscription.endAt.toDate()),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: ThemeService.error,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              childCount: list.length,
                            )),
                          );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
