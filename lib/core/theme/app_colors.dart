import 'package:flutter/material.dart';

/// D2D International — Premium Soft Green Theme
class AppColors {

  AppColors._();

  // ── Primary Brand Greens ──────────────────────────────────
  static const Color green1 =
  Color(0xFF34C759);

  static const Color green2 =
  Color(0xFF1FA34A);

  // ── Softer Modern Backgrounds ─────────────────────────────
  static const Color bg =
  Color(0xFF111827);

  static const Color bgCard =
  Color(0xFF18212F);

  static const Color card2 =
  Color(0xFF1E293B);

  // ── Glass / Borders ───────────────────────────────────────
  static const Color glass =
  Color(0x1434C759);

  static const Color glassBorder =
  Color(0x2234C759);

  // ── Accent Colours ────────────────────────────────────────
  static const Color accentTeal =
  Color(0xFF4ADE80);

  static const Color accentRed =
  Color(0xFFFF6B6B);

  static const Color accentAmber =
  Color(0xFFF59E0B);

  static const Color accentBlue =
  Color(0xFF38BDF8);

  static const Color accentPurple =
  Color(0xFFC084FC);

  // ── Text ──────────────────────────────────────────────────
  static const Color textPrimary =
      Colors.white;

  static const Color textSecondary =
  Color(0xB3FFFFFF);

  static const Color textHint =
  Color(0x66FFFFFF);

  // ── Primary Gradients ─────────────────────────────────────
  static const LinearGradient
  primaryGradient = LinearGradient(

    colors: [
      green1,
      green2,
    ],

    begin: Alignment.topLeft,

    end: Alignment.bottomRight,
  );

  static const LinearGradient
  primaryGradientH = LinearGradient(

    colors: [
      green1,
      green2,
    ],

    begin: Alignment.centerLeft,

    end: Alignment.centerRight,
  );

  static LinearGradient
  disabledGradient = LinearGradient(

    colors: [

      green1.withOpacity(0.45),

      green2.withOpacity(0.45),
    ],

    begin: Alignment.centerLeft,

    end: Alignment.centerRight,
  );

  // ── Premium Green Glow ────────────────────────────────────
  static List<BoxShadow> greenGlow({

    double blur = 24,

    Offset offset =
    const Offset(0, 10),

  }) => [

    BoxShadow(

      color:
      green1.withOpacity(0.28),

      blurRadius: blur,

      offset: offset,
    ),
  ];

  // ── Soft Card Shadow ──────────────────────────────────────
  static List<BoxShadow> softShadow = [

    BoxShadow(

      color:
      Colors.black.withOpacity(0.22),

      blurRadius: 18,

      offset: const Offset(0, 10),
    ),
  ];

  // ── Dark Glass Input Style ────────────────────────────────
  static InputDecoration darkInput(
      String label,
      IconData icon,
      ) {

    return InputDecoration(

      labelText: label,

      labelStyle: TextStyle(

        color:
        Colors.white.withOpacity(
          0.55,
        ),

        fontSize: 13,
      ),

      prefixIcon: Icon(

        icon,

        color:
        Colors.white.withOpacity(
          0.45,
        ),

        size: 20,
      ),

      filled: true,

      fillColor:
      Colors.white.withOpacity(
        0.05,
      ),

      enabledBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(16),

        borderSide: BorderSide(

          color:
          Colors.white.withOpacity(
            0.08,
          ),
        ),
      ),

      focusedBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(16),

        borderSide:
        const BorderSide(
          color: green1,
          width: 1.4,
        ),
      ),

      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
    );
  }
}