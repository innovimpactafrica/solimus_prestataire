import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/core/widgets/app_bottom_nav_bar.dart';
import 'package:solimus_prestataire/features/demandes/data/services/demandes_service.dart';
import 'package:solimus_prestataire/features/wallet/data/models/wallet_models.dart';
import '../widgets/transaction_row.dart';
import '../widgets/wallet_balance_card.dart';
import '../widgets/wallet_stat_mini_card.dart';
import 'demande_versement.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  WalletData? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await DemandesService().getWallet();
      if (mounted) {
        setState(() {
          _data = data;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
          _loading = false;
        });
      }
    }
  }

  String _formatAmount(double amount) {
    final str = amount.toInt().toString();
    final buf = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(' ');
      buf.write(str[i]);
    }
    return '${buf.toString()} FCFA';
  }

  @override
  Widget build(BuildContext context) {
    final solde = _data?.soldeDisponible ?? 0.0;
    final enAttente = _data?.enAttente ?? 0.0;
    final ceMois = _data?.ceMois ?? 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNavBar(currentTab: AppTab.wallet),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 135,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 135,
                    color: AppColors.primary,
                  ),
                  Positioned(
                    top: 72,
                    left: 24,
                    child: Text(
                      'Wallet',
                      style: GoogleFonts.jost(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        height: 25 / 24,
                        letterSpacing: 24 * 0.005,
                        color: AppColors.surfaceMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
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
                      child: const Text(
                        'Réessayer',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              WalletBalanceCard(
                balance: solde,
                onWithdrawTap: () => Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (c, a, s) =>
                        DemandeVersementPage(soldeDisponible: solde),
                    transitionsBuilder: (c, anim, s, child) => FadeTransition(
                      opacity: CurvedAnimation(
                        parent: anim,
                        curve: Curves.easeOut,
                      ),
                      child: child,
                    ),
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 360,
                child: Row(
                  children: [
                    WalletStatMiniCard(
                      iconPath: 'assets/icons/pendig1.svg',
                      iconBgColor: AppColors.warningBg,
                      label: 'En attente',
                      formattedAmount: _formatAmount(enAttente),
                    ),
                    const SizedBox(width: 20),
                    WalletStatMiniCard(
                      iconPath: 'assets/icons/month.svg',
                      iconBgColor: AppColors.successBg,
                      label: 'Ce mois',
                      formattedAmount: _formatAmount(ceMois),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 360,
                child: Text(
                  'Transactions',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    height: 28 / 18,
                    letterSpacing: -0.44,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (_data!.transactions.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Aucune transaction',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: AppColors.greyCool,
                    ),
                  ),
                )
              else
                ..._data!.transactions.map(
                  (tx) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TransactionRow(tx: tx),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}
