import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'versement_success.dart';
import '../../services/demandes_service.dart';

class DemandeVersementPage extends StatefulWidget {
  final double soldeDisponible;
  const DemandeVersementPage({super.key, required this.soldeDisponible});

  @override
  State<DemandeVersementPage> createState() => _DemandeVersementPageState();
}

class _DemandeVersementPageState extends State<DemandeVersementPage> {
  int _selectedMethod = -1;
  int _selectedAmount = -1;
  String _amountValue = '';
  bool _submitting = false;
  final _phoneController = TextEditingController();

  static const _methodValues = ['WAVE', 'ORANGE_MONEY'];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final montant = int.tryParse(_amountValue.replaceAll(' ', '')) ?? 0;
    if (_selectedMethod == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sélectionnez une méthode de paiement')),
      );
      return;
    }
    if (montant <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrez un montant valide')),
      );
      return;
    }
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrez votre numéro de téléphone')),
      );
      return;
    }
    setState(() => _submitting = true);
    try {
      await DemandesService().withdraw(
        montant: montant,
        methode: _methodValues[_selectedMethod],
        numeroDeTelephone: _phoneController.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (c, a, s) => const VersementSuccessPage(),
        transitionsBuilder: (c, anim, s, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
      setState(() => _submitting = false);
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

  static const List<String> _quickAmounts = [
    '25 000 FCFA',
    '50 000 FCFA',
    '100 000 FCFA',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F4),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            SizedBox(
              height: 135,
              child: Stack(
                children: [
                  Container(width: double.infinity, height: 135, color: const Color(0xFF6F675E)),
                  Container(width: double.infinity, height: 135, color: const Color(0x66000000)),
                  Positioned(
                    top: 48,
                    left: 24,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0x33FFFFFF),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icons/fleche gauche.svg',
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Demande de versement',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                height: 32 / 20,
                                letterSpacing: 0.07,
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Retirez vos fonds disponibles',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 20 / 14,
                                letterSpacing: -0.15,
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Container 1 — Solde disponible
            Container(
              width: 365,
              height: 89,
              padding: const EdgeInsets.only(top: 16.5, right: 16.5, bottom: 0.5, left: 16.5),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF3F4F6), width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/solde1.svg', width: 16, height: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Solde disponible',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          height: 16 / 12,
                          letterSpacing: 0,
                          color: const Color(0xFF6A7282),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatAmount(widget.soldeDisponible),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      height: 32 / 24,
                      letterSpacing: 0.07,
                      color: const Color(0xFF2D2520),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Container 2 — Méthode de paiement
            Container(
              width: 365,
              padding: const EdgeInsets.only(top: 16.5, right: 16.5, bottom: 0.5, left: 16.5),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF3F4F6), width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Méthode de paiement',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 20 / 14,
                      letterSpacing: -0.15,
                      color: const Color(0xFF2D2520),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _paymentMethodButton(index: 0, imagePath: 'assets/images/wave.png', title: 'Wave', subtitle: '24-48 heures'),
                  const SizedBox(height: 8),
                  _paymentMethodButton(index: 1, imagePath: 'assets/images/om.png', title: 'Orange Money', subtitle: '24-48 heures'),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Container 3 — Numéro de téléphone
            Container(
              width: 365,
              height: 110,
              padding: const EdgeInsets.only(top: 16.5, right: 16.5, bottom: 0.5, left: 16.5),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF3F4F6), width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Numéro de téléphone',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 20 / 14,
                      letterSpacing: -0.15,
                      color: const Color(0xFF2D2520),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 332,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        SvgPicture.asset('assets/icons/phone.svg', width: 16, height: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 1.0,
                              letterSpacing: -0.15,
                              color: const Color(0xFF0A0A0A),
                            ),
                            decoration: InputDecoration(
                              hintText: '+221 77 123 45 67',
                              hintStyle: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: const Color(0x800A0A0A),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Container 4 — Montant à retirer
            Container(
              width: 365,
              padding: const EdgeInsets.only(top: 16.5, right: 16.5, bottom: 0.5, left: 16.5),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF3F4F6), width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Montant à retirer',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 20 / 14,
                      letterSpacing: -0.15,
                      color: const Color(0xFF2D2520),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Number input
                  Container(
                    width: 332,
                    height: 53,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _amountValue.isEmpty ? '0' : _amountValue,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            height: 1.0,
                            letterSpacing: -0.45,
                            color: const Color(0x800A0A0A),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'FCFA',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            height: 20 / 14,
                            letterSpacing: -0.15,
                            color: const Color(0xFF6A7282),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Quick amount buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_quickAmounts.length, (i) {
                      final bool sel = _selectedAmount == i;
                      return GestureDetector(
                        onTap: () => setState(() {
                          _selectedAmount = i;
                          _amountValue = _quickAmounts[i].replaceAll(' FCFA', '');
                        }),
                        child: Container(
                          width: 99,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(10),
                            border: sel
                                ? Border.all(color: const Color(0xFFF9C20A), width: 1.51)
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              _quickAmounts[i],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                height: 16 / 12,
                                letterSpacing: 0,
                                color: sel ? const Color(0xFFF9C20A) : const Color(0xFF2D2520),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Container 5 — Délai de traitement
            Container(
              width: 365,
              padding: const EdgeInsets.only(top: 16.5, right: 16.5, bottom: 0.5, left: 16.5),
              decoration: BoxDecoration(
                color: const Color(0x1AF9C20A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF9C20A), width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/delai.svg', width: 16, height: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Délai de traitement',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          height: 16 / 12,
                          letterSpacing: 0,
                          color: const Color(0xFFF9C20A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Votre demande sera traitée sous 24 à 48 heures. Vous recevrez une notification une fois le versement effectué.',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      height: 16 / 12,
                      letterSpacing: 0,
                      color: const Color(0xFF6F675E),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Bouton Demander le versement
            GestureDetector(
              onTap: _submitting ? null : _submit,
              child: Container(
                width: 355,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9C20A),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: _submitting
                      ? const SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          'Demander le versement',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            height: 24 / 18,
                            letterSpacing: -0.31,
                            color: const Color(0xFFFFFFFF),
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Bouton Annuler
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 355,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFF6F675E), width: 1),
                ),
                child: Center(
                  child: Text(
                    'Annuler',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      height: 24 / 18,
                      letterSpacing: -0.31,
                      color: const Color(0xFF6F675E),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _paymentMethodButton({
    required int index,
    required String imagePath,
    required String title,
    required String subtitle,
  }) {
    final bool selected = _selectedMethod == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = index),
      child: Container(
        width: 332,
        height: 75,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? const Color(0xFFF9C20A) : const Color(0xFFE5E7EB),
            width: 1.51,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(imagePath, width: 40, height: 40, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 20 / 14,
                      letterSpacing: -0.15,
                      color: selected ? const Color(0xFFF9C20A) : const Color(0xFF2D2520),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      height: 16 / 12,
                      letterSpacing: 0,
                      color: const Color(0xFF6A7282),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? const Color(0xFFF9C20A) : Colors.transparent,
                border: Border.all(
                  color: selected ? const Color(0xFFF9C20A) : const Color(0xFFD1D5DC),
                  width: 1.51,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFFFFF),
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
}
