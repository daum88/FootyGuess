import 'package:flutter/material.dart';

class RetroTheme {
  // Color scheme inspired by early 2000s with the dark purple from screenshots
  static const Color primaryPurple =
      Color(0xFF2A1B3D); // Dark purple from screenshots
  static const Color accentGreen = Color(0xFF00FF7F); // Bright retro green
  static const Color backgroundDark =
      Color(0xFF1A1B2E); // Keep current dark background
  static const Color cardPurple = Color(0xFF2D2E47); // Keep current card color
  static const Color neonBlue = Color(0xFF00BFFF); // Bright blue accent
  static const Color retroOrange = Color(0xFFFF6B35); // Retro orange
  static const Color heartRed =
      Color(0xFFFF1744); // Bright red for hearts/lives

  // Retro font styles with bold, chunky appearance
  static const TextStyle retroHeader = TextStyle(
    fontFamily: 'Arial',
    fontSize: 28,
    fontWeight: FontWeight.w900, // Extra bold for retro feel
    letterSpacing: 1.2,
    shadows: [
      Shadow(
        offset: Offset(2, 2),
        blurRadius: 4,
        color: Colors.black26,
      ),
    ],
  );

  static const TextStyle retroSubheader = TextStyle(
    fontFamily: 'Arial',
    fontSize: 18,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.8,
  );

  static const TextStyle retroBody = TextStyle(
    fontFamily: 'Arial',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle retroButton = TextStyle(
    fontFamily: 'Arial',
    fontSize: 16,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.0,
  );

  // Retro button style with chunky borders and gradients
  static ButtonStyle retroButtonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    elevation: 6,
    shadowColor: Colors.black38,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: Colors.white24, width: 2),
    ),
  );

  // Retro container decoration with glass effect
  static BoxDecoration retroContainer({
    Color? color,
    bool hasGradient = false,
    bool hasBorder = true,
  }) {
    return BoxDecoration(
      color: color ?? cardPurple,
      gradient: hasGradient
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                (color ?? cardPurple).withOpacity(0.9),
                (color ?? cardPurple).withOpacity(0.7),
              ],
            )
          : null,
      borderRadius: BorderRadius.circular(12),
      border: hasBorder
          ? Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            )
          : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(2, 4),
        ),
      ],
    );
  }

  // Animated glow effect for interactive elements
  static BoxDecoration retroGlow({
    required Color glowColor,
    double glowRadius = 20,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: glowColor.withOpacity(0.5),
          blurRadius: glowRadius,
          spreadRadius: glowRadius / 4,
        ),
      ],
    );
  }

  // Pyramid row style for Tenable game
  static BoxDecoration pyramidRow({
    required bool isRevealed,
    required int position,
  }) {
    return BoxDecoration(
      color: isRevealed ? accentGreen.withOpacity(0.8) : cardPurple,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: isRevealed ? accentGreen : Colors.white.withOpacity(0.3),
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: isRevealed
              ? accentGreen.withOpacity(0.3)
              : Colors.black.withOpacity(0.3),
          blurRadius: isRevealed ? 12 : 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Jersey/shirt style for Missing XI
  static BoxDecoration jerseyStyle({
    required Color teamColor,
    bool isRevealed = false,
  }) {
    return BoxDecoration(
      color: isRevealed ? teamColor : cardPurple,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: Colors.white.withOpacity(0.4),
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 6,
          offset: const Offset(2, 2),
        ),
      ],
    );
  }
}

// Animation utilities for retro effects
class RetroAnimations {
  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration normalDuration = Duration(milliseconds: 400);
  static const Duration slowDuration = Duration(milliseconds: 600);

  // Bounce animation for correct answers
  static AnimationController createBounceController(TickerProvider vsync) {
    return AnimationController(
      duration: normalDuration,
      vsync: vsync,
    );
  }

  // Shake animation for incorrect answers
  static Animation<double> createShakeAnimation(
      AnimationController controller) {
    return Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.elasticIn,
    ));
  }

  // Fade and scale animation for reveals
  static Animation<double> createRevealAnimation(
      AnimationController controller) {
    return Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.elasticOut,
    ));
  }
}
