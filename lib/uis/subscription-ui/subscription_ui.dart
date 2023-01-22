import 'package:flutter/material.dart';
import 'package:smart_money_trading/apis/stripe_api.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:smart_money_trading/uis/subscription-ui/subscription_card.dart';
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
  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              key: widget.key,
              title: Text(
                "Subscriptions",
                key: widget.key,
              ),
            ),
            StreamBuilder(builder: (context, snapshot) {
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
                if (!snapshot.hasData) {
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
                                customerId: widget.customer.stripeCustomerId!,
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
                                customerId: widget.customer.stripeCustomerId!,
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
                  return SliverToBoxAdapter(
                    child: Column(
                      children: [],
                    ),
                  );
                }
              }
            }),
          ],
        ),
      ),
    );
  }
}
