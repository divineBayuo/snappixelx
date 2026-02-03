import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Powered by BayuoTech',
          style: GoogleFonts.playfair(fontSize: 12, color: Colors.white),
        ),
        Text(
          '© Copyright 2026',
          style: GoogleFonts.playfair(fontSize: 12, color: Colors.white),
        ),
      ],
    );
  }
}
