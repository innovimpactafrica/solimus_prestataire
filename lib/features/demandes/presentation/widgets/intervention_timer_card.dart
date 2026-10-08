import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class InterventionTimerCard extends StatelessWidget {
  final String timerText;

  const InterventionTimerCard({
    super.key,
    required this.timerText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 365,
      height: 67,
      padding: const EdgeInsets.fromLTRB(21.5, 21.5, 21.5, 1.51),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.greenPastel, width: 1.51),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.successBright,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'En cours',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 20 / 14,
                  letterSpacing: -0.15,
                  color: AppColors.successDark,
                ),
              ),
            ],
          ),
          Text(
            timerText,
            style: const TextStyle(
              fontFamily: 'Menlo',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              height: 28 / 20,
              letterSpacing: 0,
              color: AppColors.successDark,
            ),
          ),
        ],
      ),
    );
  }
}
