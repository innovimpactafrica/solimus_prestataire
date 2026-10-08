import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  final bool isAnnuel;
  final VoidCallback onSelect;

  const SubscriptionPlanCard({
    super.key,
    required this.plan,
    required this.isAnnuel,
    required this.onSelect,
  });

  Widget _featureRow(String label, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/donee.svg',
            width: 16,
            height: 16,
            colorFilter: active
                ? null
                : const ColorFilter.mode(AppColors.greyBorder, BlendMode.srcIn),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: active ? AppColors.black1C : AppColors.greyBorder,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool recommande = plan['recommande'] as bool;
    final String prix = isAnnuel
        ? plan['prix_annuel'] as String
        : plan['prix_mensuel'] as String;
    final List<String> features = List<String>.from(plan['features'] as List);
    final List<String> featuresOff =
        List<String>.from(plan['features_off'] as List);

    return Container(
      margin: EdgeInsets.only(
        bottom: recommande ? 20 : 16,
        top: recommande ? 8 : 0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: recommande ? AppColors.warning : AppColors.grey500Half,
          width: recommande ? 2 : 1,
        ),
        boxShadow: recommande
            ? [
                const BoxShadow(
                  color: AppColors.rust20,
                  blurRadius: 30,
                  offset: Offset(0, 8),
                )
              ]
            : [],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan['nom'] as String,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: AppColors.black1C,
                      ),
                    ),
                    Text(
                      plan['desc'] as String,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: AppColors.textBrownMuted,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$prix FCFA',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: AppColors.warning,
                      ),
                    ),
                    Text(
                      isAnnuel ? '/ an' : '/ mois',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: AppColors.textBrownMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...features.map((f) => _featureRow(f, true)),
            ...featuresOff.map((f) => _featureRow(f, false)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onSelect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Choisir ce pack',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
