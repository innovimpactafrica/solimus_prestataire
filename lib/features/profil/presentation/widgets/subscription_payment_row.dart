import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/features/profil/data/models/profile_models.dart';

class SubscriptionPaymentRow extends StatelessWidget {
  final PaymentHistory payment;
  final bool showDivider;

  const SubscriptionPaymentRow({
    super.key,
    required this.payment,
    this.showDivider = true,
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

  String _formatDateShort(DateTime d) {
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

  String _formatPaymentMethod(String raw) {
    switch (raw.toUpperCase()) {
      case 'WAVE':
        return 'Wave';
      case 'ORANGE_MONEY':
        return 'Orange Money';
      default:
        return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPaid = payment.status.toUpperCase().contains('PAI') ||
        payment.status.toUpperCase().contains('PAY') ||
        payment.status.toUpperCase() == 'SUCCESS';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  payment.planName,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: isPaid ? AppColors.successLight : AppColors.grey100,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    isPaid ? 'Payé' : payment.status,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color:
                          isPaid ? AppColors.greenEmerald : AppColors.greySlate,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              _formatAmount(payment.amount),
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          payment.reference,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: AppColors.greySlate,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${_formatDateShort(payment.date)} • ${_formatPaymentMethod(payment.paymentMethod)}',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: AppColors.greySlate,
          ),
        ),
        if (showDivider) ...[
          const SizedBox(height: 14),
          const Divider(color: AppColors.grey100, thickness: 1, height: 1),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}
