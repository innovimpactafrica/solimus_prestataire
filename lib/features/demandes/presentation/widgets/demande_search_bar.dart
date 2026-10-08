import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class DemandeSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback onFilterTap;

  const DemandeSearchBar({
    super.key,
    required this.controller,
    required this.onFilterTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Container(
        width: 365,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.warmGrey, width: 1),
          color: Colors.white,
        ),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/Search.svg', width: 24, height: 24),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: AppColors.darkNeutral,
                ),
                decoration: InputDecoration(
                  hintText: 'Rechercher',
                  hintStyle: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: AppColors.slate700,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            GestureDetector(
              onTap: onFilterTap,
              child:
                  SvgPicture.asset('assets/icons/Filter.svg', width: 24, height: 24),
            ),
          ],
        ),
      ),
    );
  }
}
