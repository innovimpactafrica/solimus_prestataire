import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class WalletBalanceCard extends StatelessWidget {
  final double balance;
  final VoidCallback onWithdrawTap;

  const WalletBalanceCard({
    super.key,
    required this.balance,
    required this.onWithdrawTap,
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
      width: 360,
      height: 176,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary80],
          stops: [0.0, 0.6354],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset('assets/icons/solde.svg', width: 16, height: 16),
              const SizedBox(width: 6),
              Text(
                'Solde disponible',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  height: 16 / 12,
                  letterSpacing: 0,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _formatAmount(balance),
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 30,
              height: 36 / 30,
              letterSpacing: 0.4,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onWithdrawTap,
            child: Container(
              width: 335,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/demand.svg',
                      width: 16, height: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Demander un versement',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 20 / 14,
                      letterSpacing: -0.15,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
