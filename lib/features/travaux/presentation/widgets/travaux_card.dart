import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/features/travaux/data/models/travaux_models.dart';

class TravauxCard extends StatelessWidget {
  final TravauxSummary item;
  final VoidCallback onTap;

  const TravauxCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  String _relativeTime(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inDays >= 1) return 'il y a ${diff.inDays}j';
    if (diff.inHours >= 1) return 'il y a ${diff.inHours}h';
    return 'il y a ${diff.inMinutes}min';
  }

  Color _badgeBg(String status) {
    switch (status) {
      case 'PENDING':
        return AppColors.warning10;
      case 'STARTED':
        return AppColors.purple10;
      case 'FINISHED':
        return AppColors.amber10;
      case 'CANCELLED':
        return AppColors.error10;
      default:
        return AppColors.primary10;
    }
  }

  Color _badgeText(String status) {
    switch (status) {
      case 'PENDING':
        return AppColors.warning;
      case 'STARTED':
        return AppColors.purple;
      case 'FINISHED':
        return AppColors.orangeDark;
      case 'CANCELLED':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
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
                            'assets/icons/cle.svg',
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
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.beVietnamPro(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                height: 1.0,
                                color: AppColors.darkNeutral,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.residenceName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.beVietnamPro(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                height: 1.0,
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _badgeBg(item.status),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.statusLabel,
                        style: GoogleFonts.beVietnamPro(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          height: 1.0,
                          color: _badgeText(item.status),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _relativeTime(item.createdAt),
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        height: 1.0,
                        color: AppColors.greyCool,
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
}
