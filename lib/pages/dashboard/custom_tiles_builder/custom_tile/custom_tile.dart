import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_money_trading/services/size_service.dart';

class CustomTile extends StatelessWidget {
  final Function() onTap;
  final String top;
  final String title;
  final double height;
  final double weight;
  final Color color;
  final Image image;
  const CustomTile({
    Key? key,
    required this.onTap,
    required this.top,
    required this.title,
    required this.height,
    required this.image,
    required this.weight,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Material(
            elevation: 20,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image.image,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20),
                color: color,
              ),
              alignment: Alignment.center,
              height: SizeService(context).height * height,
              width: SizeService(context).height * weight,
              child: Text(
                top,
                textAlign: TextAlign.center,
                style: GoogleFonts.exo2(
                  fontSize: 25.0,
                  color: const Color.fromARGB(255, 238, 241, 242),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: GoogleFonts.exo2(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
