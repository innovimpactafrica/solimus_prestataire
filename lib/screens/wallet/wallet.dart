import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home.dart';
import '../demandes/demandes.dart';
import '../profil/profil.dart';
import 'demande_versement.dart';
import '../../models/wallet_models.dart';
import '../../services/demandes_service.dart';

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
    setState(() { _loading = true; _error = null; });
    try {
      final data = await DemandesService().getWallet();
      if (mounted) setState(() { _data = data; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString().replaceFirst('Exception: ', ''); _loading = false; });
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

  String _formatDate(DateTime d) {
    const months = ['', 'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month]} ${d.year}';
  }

  Widget _navItem(String iconPath, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(iconPath, width: 24, height: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 10,
              height: 1.2,
              color: const Color(0xFFFFFFFF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _transactionRow(WalletTransaction tx) {
    final bool isPending = tx.isPending;
    final bool isEntree = tx.isEntree;

    final Color badgeColor;
    final String iconPath;
    final Color amountColor;

    if (isPending) {
      badgeColor = const Color(0xFFFFFBEB);
      iconPath = 'assets/icons/pendig1.svg';
      amountColor = const Color(0xFF00A63E);
    } else if (isEntree) {
      badgeColor = const Color(0xFFF0FDF4);
      iconPath = 'assets/icons/vert.svg';
      amountColor = const Color(0xFF00A63E);
    } else {
      badgeColor = const Color(0xFFEFF6FF);
      iconPath = 'assets/icons/bleu.svg';
      amountColor = const Color(0xFF155DFC);
    }

    final String amountStr = isEntree
        ? '+${_formatAmount(tx.montant)}'
        : '-${_formatAmount(tx.montant)}';

    return Container(
      width: 360,
      padding: const EdgeInsets.only(
        top: 16.5,
        right: 16.5,
        bottom: 0.5,
        left: 16.5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFFFFFFF), width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(iconPath, width: 16, height: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.label,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 20 / 14,
                    letterSpacing: -0.15,
                    color: const Color(0xFF2D2520),
                  ),
                ),
                Text(
                  _formatDate(tx.date),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 16 / 12,
                    letterSpacing: 0,
                    color: const Color(0xFF6A7282),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amountStr,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  height: 20 / 14,
                  letterSpacing: -0.15,
                  color: amountColor,
                ),
              ),
              if (isPending) ...[
                const SizedBox(height: 4),
                Container(
                  width: 98,
                  height: 23,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0x1AF9C20A),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      'En attente',
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        height: 1.0,
                        color: const Color(0xFFF9C20A),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final solde = _data?.soldeDisponible ?? 0;
    final enAttente = _data?.soldeEnAttente ?? 0;
    final ceMois = _data?.totalCeMois ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F4),
      bottomNavigationBar: Builder(
        builder: (ctx) => Container(
          height: 75,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0xFF6F675E),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                offset: Offset(0, -1),
                blurRadius: 32,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _navItem(
                'assets/icons/accueil.svg',
                'Accueil',
                onTap: () => Navigator.of(ctx).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (c, a, s) => const HomePage(),
                    transitionsBuilder: (c, anim, s, child) => FadeTransition(
                      opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
                      child: child,
                    ),
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ),
              const SizedBox(width: 56),
              _navItem(
                'assets/icons/demande nav.svg',
                'Demandes',
                onTap: () => Navigator.of(ctx).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (c, a, s) => const DemandesPage(),
                    transitionsBuilder: (c, anim, s, child) => FadeTransition(
                      opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
                      child: child,
                    ),
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ),
              const SizedBox(width: 56),
              _navItem('assets/icons/wallet.svg', 'Wallet'),
              const SizedBox(width: 56),
              _navItem(
                'assets/icons/profil.svg',
                'Mon profil',
                onTap: () => Navigator.of(ctx).pushReplacement(PageRouteBuilder(
                  pageBuilder: (c, a, s) => const ProfilPage(),
                  transitionsBuilder: (c, anim, s, child) => FadeTransition(
                    opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
                  transitionDuration: const Duration(milliseconds: 300),
                )),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            SizedBox(
              height: 135,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 135,
                    color: const Color(0xFF6F675E),
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
                        color: const Color(0xFFFDFDFD),
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
                child: Center(child: CircularProgressIndicator(color: Color(0xFF6F675E))),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                child: Column(
                  children: [
                    Text(_error!, textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.red)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _load,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6F675E)),
                      child: const Text('Réessayer', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              )
            else ...[
              // Carte solde
              Container(
                width: 360,
                height: 176,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6F675E), Color(0xCC6F675E)],
                    stops: [0.0, 0.6354],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/icons/solde.svg', width: 16, height: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Solde disponible',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            height: 16 / 12,
                            letterSpacing: 0,
                            color: const Color(0xFFFFFFFF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatAmount(solde),
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                        height: 36 / 30,
                        letterSpacing: 0.4,
                        color: const Color(0xFFFFFFFF),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (c, a, s) => DemandeVersementPage(soldeDisponible: solde),
                          transitionsBuilder: (c, anim, s, child) => FadeTransition(
                            opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
                            child: child,
                          ),
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      ),
                      child: Container(
                        width: 335,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/demand.svg', width: 16, height: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Demander un versement',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                height: 20 / 14,
                                letterSpacing: -0.15,
                                color: const Color(0xFF2D2520),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Deux cards stat
              SizedBox(
                width: 360,
                child: Row(
                  children: [
                    // Card En attente
                    Container(
                      width: 170,
                      height: 99,
                      padding: const EdgeInsets.only(top: 16.5, right: 16.5, bottom: 0.5, left: 16.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFFFFFF), width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFBEB),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SvgPicture.asset('assets/icons/pendig1.svg', width: 16, height: 16),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'En attente',
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
                            _formatAmount(enAttente),
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              height: 24 / 16,
                              letterSpacing: -0.3,
                              color: const Color(0xFF2D2520),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Card Ce mois
                    Container(
                      width: 170,
                      height: 99,
                      padding: const EdgeInsets.only(top: 16.5, right: 16.5, bottom: 0.5, left: 16.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFFFFFF), width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0FDF4),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SvgPicture.asset('assets/icons/month.svg', width: 16, height: 16),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Ce mois',
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
                            _formatAmount(ceMois),
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              height: 24 / 16,
                              letterSpacing: -0.3,
                              color: const Color(0xFF2D2520),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Titre Transactions
              SizedBox(
                width: 360,
                child: Text(
                  'Transactions',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    height: 28 / 18,
                    letterSpacing: -0.44,
                    color: const Color(0xFF2D2520),
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
                      color: const Color(0xFF91919F),
                    ),
                  ),
                )
              else
                ..._data!.transactions.map((tx) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _transactionRow(tx),
                )),

              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}
