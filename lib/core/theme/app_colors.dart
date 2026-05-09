import 'package:flutter/material.dart';

/// D2D International — Green Brand Palette
/// Replace old purple (0xFF667EEA / 0xFF764BA2) with these everywhere.
class AppColors {
  AppColors._();

  // ── Primary green gradient ─────────────────────────────────
  static const Color green1 = Color(0xFF2EBD52); // bright brand green
  static const Color green2 = Color(0xFF1A8A3A); // deep brand green

  // ── Backgrounds ────────────────────────────────────────────
  static const Color bg       = Color(0xFF070F09); // deepest dark bg
  static const Color bgCard   = Color(0xFF0D1F11); // card bg tint

  // ── Glass / border helpers ─────────────────────────────────
  static const Color glass       = Color(0x0F2EBD52); // green-tinted glass
  static const Color glassBorder = Color(0x2E2EBD52); // green-tinted border

  // ── Accent colours (unchanged — still work on dark green bg)
  static const Color accentTeal = Color(0xFF38EF7D); // active-dot / success
  static const Color accentRed  = Color(0xFFFF6B6B); // error / inactive
  static const Color accentAmber = Color(0xFFF0A500); // Meal Punch card
  static const Color accentBlue  = Color(0xFF0EA5E9); // Inventory card
  static const Color accentPurple = Color(0xFFA855F7); // Reports card

  // ── Text ───────────────────────────────────────────────────
  static const Color textPrimary   = Colors.white;
  static const Color textSecondary = Color(0x8CFFFFFF); // 55 % white
  static const Color textHint      = Color(0x47FFFFFF); // 28 % white

  // ── Gradient helpers ───────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [green1, green2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient primaryGradientH = const LinearGradient(
    colors: [green1, green2],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static LinearGradient disabledGradient = LinearGradient(
    colors: [green1.withOpacity(0.5), green2.withOpacity(0.5)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ── Box-shadow for green glow ─────────────────────────────
  static List<BoxShadow> greenGlow({double blur = 20, Offset offset = const Offset(0, 8)}) => [
    BoxShadow(
      color: green1.withOpacity(0.40),
      blurRadius: blur,
      offset: offset,
    ),
  ];

  // ── Input decoration (dark glass style) ───────────────────
  static InputDecoration darkInput(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.50), fontSize: 13),
      prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.40), size: 20),
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.10)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: green1, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
