import 'package:flutter/material.dart';

/// Centralized color palette according to Innov & Impact Africa Guidelines.
/// No hardcoded Color(0x...) is allowed in widgets or screens.
class AppColors {
  AppColors._();

  // Primary Theme Colors (Solimus Warm Brown)
  static const Color primary = Color(0xFF6F675E);
  static const Color primaryDark = Color(0xFF2D2520);
  static const Color primaryDeep = Color(0xFF2D2520);
  static const Color primaryLight = Color(0xFF8B7355);
  static const Color warmGrey = Color(0xFFD6D2C9);

  // Splash Screen Gradation Steps
  static const Color splashStep1 = Color(0xFF6D655C);
  static const Color splashStep2 = Color(0xFF6A625A);
  static const Color splashStep3 = Color(0xFF686058);
  static const Color splashStep4 = Color(0xFF665E55);
  static const Color splashStep5 = Color(0xFF635B53);
  static const Color splashStep6 = Color(0xFF615951);
  static const Color splashStep7 = Color(0xFF5F574F);
  static const Color splashStep8 = Color(0xFF5C544D);
  static const Color splashStep9 = Color(0xFF5A524B);

  // Primary with Opacity
  static const Color primary5 = Color(0x0D6F675E);
  static const Color primary10 = Color(0x1A6F675E);
  static const Color primary68 = Color(0xAD6F675E);
  static const Color primary70 = Color(0xB36F675E);
  static const Color primary80 = Color(0xCC6F675E);
  static const Color primary85 = Color(0xD96F675E);

  // Backgrounds
  static const Color background = Color(0xFFFAF9F4);
  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color backgroundGrey = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFFEFEFE);
  static const Color surfaceMuted = Color(0xFFFDFDFD);
  static const Color splashBackground = Color(0xFF6F675E);
  static const Color creamLight = Color(0xFFFFF8E7);
  static const Color creamLight2 = Color(0xFFFFF8E6);

  // Pure Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color blackDark = Color(0xFF0A0A0A);
  static const Color black1C = Color(0xFF1C1B1B);
  static const Color darkNeutral = Color(0xFF292B2D);

  // White with Opacity
  static const Color white10 = Color(0x1AFFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color white90 = Color(0xE5FFFFFF);

  // Black with Opacity
  static const Color black10 = Color(0x1A000000);
  static const Color black40 = Color(0x66000000);
  static const Color black60 = Color(0x99000000);
  static const Color overlayDark = Color(0x800A0A0A);
  static const Color barrier = Color(0x66000000);

  // Greys
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4A5565);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyE0 = Color(0xFFE0E0E0);
  static const Color greyE8 = Color(0xFFE8E8E8);
  static const Color greyBorder = Color(0xFFBBBBBB);
  static const Color greySlate = Color(0xFF6A7282);
  static const Color greyCool = Color(0xFF91919F);
  static const Color greyCool2 = Color(0xFF747D8C);
  static const Color grey500Half = Color(0x806B7280);

  // Typography / Text Colors
  static const Color textPrimary = Color(0xFF202221);
  static const Color textSecondary = Color(0xFF646B78);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textDark = Color(0xFF1E232C);
  static const Color textHint = Color(0x4D202221);
  static const Color textLabel = Color(0xFF646B78);
  static const Color textSubtitle = Color(0xFF8391A1);
  static const Color textDisabled = Color(0xFF9EA8B3);
  static const Color textBlack60 = Color(0x99202221);
  static const Color textPrimary60 = Color(0x99231F20);
  static const Color textCharcoal = Color(0xFF231F20);
  static const Color textBrownMuted = Color(0xFF696159);
  static const Color charcoal = Color(0xFF2F3542);
  static const Color charcoal60 = Color(0x99212121);
  static const Color charcoal50 = Color(0x80212121);
  static const Color slate400 = Color(0xFF99A1AF);
  static const Color slate600 = Color(0xFF4A5565);
  static const Color slate700 = Color(0xFF575B66);

  // Success / Green
  static const Color success = Color(0xFF0A9748);
  static const Color successBright = Color(0xFF00C950);
  static const Color successDark = Color(0xFF0D542B);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color successBg = Color(0xFFF0FDF4);
  static const Color success10 = Color(0x1A0A9748);
  static const Color green = Color(0xFF4CAF50);
  static const Color greenEmerald = Color(0xFF00A63E);
  static const Color greenNeon = Color(0xFF05DF72);
  static const Color greenMedium = Color(0xFF1EA438);
  static const Color greenPastel = Color(0xFFB9F8CF);
  static const Color mintBg = Color(0xFFEBFAF0);

  // Warning / Yellow / Amber
  static const Color warning = Color(0xFFF9C20A);
  static const Color warningText = Color(0xFF973C00);
  static const Color warningDark = Color(0xFF7B3306);
  static const Color amberDark = Color(0xFF7B3306);
  static const Color warningLight = Color(0xFFFEF3C6);
  static const Color warningBg = Color(0xFFFFFBEB);
  static const Color amberBg = Color(0xFFFFFBEB);
  static const Color warning10 = Color(0x1AF9C20A);
  static const Color amberLight = Color(0xFFFEE685);
  static const Color amber10 = Color(0x1AFE9A00);
  static const Color orangeDark = Color(0xFFC37600);

  // Error / Danger / Red
  static const Color error = Color(0xFFFD3C4A);
  static const Color errorRed = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFFEEEE);
  static const Color redBg = Color(0xFFFFEEEE);
  static const Color error10 = Color(0x1AFD3C4A);
  static const Color coral = Color(0xFFFF6B6B);
  static const Color coral5 = Color(0x0DFF6B6B);
  static const Color rust20 = Color(0x1F97392D);

  // Info / Blue
  static const Color info = Color(0xFF1447E6);
  static const Color infoBlue = Color(0xFF155DFC);
  static const Color infoSky = Color(0xFF2B7FFF);
  static const Color infoLight = Color(0xFFEFF6FF);
  static const Color blueBg = Color(0xFFEFF6FF);
  static const Color blueText = Color(0xFF1447E6);
  static const Color info10 = Color(0x1A1447E6);

  // Accent / Purple
  static const Color purple = Color(0xFFAD46FF);
  static const Color purple10 = Color(0x1AAD46FF);

  // Borders & Dividers
  static const Color border = Color(0xFFE8E4DC);
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderMedium = Color(0xFFD1D5DB);
  static const Color borderDark = Color(0xFFD6D2C9);
  static const Color borderD1 = Color(0xFFD1D5DC);
  static const Color divider = Color(0xFFE5E7EB);
}
