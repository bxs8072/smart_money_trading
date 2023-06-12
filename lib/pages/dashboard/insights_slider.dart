import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_money_trading/models/insight_alert.dart';
import 'package:smart_money_trading/pages/dashboard/dashboard.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:smart_money_trading/uis/trade_archives_ui/trade_archives_ui.dart';

import '../../services/navigation_service.dart';

class InsightsSlider extends StatefulWidget {
  final List<InsightAlert> list;
  const InsightsSlider({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  State<InsightsSlider> createState() => _InsightsSliderState();
}

class _InsightsSliderState extends State<InsightsSlider> {
  int current = 0;
  CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        key: widget.key,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
            title: Text(
              "Market Insights",
              key: widget.key,
              style: GoogleFonts.lato(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: TextButton(
              onPressed: () {
                NavigationService(context).push(const TradeArchives());
              },
              child: Text(
                "Trade archives",
                style: GoogleFonts.exo2(
                  fontWeight: FontWeight.w400,
                ),
                key: widget.key,
              ),
            ),
          ),
          Column(
            children: [
              CarouselSlider(
                items: widget.list.map(
                  (InsightAlert t) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: ThemeService(context).isDark
                                  ? Colors.black12
                                  : Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.0),
                                  spreadRadius: 0.0,
                                  blurRadius: 0.0,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  t.title.toUpperCase(),
                                  style: GoogleFonts.exo2(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  t.description,
                                  style: GoogleFonts.exo2(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  Intl()
                                      .date("MM.dd.yyyy hh:mm a")
                                      .format(t.createdAt.toDate()),
                                  style: GoogleFonts.exo2(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ).toList(),
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() {
                      current = index;
                    });
                  },
                  height: SizeService(context).height * 0.25,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 10),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.list.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: CircleAvatar(
                      radius: 4.0,
                      backgroundColor:
                          current == widget.list.toList().indexOf(entry)
                              ? Colors.black
                              : Colors.grey,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}