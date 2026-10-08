import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class WithdrawAmountField extends StatelessWidget {
  final TextEditingController controller;
  final int selectedQuickIndex;
  final ValueChanged<int> onSelectQuick;
  final ValueChanged<String> onChanged;

  static const List<String> quickAmounts = [
    '25 000 FCFA',
    '50 000 FCFA',
    '100 000 FCFA',
  ];

  const WithdrawAmountField({
    super.key,
    required this.controller,
    required this.selectedQuickIndex,
    required this.onSelectQuick,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 365,
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
          Text(
            'Montant à retirer',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 20 / 14,
              letterSpacing: -0.15,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 332,
            height: 53,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.grey200, width: 0.5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      height: 1.0,
                      letterSpacing: -0.45,
                      color: AppColors.blackDark,
                    ),
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: AppColors.overlayDark,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: onChanged,
                  ),
                ),
                Text(
                  'FCFA',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 20 / 14,
                    letterSpacing: -0.15,
                    color: AppColors.greySlate,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(quickAmounts.length, (i) {
              final bool sel = selectedQuickIndex == i;
              return GestureDetector(
                onTap: () => onSelectQuick(i),
                child: Container(
                  width: 99,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(10),
                    border: sel
                        ? Border.all(color: AppColors.warning, width: 1.51)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      quickAmounts[i],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        height: 16 / 12,
                        letterSpacing: 0,
                        color: sel ? AppColors.warning : AppColors.primaryDark,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
