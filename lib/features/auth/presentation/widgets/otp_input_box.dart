import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class OtpInputBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;
  final double width;
  final double height;

  const OtpInputBox({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onChanged,
    this.width = 84.5,
    this.height = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: onChanged,
        style: GoogleFonts.beVietnamPro(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: AppColors.textCharcoal,
        ),
        decoration: InputDecoration(
          hintText: '*',
          hintStyle: GoogleFonts.beVietnamPro(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            height: 1.0,
            color: AppColors.primary,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          filled: true,
          fillColor: AppColors.primary10,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.warmGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.warmGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.greenMedium),
          ),
        ),
      ),
    );
  }
}
