import 'package:flutter/material.dart';

/// App color palette extracted directly from Figma Design:
/// "Quiz Mobile and Web App Design (Community)"
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color canvasBackground = Color(0xFFEDE8E3); // Figma fill_4377bf75
  static const Color cardDefault = Color(0xFFF4F3F6);      // Figma fill_a32917b4
  static const Color cardSelected = Color(0xFF45C486);     // Figma #45C486 (selected option)
  static const Color cardSelectedDark = Color(0xFF38A169);

  // Brand / Action Buttons
  static const Color brandGreen = Color(0xFF31CD63);       // Figma #31CD63 (CONTINUE, FINISH, OKAY)
  static const Color brandGreenPressed = Color(0xFF28A745);

  // Typography & Content
  static const Color textNavy = Color(0xFF191D63);         // Figma fill_d4e6e515 (Headings)
  static const Color textDark = Color(0xFF060710);         // Figma fill_eb2cf9ea (Primary text)
  static const Color textMuted = Color(0xFF757575);        // Figma fill_97744796 (Subtitles/Progress)
  static const Color textWhite = Color(0xFFFFFFFF);        // White text

  // Badges & Accents
  static const Color badgeRed = Color(0xFFA40021);         // Figma fill_0fc96e0d (Question count tag)
  static const Color badgeGreen = Color(0xFF20BA6E);       // Figma fill_92368762 (Positive indicator)
  static const Color trophyGold = Color(0xFFFFB800);       // Gold trophy & badges
  static const Color warningOrange = Color(0xFFFF9800);    // Timer warning

  // Borders & Dividers
  static const Color divider = Color(0xFFDDD9D4);
  static const Color borderSubtle = Color(0xFFE0DFE5);
  static const Color optionCircleBg = Color(0xFFEDE8E3);
  static const Color optionCircleSelected = Color(0xFF32A86A);

  // Shadows
  static const Color shadow = Color(0x14000000);
}
