import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class DevisMethodBottomSheet extends StatefulWidget {
  final VoidCallback onPlatformDevis;
  final VoidCallback onUploadDevis;

  const DevisMethodBottomSheet({
    super.key,
    required this.onPlatformDevis,
    required this.onUploadDevis,
  });

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onPlatformDevis,
    required VoidCallback onUploadDevis,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DevisMethodBottomSheet(
        onPlatformDevis: onPlatformDevis,
        onUploadDevis: onUploadDevis,
      ),
    );
  }

  @override
  State<DevisMethodBottomSheet> createState() => _DevisMethodBottomSheetState();
}

class _DevisMethodBottomSheetState extends State<DevisMethodBottomSheet> {
  int _selectedCard = 0;

  Widget _devisCard({
    required int cardIndex,
    required String iconAsset,
    required String title,
    required String subtitle,
    required VoidCallback onSelect,
  }) {
    final selected = _selectedCard == cardIndex;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedCard = cardIndex);
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            Navigator.of(context).pop();
            onSelect();
          }
        });
      },
      child: Container(
        width: 382,
        height: 125,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: selected ? AppColors.warning10 : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.warning : AppColors.background,
            width: 2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: selected ? AppColors.warning : AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: SvgPicture.asset(iconAsset, width: 28, height: 28),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      height: 24 / 14,
                      letterSpacing: -0.31,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      height: 22.75 / 12,
                      letterSpacing: -0.15,
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 430,
      height: 454,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.charcoal50,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Créer un devis',
                        style: GoogleFonts.workSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          height: 32 / 24,
                          color: AppColors.textCharcoal,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: SvgPicture.asset(
                        'assets/icons/close-rounded.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Choisissez votre méthode de création',
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 24 / 16,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
            child: Column(
              children: [
                _devisCard(
                  cardIndex: 1,
                  iconAsset: 'assets/icons/file.svg',
                  title: 'Créer un devis sur la plateforme',
                  subtitle:
                      'Utilisez notre formulaire intégré pour créer votre devis',
                  onSelect: widget.onPlatformDevis,
                ),
                const SizedBox(height: 20),
                _devisCard(
                  cardIndex: 2,
                  iconAsset: 'assets/icons/download.svg',
                  title: 'Téléverser un devis',
                  subtitle:
                      'Importez un devis existant (PDF, image ou Word)',
                  onSelect: widget.onUploadDevis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
