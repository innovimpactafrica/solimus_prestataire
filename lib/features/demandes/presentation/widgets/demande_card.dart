import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/features/demandes/data/models/demandes_models.dart';

class DemandeCard extends StatelessWidget {
  final DemandeRequestSummary request;
  final VoidCallback onTap;

  const DemandeCard({
    super.key,
    required this.request,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 370,
            height: 92,
            padding: const EdgeInsets.only(
              top: 16,
              right: 12,
              bottom: 16,
              left: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary10,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/clef.svg',
                            width: 27.5,
                            height: 27.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              request.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.beVietnamPro(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                height: 1.0,
                                letterSpacing: 0,
                                color: AppColors.darkNeutral,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              request.residenceName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.beVietnamPro(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                height: 1.0,
                                letterSpacing: 0,
                                color: AppColors.greyCool,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      request.timeAgo,
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        height: 1.0,
                        color: AppColors.greyCool,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _statusBgColor(request.status),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        request.statusLabel,
                        style: GoogleFonts.beVietnamPro(
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          color: _statusTextColor(request.status),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _statusBgColor(String status) {
    switch (status) {
      case 'PENDING_QUOTE':
        return AppColors.amberBg;
      case 'QUOTE_SENT':
        return AppColors.blueBg;
      case 'REJECTED':
        return AppColors.redBg;
      default:
        return AppColors.grey100;
    }
  }

  Color _statusTextColor(String status) {
    switch (status) {
      case 'PENDING_QUOTE':
        return AppColors.amberDark;
      case 'QUOTE_SENT':
        return AppColors.blueText;
      case 'REJECTED':
        return AppColors.error;
      default:
        return AppColors.greySlate;
    }
  }
}
