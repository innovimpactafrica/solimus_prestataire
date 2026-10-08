import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/features/profil/data/models/profile_models.dart';
import 'package:solimus_prestataire/features/demandes/data/services/demandes_service.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/core/widgets/subpage_header.dart';
import '../widgets/subscription_active_card.dart';
import '../widgets/subscription_payment_row.dart';
import '../widgets/premium_payment_bottom_sheet.dart';

class MonAbonnementPage extends StatefulWidget {
  const MonAbonnementPage({super.key});

  @override
  State<MonAbonnementPage> createState() => _MonAbonnementPageState();
}

class _MonAbonnementPageState extends State<MonAbonnementPage> {
  SubscriptionInfo? _data;
  bool _loading = true;
  String? _error;
  bool _noSubscription = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
      _noSubscription = false;
    });
    try {
      final data = await DemandesService().getSubscription();
      if (mounted) {
        setState(() {
          _data = data;
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString();
      if (msg.contains('404') ||
          msg.contains('abonnement') ||
          msg.contains('subscription')) {
        setState(() {
          _noSubscription = true;
          _loading = false;
        });
      } else {
        setState(() {
          _error = msg.replaceFirst('Exception: ', '');
          _loading = false;
        });
      }
    }
  }

  void _showPremiumSheet() {
    PremiumPaymentBottomSheet.show(
      context: context,
      onPaymentSuccess: _load,
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = _data;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SubpageHeader(
              title: 'Mon abonnement',
              subtitle: 'Consultez et gérez mon abonnement',
            ),
            const SizedBox(height: 20),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            else if (_error != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: Colors.red),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _load,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('Réessayer',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              )
            else if (_noSubscription) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.primary10,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icons/premium.svg',
                                width: 28,
                                height: 28,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aucun abonnement actif',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Passez à Premium pour accéder à toutes les fonctionnalités.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppColors.greySlate,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _showPremiumSheet,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            "Passer à l'abonnement Premium",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              SubscriptionActiveCard(
                subscription: d!,
                onPaymentTap: _showPremiumSheet,
              ),
              const SizedBox(height: 16),
              if (!d.active) ...[
                GestureDetector(
                  onTap: _showPremiumSheet,
                  child: Container(
                    width: 365,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "Passer à l'abonnement Premium",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (d.paymentHistory.isNotEmpty)
                Container(
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
                              color: AppColors.successLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icons/cash.svg',
                                width: 16,
                                height: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Historique des paiements',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              letterSpacing: -0.45,
                              color: AppColors.textCharcoal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...d.paymentHistory.asMap().entries.map(
                            (e) => SubscriptionPaymentRow(
                              payment: e.value,
                              showDivider:
                                  e.key < d.paymentHistory.length - 1,
                            ),
                          ),
                    ],
                  ),
                ),
              const SizedBox(height: 32),
            ],
          ],
        ),
      ),
    );
  }
}
