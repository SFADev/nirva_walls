import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FreeWallTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: GoogleFonts.openSans(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    displayLarge: GoogleFonts.openSans(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    displayMedium: GoogleFonts.openSans(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    displaySmall: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    titleLarge: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyLarge: GoogleFonts.openSans(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    displayLarge: GoogleFonts.openSans(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displayMedium: GoogleFonts.openSans(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    displaySmall: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleLarge: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      // colorscheme
      colorScheme: ColorScheme.light(
        surface: Colors.white,
        primary: Colors.grey[300]!,
        onPrimary: Colors.grey[100]!,
        secondary: Colors.grey[200]!,
        shadow: const Color(0xfff4f5f6),
      ),
      // appbar theme
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
      ),
      //icon theme
      iconTheme: const IconThemeData(
        color: Colors.deepPurpleAccent,
      ),
      // bottomnav theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedIconTheme: IconThemeData(
          color: Color.fromARGB(100, 33, 33, 33),
        ),
      ),
      textTheme: lightTextTheme,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      // colorscheme
      colorScheme: ColorScheme.dark(
        surface: Colors.grey[900]!,
        primary: Colors.grey[850]!,
        onPrimary: Colors.grey[700]!,
        secondary: Colors.grey[800]!,
        shadow: Colors.grey[800],
      ),
      // appbar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
      ),
      //icon theme
      iconTheme: const IconThemeData(
        color: Colors.deepPurpleAccent,
      ),
      // bottomnav theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Color.fromARGB(255, 70, 70, 70),
      ),
      textTheme: darkTextTheme,
    );
  }
}
