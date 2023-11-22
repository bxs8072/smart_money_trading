import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTile extends StatelessWidget {
  final Function() onTap;
  final String title;
  final Color color;
  final String image;
  const CustomTile({
    Key? key,
    required this.onTap,
    required this.title,
    required this.image,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
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
