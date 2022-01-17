import 'package:flutter/material.dart';

class Layout {
  static const double margin = 16.0;
  static const double largeMargin = margin * 2;
}

class AppColors {
  static const Color _primaryColor = Color(0xFF363286);
  static const Map<int, Color> _primaryShades = {
    50: Color(0xFFb7b5e3),
    100: Color(0xFFa5a2dd),
    200: Color(0xFF938fd6),
    300: Color(0xFF817dcf),
    400: Color(0xFF6f6ac8),
    500: Color(0xFF5d57c1),
    600: Color(0xFF4b45ba),
    700: Color(0xFF433ea8),
    800: Color(0xFF3c3795),
    900: Color(0xFF363286),
  };

  static MaterialColor get primary =>
      MaterialColor(_primaryColor.hashCode, _primaryShades);
  static const Color secondary = Color(0xFF5CC3A6);
}

// TODO: SecretKeys should be saved in an .env file to avoid exposing keys publicly in a repo, but for ease to run the app, it's been hardcoded.

class SecretKeys {
  static const serpApiKey =
      'fa05c38eab7070ea9a180a1147b3e73f1cb9ca67de3f34706558f2fde3bc801e';
  static const invalidSerpApiKey =
      'fbd7c4de656fd519286b65b273c80427a6324a55734ffa32cc416764515b2daa'; // for testing errors
}
