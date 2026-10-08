import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class VersementBalanceCard extends StatelessWidget {
  final double soldeDisponible;
  final String formattedAmount;

  const VersementBalanceCard({
    super.key,
    required this.soldeDisponible,
    required this.formattedAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 365,
      height: 89,
      padding: const EdgeInsets.only(
        top: 16.5,
        right: 16.5,
        bottom: 0.5,
        left: 16.5,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey100, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/solde1.svg',
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'Solde disponible',
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
              fontSize: 24,
              height: 32 / 24,
              letterSpacing: 0.07,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
