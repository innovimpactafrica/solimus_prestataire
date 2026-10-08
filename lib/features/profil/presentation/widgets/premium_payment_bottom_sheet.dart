import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/features/demandes/data/services/demandes_service.dart';
import '../pages/touchpay_webview.dart';

class PremiumPaymentBottomSheet extends StatefulWidget {
  final VoidCallback onPaymentSuccess;

  const PremiumPaymentBottomSheet({
    super.key,
    required this.onPaymentSuccess,
  });

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onPaymentSuccess,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PremiumPaymentBottomSheet(
        onPaymentSuccess: onPaymentSuccess,
      ),
    );
  }

  @override
  State<PremiumPaymentBottomSheet> createState() =>
      _PremiumPaymentBottomSheetState();
}

class _PremiumPaymentBottomSheetState
    extends State<PremiumPaymentBottomSheet> {
  int _selectedMethod = 0; // 0=WAVE, 1=ORANGE_MONEY
  bool _renouvAuto = true;
  bool _submitting = false;

  Widget _methodTile(int index, String label, String imagePath) {
    final bool isSelected = _selectedMethod == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey200,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.borderD1,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePayment() async {
    setState(() => _submitting = true);
    final scaffoldMsg = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    try {
      const methods = ['WAVE', 'ORANGE_MONEY'];
      final paymentInit = await DemandesService().subscribeToPremium(
        moyenPaiement: methods[_selectedMethod],
        renouvellementAuto: _renouvAuto,
      );
      if (!mounted) return;
      nav.pop();

      final result = await nav.push<bool>(
        MaterialPageRoute(
          builder: (_) => TouchPayWebViewPage(url: paymentInit.paymentUrl),
        ),
      );

      if (result == true) {
        scaffoldMsg.showSnackBar(
          const SnackBar(
            content: Text('Paiement effectué avec succès !'),
            backgroundColor: AppColors.greenEmerald,
          ),
        );
        widget.onPaymentSuccess();
      }
    } catch (e) {
      if (mounted) {
        scaffoldMsg.showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
        left: 24,
        right: 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.warmGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Passer à Premium',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choisissez votre méthode de paiement',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColors.greySlate,
            ),
          ),
          const SizedBox(height: 20),
          _methodTile(0, 'Wave', 'assets/images/wave.png'),
          const SizedBox(height: 10),
          _methodTile(1, 'Orange Money', 'assets/images/om.png'),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => setState(() => _renouvAuto = !_renouvAuto),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _renouvAuto ? AppColors.primary : Colors.transparent,
                    border: Border.all(color: AppColors.primary, width: 1.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: _renouvAuto
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 10),
                Text(
                  'Renouvellement automatique',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _submitting ? null : _handlePayment,
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: _submitting ? AppColors.grey400 : AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: _submitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        'Payer 10 000 FCFA / mois',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
