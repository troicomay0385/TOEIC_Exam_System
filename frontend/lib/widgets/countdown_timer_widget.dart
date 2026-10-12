import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Countdown timer badge widget reflecting Figma Group 14:310
class CountdownTimerWidget extends StatelessWidget {
  final int remainingSeconds;

  const CountdownTimerWidget({
    super.key,
    required this.remainingSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    final formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    final isUrgent = remainingSeconds < 300; // less than 5 minutes

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isUrgent
            ? AppColors.badgeRed.withValues(alpha: 0.12)
            : AppColors.cardDefault,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isUrgent ? AppColors.badgeRed : AppColors.borderSubtle,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 15,
            color: isUrgent ? AppColors.badgeRed : AppColors.textNavy,
          ),
          const SizedBox(width: 5),
          Text(
            formattedTime,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isUrgent ? AppColors.badgeRed : AppColors.textNavy,
            ),
          ),
        ],
      ),
    );
  }
}
