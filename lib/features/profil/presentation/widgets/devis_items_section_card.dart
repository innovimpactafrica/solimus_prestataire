import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class DevisSectionItemData {
  final String description;
  final int quantity;
  final int unitPrice;
  final int subtotal;

  const DevisSectionItemData({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });
}

class DevisItemsSectionCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final Color iconBg;
  final List<DevisSectionItemData> items;
  final String subtotalLabel;
  final double subtotalAmount;
  final String Function(double) formatAmount;

  const DevisItemsSectionCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.iconBg,
    required this.items,
    required this.subtotalLabel,
    required this.subtotalAmount,
    required this.formatAmount,
  });

  Widget _lineItem(DevisSectionItemData item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.description,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 20 / 14,
                  letterSpacing: -0.15,
                  color: AppColors.textCharcoal,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${item.quantity} x ${formatAmount(item.unitPrice.toDouble())}',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  height: 1.0,
                  color: AppColors.greySlate,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          formatAmount(item.subtotal.toDouble()),
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            height: 20 / 14,
            letterSpacing: -0.15,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 365,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: SvgPicture.asset(iconPath, width: 16, height: 16),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  height: 30 / 20,
                  letterSpacing: -0.45,
                  color: AppColors.textCharcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.asMap().entries.map(
                (e) => Padding(
                  padding: EdgeInsets.only(
                    bottom: e.key < items.length - 1 ? 12 : 0,
                  ),
                  child: _lineItem(e.value),
                ),
              ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.grey100, thickness: 1, height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subtotalLabel,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.primaryDark,
                ),
              ),
              Text(
                formatAmount(subtotalAmount),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
