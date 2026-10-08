import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/features/demandes/data/models/devis_models.dart';

class MesDevisItemCard extends StatelessWidget {
  final DevisSummary devis;
  final VoidCallback? onTap;

  const MesDevisItemCard({
    super.key,
    required this.devis,
    this.onTap,
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

  String _statusLabel(String status) {
    switch (status) {
      case 'ACCEPTED':
        return 'Validé';
      case 'SENT':
        return 'En attente';
      case 'DRAFT':
        return 'Brouillon';
      case 'REJECTED':
        return 'Refusé';
      default:
        return status;
    }
  }

  Color _badgeBg(String status) {
    switch (status) {
      case 'ACCEPTED':
        return AppColors.mintBg;
      case 'SENT':
        return AppColors.creamLight2;
      case 'DRAFT':
        return AppColors.grey100;
      case 'REJECTED':
        return AppColors.errorLight;
      default:
        return AppColors.grey100;
    }
  }

  Color _badgeText(String status) {
    switch (status) {
      case 'ACCEPTED':
        return AppColors.success;
      case 'SENT':
        return AppColors.orangeDark;
      case 'DRAFT':
        return AppColors.greySlate;
      case 'REJECTED':
        return AppColors.errorRed;
      default:
        return AppColors.greySlate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 365,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  devis.reference,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    height: 1.0,
                    letterSpacing: 0,
                    color: AppColors.primaryDark,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: _badgeBg(devis.status),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _statusLabel(devis.status),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      height: 1.0,
                      color: _badgeText(devis.status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              devis.requestTitle,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                height: 1.2,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.grey100, thickness: 1, height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(devis.createdAt),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    height: 1.0,
                    color: AppColors.greySlate,
                  ),
                ),
                Text(
                  _formatAmount(devis.totalAmount),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 1.0,
                    letterSpacing: -0.3,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
