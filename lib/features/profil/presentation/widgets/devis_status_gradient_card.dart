import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class DevisStatusGradientCard extends StatelessWidget {
  final String statLabel;
  final String formattedAmount;
  final String? dateEnvoi;
  final String? dateValidation;

  const DevisStatusGradientCard({
    super.key,
    required this.statLabel,
    required this.formattedAmount,
    this.dateEnvoi,
    this.dateValidation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 365,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.splashStep1,
            AppColors.splashStep2,
            AppColors.splashStep3,
            AppColors.splashStep4,
            AppColors.splashStep5,
            AppColors.splashStep6,
            AppColors.splashStep7,
            AppColors.splashStep8,
            AppColors.splashStep9,
          ],
          stops: [
            0.0,
            0.1111,
            0.2222,
            0.3333,
            0.4444,
            0.5556,
            0.6667,
            0.7778,
            0.8889,
            1.0,
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statut',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: AppColors.slate400,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/valid.svg',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          statLabel,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Montant total',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: AppColors.slate400,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formattedAmount,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      letterSpacing: 0.07,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.white20, thickness: 0.5, height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              if (dateEnvoi != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Envoyé le',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: AppColors.slate400,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        dateEnvoi!,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              if (dateValidation != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Validé le',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: AppColors.slate400,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      dateValidation!,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
