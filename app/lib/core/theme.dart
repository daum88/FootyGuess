import 'package:flutter/material.dart';

/// App theme configuration with glassmorphic design
class AppTheme {
  // Colors
  static const Color primaryGreen = Color(0xFF00A86B);
  static const Color darkBackground = Color(0xFF0A0A0A);
  static const Color cardBackground = Color(0xFF1A1A1A);
  static const Color glassBackground = Color(0x1AFFFFFF);
  static const Color correctGreen = Color(0xFF4CAF50);
  static const Color partialYellow = Color(0xFFFFC107);
  static const Color incorrectRed = Color(0xFFF44336);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);

  // Game Mode Colors
  static const Map<String, Color> gameModeColors = {
    'guess_player': Color(0xFF2196F3),
    'career_path': Color(0xFF9C27B0),
    'who_scored': Color(0xFFFF5722),
    'tenable': Color(0xFF4CAF50),
    'missing_xi': Color(0xFFFF9800),
    'tic_tac_toe': Color(0xFF795548),
  };

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryGreen,
        surface: cardBackground,
        onPrimary: Colors.white,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
        ),
      ),
    );
  }

  static Color getGameModeColor(String mode) {
    return gameModeColors[mode] ?? primaryGreen;
  }

  static BoxDecoration get glassDecoration {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: glassBackground,
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.1),
        width: 1,
      ),
    );
  }

  static BoxDecoration glassMorphism({
    Color? color,
    double borderRadius = 16,
    double borderWidth = 1,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: color ?? glassBackground,
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.1),
        width: borderWidth,
      ),
    );
  }
}
