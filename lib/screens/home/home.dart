import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/dashboard_models.dart';
import '../../services/user_session.dart';
import '../../services/dashboard_service.dart';
import '../demandes/demandes.dart';
import '../wallet/wallet.dart';
import '../profil/profil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _BarChart extends StatelessWidget {
  final List<PerformanceHebdo> data;
  const _BarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();
    return CustomPaint(
      size: const Size(339, 220),
      painter: _BarChartPainter(data),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<PerformanceHebdo> data;
  _BarChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    const bottomPadding = 28.0;
    const topPadding = 12.0;
    const leftPadding = 4.0;
    final chartHeight = size.height - bottomPadding - topPadding;
    final maxVal = data.map((e) => e.montant).reduce((a, b) => a > b ? a : b);
    final barWidth = (size.width / data.length) * 0.45;
    final gap = size.width / data.length;

    final axisPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final barPaint = Paint()..color = const Color(0xFF6F675E);
    final textStyle = TextStyle(
      color: const Color(0xFF9CA3AF),
      fontSize: 10,
      fontFamily: GoogleFonts.inter().fontFamily,
    );

    // Axe des ordonnées (trait vertical gauche)
    canvas.drawLine(
      Offset(leftPadding, topPadding),
      Offset(leftPadding, topPadding + chartHeight),
      axisPaint,
    );

    // Axe des abscisses (trait horizontal bas)
    canvas.drawLine(
      Offset(leftPadding, topPadding + chartHeight),
      Offset(size.width, topPadding + chartHeight),
      axisPaint,
    );

    for (int i = 0; i < data.length; i++) {
      final x = gap * i + gap / 2;
      final barH = maxVal == 0 ? 8.0 : (data[i].montant / maxVal) * chartHeight;
      final effectiveH = barH < 8 ? 8.0 : barH;

      // barre
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x - barWidth / 2, topPadding + chartHeight - effectiveH, barWidth, effectiveH),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      );
      canvas.drawRRect(rect, barPaint);

      // label jour
      final tp = TextPainter(
        text: TextSpan(text: data[i].jour, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - bottomPadding + 6));
    }
  }

  @override
  bool shouldRepaint(_BarChartPainter old) => old.data != data;
}

class _HomePageState extends State<HomePage> {
  DashboardData? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await DashboardService().getDashboard();
      if (mounted) setState(() => _data = data);
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _initialsWidget(String initials) {
    return Container(
      width: 25, height: 25,
      color: const Color(0xFF6F675E),
      child: Center(
        child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
      ),
    );
  }

  String _formatVariation(double v) {
    if (v > 0) return '+${v.toStringAsFixed(0)}%';
    if (v < 0) return '${v.toStringAsFixed(0)}%';
    return '0%';
  }

  Color _variationColor(double v) {
    if (v > 0) return const Color(0xFF00A63E);
    return const Color(0xFF99A1AF);
  }

  String _formatAmountShort(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }

  String _formatFCFA(double v) {
    final n = v.toInt();
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return '${buf.toString()} FCFA';
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

  Widget _statCard({
    required Color iconBgColor,
    required String iconPath,
    required String count,
    required String label,
    required String trend,
    required Color trendColor,
    double trendFontSize = 14,
  }) {
    return Container(
      width: 110,
      height: 119,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFFFFF), width: 0.5),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      spreadRadius: -1,
                    ),
                    BoxShadow(
                      color: Color(0x1A000000),
                      offset: Offset(0, 1),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(iconPath, width: 20, height: 20),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                count,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  height: 1.2,
                  letterSpacing: 0.07,
                  color: const Color(0xFF2D2520),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
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
          Positioned(
            top: 14,
            right: 0,
            child: Text(
              trend,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: trendFontSize,
                height: 16 / trendFontSize,
                letterSpacing: 0,
                color: trendColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chartStat({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            height: 16 / 12,
            letterSpacing: 0,
            color: const Color(0xFF6A7282),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            height: 20 / 14,
            letterSpacing: -0.15,
            color: const Color(0x99000000),
          ),
        ),
      ],
    );
  }

  Widget _iconCard({
    required String iconPath,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: 110,
      height: 119,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFFFFF), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Opacity(
            opacity: 0.9,
            child: SvgPicture.asset(iconPath, width: 24, height: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              height: 1.2,
              letterSpacing: 0.07,
              color: const Color(0xFF2D2520),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 11,
              height: 16 / 11,
              letterSpacing: 0,
              color: const Color(0xFF6A7282),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(50),
        bottomRight: Radius.circular(50),
      ),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/header image.png',
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
          Container(
            width: double.infinity,
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0xAD6F675E),
                  Color(0xD96F675E),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF6F675E)),
      );
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDashboard,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6F675E)),
              child: const Text('Réessayer',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    final d = _data!;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 302,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildHeader(),
                Positioned(
                  top: 183,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statCard(
                        iconBgColor: const Color(0xFF2B7FFF),
                        iconPath: 'assets/icons/Demande.svg',
                        count: '${d.totalRequestsCount}',
                        label: 'Demandes',
                        trend: _formatVariation(d.requestsVariation),
                        trendColor: _variationColor(d.requestsVariation),
                        trendFontSize: 11,
                      ),
                      _statCard(
                        iconBgColor: const Color(0xFFF9C20A),
                        iconPath: 'assets/icons/En attente.svg',
                        count: '${d.pendingQuotesCount}',
                        label: 'En attente',
                        trend: _formatVariation(d.pendingQuotesVariation),
                        trendColor: _variationColor(d.pendingQuotesVariation),
                        trendFontSize: 11,
                      ),
                      _statCard(
                        iconBgColor: const Color(0xFFAD46FF),
                        iconPath: 'assets/icons/En cours.svg',
                        count: '${d.inProgressCount}',
                        label: 'En cours',
                        trend: _formatVariation(d.inProgressVariation),
                        trendColor: _variationColor(d.inProgressVariation),
                        trendFontSize: 11,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              width: 360,
              height: 119,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statCard(
                    iconBgColor: const Color(0xFF00C950),
                    iconPath: 'assets/icons/Valide.svg',
                    count: '${d.validatedCount}',
                    label: 'Validé',
                    trend: _formatVariation(d.validatedVariation),
                    trendColor: _variationColor(d.validatedVariation),
                    trendFontSize: 11,
                  ),
                  _iconCard(
                    iconPath: 'assets/icons/Missions.svg',
                    title: 'Missions',
                    subtitle: '${d.pendingMissionsCount} en attente',
                  ),
                  _iconCard(
                    iconPath: 'assets/icons/Paiement.svg',
                    title: 'Paiements',
                    subtitle:
                        '${_formatAmountShort(d.pendingPaymentsAmount)} en attente',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 370,
            height: 391,
            padding: const EdgeInsets.only(
              top: 20.5,
              right: 20.5,
              bottom: 0.5,
              left: 20.5,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFFFFF), width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Performance hebdomadaire',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            height: 24 / 16,
                            letterSpacing: -0.31,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        Text(
                          'Revenus des 7 derniers jours',
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
                    Container(
                      width: 58,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0x1AF9C20A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          _formatVariation(d.variationHebdo),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            height: 16 / 12,
                            letterSpacing: 0,
                            color: const Color(0xFFF9C20A),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 339,
                  height: 220,
                  child: _BarChart(data: d.performanceHebdo),
                ),
                Container(
                  width: 339,
                  height: 56,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0xFFF3F4F6), width: 0.5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _chartStat(
                            label: 'Total',
                            value: _formatFCFA(d.totalRevenu)),
                        _chartStat(
                            label: 'Moyenne/jour',
                            value: _formatFCFA(d.moyenneParJour)),
                        _chartStat(
                            label: 'Interventions',
                            value: '${d.totalInterventions}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              _navItem('assets/icons/accueil.svg', 'Accueil'),
              const SizedBox(width: 56),
              _navItem(
                'assets/icons/demande nav.svg',
                'Demandes',
                onTap: () => Navigator.of(ctx).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (c, a, s) => const DemandesPage(),
                    transitionsBuilder: (c, anim, s, child) => FadeTransition(
                      opacity:
                          CurvedAnimation(parent: anim, curve: Curves.easeOut),
                      child: child,
                    ),
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ),
              const SizedBox(width: 56),
              _navItem(
                'assets/icons/wallet.svg',
                'Wallet',
                onTap: () => Navigator.of(ctx).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (c, a, s) => const WalletPage(),
                    transitionsBuilder: (c, anim, s, child) => FadeTransition(
                      opacity:
                          CurvedAnimation(parent: anim, curve: Curves.easeOut),
                      child: child,
                    ),
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ),
              const SizedBox(width: 56),
              _navItem(
                'assets/icons/profil.svg',
                'Mon profil',
                onTap: () => Navigator.of(ctx).pushReplacement(PageRouteBuilder(
                  pageBuilder: (c, a, s) => const ProfilPage(),
                  transitionsBuilder: (c, anim, s, child) => FadeTransition(
                      opacity: CurvedAnimation(
                          parent: anim, curve: Curves.easeOut),
                      child: child),
                  transitionDuration: const Duration(milliseconds: 300),
                )),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBody(),
          Positioned(
            top: 72,
            right: 24,
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/notification.svg',
                    width: 24, height: 24),
                const SizedBox(width: 8),
                ValueListenableBuilder<String?>(
                  valueListenable: UserSession.instance.localPhotoPath,
                  builder: (_, localPath, __) {
                    final photoUrl = _data?.profilePhotoUrl;
                    final name = _data?.companyName.trim() ?? '';
                    final initials = name.isNotEmpty
                        ? name.split(' ').take(2).map((w) => w[0].toUpperCase()).join()
                        : '?';
                    Widget avatar;
                    if (localPath != null) {
                      avatar = Image.file(File(localPath), width: 25, height: 25, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _initialsWidget(initials));
                    } else if (photoUrl != null && photoUrl.isNotEmpty) {
                      if (photoUrl.startsWith('data:image')) {
                        try {
                          final bytes = base64Decode(photoUrl.substring(photoUrl.indexOf(',') + 1));
                          avatar = Image.memory(bytes, width: 25, height: 25, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _initialsWidget(initials));
                        } catch (_) { avatar = _initialsWidget(initials); }
                      } else {
                        avatar = Image.network(photoUrl, width: 25, height: 25, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _initialsWidget(initials));
                      }
                    } else {
                      avatar = _initialsWidget(initials);
                    }
                    return Container(
                      width: 25, height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFFFFFFF), width: 1),
                      ),
                      child: ClipOval(child: avatar),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 72,
            left: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour',
                  style: GoogleFonts.jost(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 22 / 14,
                    letterSpacing: 14 * 0.005,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
                Text(
                  _data?.companyName ?? '',
                  style: GoogleFonts.jost(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    height: 25 / 24,
                    letterSpacing: 24 * 0.005,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
                if (_data?.role != null && _data!.role.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0x33FFFFFF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      _data!.role,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 11, color: const Color(0xFFFFFFFF)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
