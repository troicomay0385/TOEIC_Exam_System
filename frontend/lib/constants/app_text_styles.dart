import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography definitions aligning with Roboto specifications in Figma design
class AppTextStyles {
  AppTextStyles._();

  /// Screen 1 Main Heading: "Chọn đề thi để bắt đầu làm bài!"
  /// Screen 4 Results Title: "Results of Fantasy Quiz #156"
  static const TextStyle headingLarge = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textNavy,
    height: 1.35,
    letterSpacing: -0.3,
  );

  /// Top Bar Title: "Danh sách đề thi TOEIC" / "TOEIC Reading Test 4"
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    height: 1.25,
  );

  /// Question Title / Content
  static const TextStyle questionTitle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textNavy,
    height: 1.4,
  );

  /// Option Card Label & Content (Unselected)
  static const TextStyle optionContent = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
    height: 1.3,
  );

  /// Option Card Label & Content (Selected)
  static const TextStyle optionContentSelected = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    height: 1.3,
  );

  /// Option Letter (A, B, C, D) Badge
  static const TextStyle optionLetter = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const TextStyle optionLetterSelected = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
  );

  /// Bottom Action Buttons: CONTINUE, FINISH, OKAY, Lịch sử làm bài
  static const TextStyle actionButton = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
    letterSpacing: 0.5,
  );

  /// Progress Indicator text: "1/5", "4/5", "25/100"
  static const TextStyle progressText = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
  );

  /// Card Exam Title: "TOEIC Reading Test 4"
  static const TextStyle cardTitle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  /// Metadata Badge: "75 phút", "100 câu"
  static const TextStyle badgeDuration = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle badgeQuestions = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.badgeRed,
  );

  /// Score Numbers: "850", "85/100"
  static const TextStyle resultStatNumber = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
  );

  /// Result Stat Labels: "SCORE GAINED", "CORRECT PREDICTIONS"
  static const TextStyle resultStatLabel = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    letterSpacing: 0.3,
  );
}
