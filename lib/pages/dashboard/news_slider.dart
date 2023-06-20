import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsSlider extends StatefulWidget {
  final List<Map<String, dynamic>> list;
  const NewsSlider({super.key, required this.list});

  @override
  State<NewsSlider> createState() => _NewsSliderState();
}

class _NewsSliderState extends State<NewsSlider> {
  int current = 0;
  CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(0.90),
        //   child: Text(
        //     "Top News",
        //     textAlign: TextAlign.start,
        //     style: GoogleFonts.lato(
        //       fontSize: 16.0,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: CarouselSlider(
            items: widget.list.map((Map<String, dynamic> data) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            data["image"][0]["url"],
                          ),
                          opacity: 90,
                          colorFilter: const ColorFilter.mode(
                            Colors.black87,
                            BlendMode.colorDodge,
                          ),
                          fit: BoxFit.cover,
                        ),
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(31, 12, 10, 12),
                            offset: Offset(2, 2),
                            blurRadius: 2,
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data['title'],
                            style: GoogleFonts.lato(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                            maxLines: 4,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            data['author'],
                            style: GoogleFonts.lato(
                              letterSpacing: 0.2,
                              color: Colors.white,
                            ),
                          ),
                        ],
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
              // height: 400.0,
              aspectRatio: 9 / 18,
              viewportFraction: 3.0,
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
                backgroundColor: current == widget.list.toList().indexOf(entry)
                    ? Colors.black
                    : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
