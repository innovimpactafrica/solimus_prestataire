import 'package:flutter/material.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/core/widgets/subpage_header.dart';
import '../widgets/subscription_frequency_toggle.dart';
import '../widgets/subscription_plan_card.dart';
import '../widgets/subscription_payment_modal.dart';

class AbonnementPage extends StatefulWidget {
  const AbonnementPage({super.key});

  @override
  State<AbonnementPage> createState() => _AbonnementPageState();
}

class _AbonnementPageState extends State<AbonnementPage> {
  bool _isAnnuel = false;

  final _plans = [
    {
      'nom': 'Premium',
      'desc': 'Boostez votre productivité',
      'prix_mensuel': '50 000',
      'prix_annuel': '480 000',
      'features': [
        'Devis illimités',
        '2500 réponses / mois',
        'Export PDF & Excel',
        'Support prioritaire'
      ],
      'features_off': <String>[],
      'recommande': true,
    },
  ];

  void _showPaiementModal(
    BuildContext context, {
    required String nomPack,
    required String prix,
    required bool isAnnuel,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SubscriptionPaymentModal(
        nomPack: nomPack,
        prix: prix,
        isAnnuel: isAnnuel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Column(
        children: [
          const SubpageHeader(
            title: 'Abonnement',
            subtitle: "Choisissez votre pack d'abonnement",
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  SubscriptionFrequencyToggle(
                    isAnnuel: _isAnnuel,
                    onToggle: (annuel) => setState(() => _isAnnuel = annuel),
                  ),
                  const SizedBox(height: 20),
                  ..._plans.map(
                    (plan) => SubscriptionPlanCard(
                      plan: plan,
                      isAnnuel: _isAnnuel,
                      onSelect: () => _showPaiementModal(
                        context,
                        nomPack: plan['nom'] as String,
                        prix: _isAnnuel
                            ? plan['prix_annuel'] as String
                            : plan['prix_mensuel'] as String,
                        isAnnuel: _isAnnuel,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
