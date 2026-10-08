import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class DevisMaterialRow extends StatelessWidget {
  final TextEditingController descriptionController;
  final TextEditingController quantityController;
  final TextEditingController unitPriceController;
  final int total;
  final VoidCallback onDelete;
  final VoidCallback onChanged;
  final bool canDelete;

  const DevisMaterialRow({
    super.key,
    required this.descriptionController,
    required this.quantityController,
    required this.unitPriceController,
    required this.total,
    required this.onDelete,
    required this.onChanged,
    required this.canDelete,
  });

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.grey400,
        ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.grey200, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.grey200, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 37,
                child: TextField(
                  controller: descriptionController,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.blackDark,
                  ),
                  decoration: _fieldDecoration('Description du matériel'),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: canDelete ? onDelete : null,
              child: Opacity(
                opacity: canDelete ? 1.0 : 0.4,
                child: SvgPicture.asset(
                  'assets/icons/Delete.svg',
                  width: 16,
                  height: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                'Quantité',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  height: 16 / 12,
                  color: AppColors.greySlate,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Prix (FCFA)',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  height: 16 / 12,
                  color: AppColors.greySlate,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Total',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  height: 16 / 12,
                  color: AppColors.greySlate,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 37,
                child: TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.blackDark,
                  ),
                  onChanged: (_) => onChanged(),
                  decoration: _fieldDecoration('1'),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 37,
                child: TextField(
                  controller: unitPriceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.blackDark,
                  ),
                  onChanged: (_) => onChanged(),
                  decoration: _fieldDecoration('0'),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 37,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.grey200, width: 0.5),
                ),
                child: Text(
                  '$total FCFA',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    height: 20 / 14,
                    letterSpacing: -0.15,
                    color: AppColors.blackDark,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
