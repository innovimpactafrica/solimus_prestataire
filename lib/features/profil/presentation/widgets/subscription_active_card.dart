import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/features/profil/data/models/profile_models.dart';

class SubscriptionActiveCard extends StatelessWidget {
  final SubscriptionInfo subscription;
  final VoidCallback? onPaymentTap;

  const SubscriptionActiveCard({
    super.key,
    required this.subscription,
    this.onPaymentTap,
  });

  String _formatDate(DateTime d) {
    const months = [
      '',
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre'
    ];
    return '${d.day} ${months[d.month]} ${d.year}';
  }

  String _formatDateShort(DateTime d) {
    const months = [
      '',
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Jun',
      'Jul',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc'
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month]} ${d.year}';
  }

  String _formatPaymentMethod(String raw) {
    switch (raw.toUpperCase()) {
      case 'WAVE':
        return 'Wave';
      case 'ORANGE_MONEY':
        return 'Orange Money';
      default:
        return raw;
    }
  }

  Widget _infoBox(String iconPath, String label, String value) {
    return Container(
      width: 155,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(iconPath, width: 14, height: 14),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: AppColors.greyBorder,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = subscription;
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
            1.0
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/actif.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            d.planName,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              height: 1.0,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: d.active
                                ? AppColors.greenEmerald
                                : AppColors.greySlate,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/renew.svg',
                                width: 12,
                                height: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                d.active ? 'Actif' : 'Inactif',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Abonnement actif jusqu\'au ${_formatDate(d.endDate)}',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: AppColors.greyBorder,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _infoBox(
                'assets/icons/calen.svg',
                'Activation',
                _formatDateShort(d.startDate),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onPaymentTap,
                child: _infoBox(
                  'assets/icons/premium.svg',
                  'Paiement',
                  _formatPaymentMethod(d.paymentMethod),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(
            color: AppColors.white20,
            thickness: 0.5,
            height: 1,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/renew.svg',
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 8),
              Text(
                d.status,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: AppColors.greyBorder,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
