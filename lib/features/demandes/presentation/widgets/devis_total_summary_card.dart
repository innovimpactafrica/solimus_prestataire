import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class DevisTotalSummaryCard extends StatelessWidget {
  final int materialsTotal;
  final int laborTotal;
  final int grandTotal;

  const DevisTotalSummaryCard({
    super.key,
    required this.materialsTotal,
    required this.laborTotal,
    required this.grandTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: AppColors.black10,
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
          BoxShadow(
            color: AppColors.black10,
            offset: Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sous-total matériel',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 20 / 14,
                  letterSpacing: -0.15,
                  color: AppColors.white70,
                ),
              ),
              Text(
                '$materialsTotal FCFA',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 20 / 14,
                  letterSpacing: -0.15,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Main d'œuvre",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 20 / 14,
                  letterSpacing: -0.15,
                  color: AppColors.white70,
                ),
              ),
              Text(
                '$laborTotal FCFA',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 20 / 14,
                  letterSpacing: -0.15,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(
            color: AppColors.white20,
            thickness: 0.5,
            height: 1,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Total',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 20 / 14,
                  letterSpacing: -0.15,
                  color: AppColors.white,
                ),
              ),
              Text(
                '$grandTotal FCFA',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  height: 28 / 20,
                  letterSpacing: -0.45,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
