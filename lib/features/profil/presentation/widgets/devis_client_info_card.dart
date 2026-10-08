import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class DevisClientInfoCard extends StatelessWidget {
  final String nom;
  final String telephone;
  final String email;
  final String adresse;

  const DevisClientInfoCard({
    super.key,
    required this.nom,
    required this.telephone,
    required this.email,
    required this.adresse,
  });

  Widget _infoRow(String iconPath, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: SvgPicture.asset(iconPath, width: 16, height: 16),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                height: 1.0,
                color: AppColors.slate400,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 20 / 14,
                letterSpacing: -0.15,
                color: AppColors.textCharcoal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 365,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary10,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/infoclient.svg',
                    width: 16,
                    height: 16,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Informations client',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  height: 30 / 20,
                  letterSpacing: -0.45,
                  color: AppColors.textCharcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (nom.isNotEmpty) ...[
            _infoRow('assets/icons/nom.svg', 'Nom', nom),
            const SizedBox(height: 14),
          ],
          if (telephone.isNotEmpty) ...[
            _infoRow('assets/icons/telephone.svg', 'Téléphone', telephone),
            const SizedBox(height: 14),
          ],
          if (email.isNotEmpty) ...[
            _infoRow('assets/icons/Email.svg', 'Email', email),
            const SizedBox(height: 14),
          ],
          if (adresse.isNotEmpty)
            _infoRow('assets/icons/adress.svg', 'Adresse', adresse),
        ],
      ),
    );
  }
}
