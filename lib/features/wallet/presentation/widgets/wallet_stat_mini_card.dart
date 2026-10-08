import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class WalletStatMiniCard extends StatelessWidget {
  final String iconPath;
  final Color iconBgColor;
  final String label;
  final String formattedAmount;

  const WalletStatMiniCard({
    super.key,
    required this.iconPath,
    required this.iconBgColor,
    required this.label,
    required this.formattedAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 99,
      padding: const EdgeInsets.only(
        top: 16.5,
        right: 16.5,
        bottom: 0.5,
        left: 16.5,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.white, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SvgPicture.asset(
                  iconPath,
                  width: 16,
                  height: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  height: 16 / 12,
                  letterSpacing: 0,
                  color: AppColors.greySlate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formattedAmount,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              height: 24 / 16,
              letterSpacing: -0.3,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
