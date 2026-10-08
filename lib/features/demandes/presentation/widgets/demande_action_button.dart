import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class DemandeActionButton extends StatelessWidget {
  final String label;
  final String icon;
  final bool isLoading;
  final VoidCallback? onTap;
  final Color backgroundColor;

  const DemandeActionButton({
    super.key,
    required this.label,
    required this.icon,
    this.isLoading = false,
    this.onTap,
    this.backgroundColor = AppColors.warning,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 350,
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(icon, width: 20, height: 20),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      height: 24 / 18,
                      letterSpacing: -0.31,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
