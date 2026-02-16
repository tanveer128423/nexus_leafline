import 'package:flutter/material.dart';

/// Premium eco-themed design system for Nexus Leafline
class AppColors {
  // Light mode colors
  static const primaryGreen = Color(0xFF2D5A3D); // Deep forest green
  static const secondaryGreen = Color(0xFF4A7C59); // Medium green
  static const lightSage = Color(0xFFB8D4C0); // Light sage
  static const veryLightSage = Color(0xFFE8F3EC); // Very light sage
  static const offWhite = Color(0xFFFAFBF8); // Soft off-white
  static const earthyBrown = Color(0xFF8B7355); // Subtle earthy brown
  static const accentAmber = Color(0xFFD4A373); // Warm accent

  // Status colors
  static const statusGood = Color(0xFF4CAF50); // Green
  static const statusWarning = Color(0xFFFFA726); // Amber/Orange
  static const statusCritical = Color(0xFFEF5350); // Red
  static const statusInfo = Color(0xFF42A5F5); // Blue

  // Dark mode colors
  static const darkBackground = Color(0xFF0F1713); // Forest-themed dark
  static const darkSurface = Color(0xFF1A2622); // Slightly lighter
  static const darkCard = Color(0xFF212E28); // Card background
  static const darkGreen = Color(0xFF5A8A6E); // Soft green highlight

  // Neutral colors
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF666666);
  static const textTertiary = Color(0xFF999999);
  static const divider = Color(0xFFE0E0E0);
}

class AppTypography {
  static const fontFamily = 'Inter'; // Modern sans-serif

  // Display styles
  static const display = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.2,
  );

  // Heading styles
  static const h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static const h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.4,
  );

  // Body styles
  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // Label styles
  static const label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );

  static const caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
  );
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double pill = 100;
}

class AppShadows {
  static List<BoxShadow> get small => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get medium => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get large => [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get hover => [
    BoxShadow(
      color: AppColors.primaryGreen.withOpacity(0.15),
      blurRadius: 20,
      offset: const Offset(0, 8),
      spreadRadius: 2,
    ),
  ];
}

class AppAnimations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve entrance = Curves.easeOut;
  static const Curve exit = Curves.easeIn;
}
