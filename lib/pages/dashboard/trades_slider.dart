import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_money_trading/models/insight_alert.dart';
import 'package:smart_money_trading/models/trade_alert.dart';
import 'package:smart_money_trading/services/navigation_service.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/uis/trade_detail_ui/trade_detail_ui.dart';

class TradesSlider extends StatefulWidget {
  final List<InsightAlert> list;
  const TradesSlider({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  State<TradesSlider> createState() => _TradesSliderState();
}

class _TradesSliderState extends State<TradesSlider> {
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
              "Trades",
              key: widget.key,
              style: GoogleFonts.lato(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: TextButton(
              onPressed: () {
                // NavigationService(context).push(
                // );
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
                items: widget.list.map((InsightAlert t) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {},
                        child: Material(
                          elevation: 100,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              // image: DecorationImage(
                              //   image: t.optionType == "buy"
                              //       ? const AssetImage(
                              //           './assets/logos/biga-bull.jpg',
                              //         )
                              //       : const AssetImage(
                              //           './assets/logos/bear-market.jpeg',
                              //         ),
                              //   opacity: 0.09,
                              //   // colorFilter: const ColorFilter.mode(
                              //   //   Colors.black87,
                              //   //   BlendMode.colorDodge,
                              //   // ),
                              //   fit: BoxFit.cover,
                              // ),
                              // color: t.optiontype == "buy"
                              //     ? Colors.green
                              //     : Colors.red,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                const BoxShadow(
                                  offset: const Offset(5, 5),
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            alignment: Alignment.center,
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
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
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
