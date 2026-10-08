import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class PaymentMethodSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const PaymentMethodSelector({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  Widget _paymentMethodButton({
    required int index,
    required String imagePath,
    required String title,
    required String subtitle,
  }) {
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onSelect(index),
      child: Container(
        width: 332,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: AppColors.warning, width: 1.51)
              : Border.all(color: AppColors.grey200, width: 0.5),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 20 / 14,
                      letterSpacing: -0.15,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  Text(
                    subtitle,
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
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.warning : AppColors.grey400,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.warning,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 365,
      padding: const EdgeInsets.only(
        top: 16.5,
        right: 16.5,
        bottom: 8,
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
          Text(
            'Méthode de paiement',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 20 / 14,
              letterSpacing: -0.15,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 12),
          _paymentMethodButton(
            index: 0,
            imagePath: 'assets/images/wave.png',
            title: 'Wave',
            subtitle: '24-48 heures',
          ),
          const SizedBox(height: 8),
          _paymentMethodButton(
            index: 1,
            imagePath: 'assets/images/om.png',
            title: 'Orange Money',
            subtitle: '24-48 heures',
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
