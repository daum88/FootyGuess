import 'package:flutter/material.dart';
import 'dart:ui';

/// Modern light theme with glassmorphism and retro-inspired pastels
/// Design: airy, bright, calm, friendly
class ModernTheme {
  // --- LIGHT COLOR PALETTE ---
  // Soft pastels with low contrast
  static const Color backgroundLight = Color(0xFFF8F9FA); // Very light gray
  static const Color backgroundAccent = Color(0xFFFFFFFF); // Pure white
  
  // Soft pastel accents - retro inspired
  static const Color accentPeach = Color(0xFFFFD4CC); // Soft peach
  static const Color accentLavender = Color(0xFFE8DEF8); // Soft lavender
  static const Color accentMint = Color(0xFFCCF5E1); // Soft mint
  static const Color accentSky = Color(0xFFCCE7FF); // Soft sky blue
  static const Color accentRose = Color(0xFFFFDDE7); // Soft rose
  static const Color accentSunset = Color(0xFFFFE5CC); // Soft sunset
  
  // Neutral tones
  static const Color textPrimary = Color(0xFF2C2C2C); // Soft black
  static const Color textSecondary = Color(0xFF6B6B6B); // Medium gray
  static const Color textTertiary = Color(0xFF9E9E9E); // Light gray
  
  // Semantic colors - muted
  static const Color successGreen = Color(0xFFA8E6CF); // Soft green
  static const Color warningAmber = Color(0xFFFFE4B5); // Soft amber
  static const Color errorRose = Color(0xFFFFB6C1); // Soft red/pink
  
  // Glass effect colors
  static const Color glassSurface = Color(0xF0FFFFFF); // Almost opaque white
  static const Color glassOverlay = Color(0x40FFFFFF); // Translucent white
  static const Color glassBorder = Color(0x20000000); // Very subtle border
  
  // --- TYPOGRAPHY ---
  static const String fontFamily = 'Inter'; // Clean, modern sans-serif
  
  static const TextTheme textTheme = TextTheme(
    // Headings
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
      height: 1.2,
      color: textPrimary,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      height: 1.3,
      color: textPrimary,
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      height: 1.3,
      color: textPrimary,
    ),
    
    // Titles
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.4,
      color: textPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.4,
      color: textPrimary,
    ),
    
    // Body
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.5,
      color: textPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.5,
      color: textSecondary,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.5,
      color: textTertiary,
    ),
    
    // Labels
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.4,
      color: textPrimary,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.4,
      color: textSecondary,
    ),
  );
  
  // --- SHAPES ---
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 32.0;
  static const double radiusPill = 999.0; // Full pill shape
  
  // --- SPACING ---
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;
  
  // --- THEME DATA ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: fontFamily,
      
      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: accentLavender,
        onPrimary: textPrimary,
        secondary: accentPeach,
        onSecondary: textPrimary,
        tertiary: accentMint,
        surface: backgroundAccent,
        onSurface: textPrimary,
        surfaceContainerHighest: backgroundLight,
        error: errorRose,
        onError: textPrimary,
      ),
      
      scaffoldBackgroundColor: backgroundLight,
      
      // AppBar
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: textPrimary,
        ),
      ),
      
      // Card
      cardTheme: CardThemeData(
        elevation: 0,
        color: glassSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          side: const BorderSide(
            color: glassBorder,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(0),
      ),
      
      // Elevated Button - pill shaped
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: accentLavender,
          foregroundColor: textPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusPill),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusPill),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
      
      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: glassSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusPill),
          borderSide: const BorderSide(
            color: glassBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusPill),
          borderSide: const BorderSide(
            color: glassBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusPill),
          borderSide: const BorderSide(
            color: accentLavender,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: const TextStyle(
          color: textTertiary,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
      
      textTheme: textTheme,
    );
  }
  
  // --- GLASS MORPHISM DECORATIONS ---
  
  /// Primary glass card - main content containers
  static BoxDecoration glassCard({
    Color? color,
    double? borderRadius,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: color ?? glassSurface,
      borderRadius: BorderRadius.circular(borderRadius ?? radiusMedium),
      border: Border.all(
        color: glassBorder,
        width: 1,
      ),
      boxShadow: shadows ?? softShadow,
    );
  }
  
  /// Floating glass element - elevated interactive elements
  static BoxDecoration glassFloating({
    Color? color,
    double? borderRadius,
  }) {
    return BoxDecoration(
      color: color ?? glassSurface,
      borderRadius: BorderRadius.circular(borderRadius ?? radiusMedium),
      border: Border.all(
        color: glassBorder,
        width: 1,
      ),
      boxShadow: floatingShadow,
    );
  }
  
  /// Subtle glass overlay - background decorations
  static BoxDecoration glassOverlayDecoration({
    Color? color,
    double? borderRadius,
  }) {
    return BoxDecoration(
      color: color ?? glassOverlay,
      borderRadius: BorderRadius.circular(borderRadius ?? radiusMedium),
      border: Border.all(
        color: glassBorder,
        width: 1,
      ),
    );
  }
  
  /// Gradient glass - for headers and accent areas
  static BoxDecoration glassGradient({
    required List<Color> colors,
    double? borderRadius,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ),
      borderRadius: BorderRadius.circular(borderRadius ?? radiusMedium),
      border: Border.all(
        color: glassBorder,
        width: 1,
      ),
      boxShadow: softShadow,
    );
  }
  
  // --- SHADOWS ---
  
  /// Soft shadow for cards
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.02),
      blurRadius: 24,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
  ];
  
  /// Floating shadow for interactive elements
  static List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 16,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.03),
      blurRadius: 32,
      offset: const Offset(0, 12),
      spreadRadius: 0,
    ),
  ];
  
  /// Inner glow effect
  static List<BoxShadow> innerGlow(Color color) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.3),
        blurRadius: 8,
        offset: const Offset(0, 0),
        spreadRadius: -2,
      ),
    ];
  }
  
  // --- GRADIENTS ---
  
  /// Soft pastel gradient - retro inspired
  static const LinearGradient softGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFE5F1), // Soft pink
      Color(0xFFE5F1FF), // Soft blue
    ],
  );
  
  /// Warm gradient
  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      accentPeach,
      accentSunset,
    ],
  );
  
  /// Cool gradient
  static const LinearGradient coolGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      accentLavender,
      accentSky,
    ],
  );
  
  /// Fresh gradient
  static const LinearGradient freshGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      accentMint,
      accentSky,
    ],
  );
  
  // --- BLUR EFFECTS ---
  
  /// Apply backdrop blur to a widget
  static Widget withBackdropBlur({
    required Widget child,
    double sigmaX = 10,
    double sigmaY = 10,
  }) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: child,
      ),
    );
  }
  
  // --- ANIMATION DURATIONS ---
  
  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 400);
  
  // --- ANIMATION CURVES ---
  
  /// Smooth, natural easing
  static const Curve smoothCurve = Curves.easeInOutCubic;
  
  /// Bounce effect for playful interactions
  static const Curve bounceCurve = Curves.elasticOut;
  
  /// Quick snap for instant feedback
  static const Curve snapCurve = Curves.easeOutCubic;
}
