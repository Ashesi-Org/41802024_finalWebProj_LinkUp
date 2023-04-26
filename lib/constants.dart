import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/* creating constants for app color and theme */
class AppColors {
  static const primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE1F5FE),
      Color(0xFFB3E5FC),
      Color(0xFF81D4FA),
      Color(0xFF4FC3F7),
      Color(0xFF2196F3),
      Color(0xFF1976D2),
    ],
  );

  static final linkUpText = Text(
    'LinkUp',
    style: GoogleFonts.pacifico(
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}
