import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/features/wallet/data/models/wallet_models.dart';

class TransactionRow extends StatelessWidget {
  final WalletTransaction tx;

  const TransactionRow({super.key, required this.tx});

  String _formatAmount(double amount) {
    final str = amount.toInt().toString();
    final buf = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(' ');
      buf.write(str[i]);
    }
    return '${buf.toString()} FCFA';
  }

  String _formatDate(DateTime d) {
    const months = [
      '',
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Jun',
      'Jul',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc'
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isEntree = tx.isEntree;

    final Color badgeColor;
    final String iconPath;
    final Color amountColor;

    if (isEntree) {
      badgeColor = AppColors.successBg;
      iconPath = 'assets/icons/vert.svg';
      amountColor = AppColors.greenEmerald;
    } else {
      badgeColor = AppColors.infoLight;
      iconPath = 'assets/icons/bleu.svg';
      amountColor = AppColors.infoBlue;
    }

    final String amountStr = isEntree
        ? '+${_formatAmount(tx.amount)}'
        : '-${_formatAmount(tx.amount)}';

    return Container(
      width: 360,
      padding: const EdgeInsets.only(
        top: 16.5,
        right: 16.5,
        bottom: 0.5,
        left: 16.5,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.white, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(iconPath, width: 16, height: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.label,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 20 / 14,
                    letterSpacing: -0.15,
                    color: AppColors.primaryDark,
                  ),
                ),
                Text(
                  _formatDate(tx.transactionDate),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 16 / 12,
                    letterSpacing: 0,
                    color: AppColors.greySlate,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amountStr,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  height: 20 / 14,
                  letterSpacing: -0.15,
                  color: amountColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
