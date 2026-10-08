import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class DashboardMetricCard extends StatelessWidget {
  final Color iconBgColor;
  final String iconPath;
  final String count;
  final String label;
  final String trend;
  final Color trendColor;
  final double trendFontSize;

  const DashboardMetricCard({
    super.key,
    required this.iconBgColor,
    required this.iconPath,
    required this.count,
    required this.label,
    required this.trend,
    required this.trendColor,
    this.trendFontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 119,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white, width: 0.5),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(14),
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
                child: Center(
                  child: SvgPicture.asset(iconPath, width: 20, height: 20),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                count,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  height: 1.2,
                  letterSpacing: 0.07,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 4),
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
          Positioned(
            top: 14,
            right: 0,
            child: Text(
              trend,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: trendFontSize,
                height: 16 / trendFontSize,
                letterSpacing: 0,
                color: trendColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
