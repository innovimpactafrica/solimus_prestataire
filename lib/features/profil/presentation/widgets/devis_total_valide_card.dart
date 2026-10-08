import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class DevisTotalValideCard extends StatelessWidget {
  final double totalAmount;
  final bool isLoading;

  const DevisTotalValideCard({
    super.key,
    required this.totalAmount,
    this.isLoading = false,
  });

  String _formatAmount(double amount) {
    final str = amount.toInt().toString();
    final buf = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(' ');
      buf.write(str[i]);
    }
    return '${buf.toString()} FCFA';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 365,
      height: 96,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.splashStep1,
            AppColors.splashStep2,
            AppColors.splashStep3,
            AppColors.splashStep4,
            AppColors.splashStep5,
            AppColors.splashStep6,
            AppColors.splashStep7,
            AppColors.splashStep8,
            AppColors.splashStep9,
          ],
          stops: [
            0.0,
            0.1111,
            0.2222,
            0.3333,
            0.4444,
            0.5556,
            0.6667,
            0.7778,
            0.8889,
            1.0
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white20,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/preview.svg',
                width: 20,
                height: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Montant total validé',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 20 / 14,
                  letterSpacing: -0.15,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isLoading ? '...' : _formatAmount(totalAmount),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  height: 32 / 24,
                  letterSpacing: 0.07,
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
