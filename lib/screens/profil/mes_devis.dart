import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/devis_models.dart';
import '../../services/demandes_service.dart';
import 'devis_detail.dart';

class MesDevisPage extends StatefulWidget {
  const MesDevisPage({super.key});

  @override
  State<MesDevisPage> createState() => _MesDevisPageState();
}

class _MesDevisPageState extends State<MesDevisPage> {
  int _selectedFilter = 0;
  final List<String> _filters = ['Tous', 'Validés', 'En attente', 'Refusé'];
  final _searchController = TextEditingController();
  String _searchQuery = '';

  DevisListResponse? _data;
  bool _loading = true;
  String? _error;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await DemandesService().getQuotes();
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

  String _statusLabel(String status) {
    switch (status) {
      case 'ACCEPTED': return 'Validé';
      case 'SENT':     return 'En attente';
      case 'DRAFT':    return 'Brouillon';
      case 'REJECTED': return 'Refusé';
      default:         return status;
    }
  }

  Color _badgeBg(String status) {
    switch (status) {
      case 'ACCEPTED': return const Color(0xFFEBFAF0);
      case 'SENT':     return const Color(0xFFFFF8E6);
      case 'DRAFT':    return const Color(0xFFF3F4F6);
      case 'REJECTED': return const Color(0xFFFFEEEE);
      default:         return const Color(0xFFF3F4F6);
    }
  }

  Color _badgeText(String status) {
    switch (status) {
      case 'ACCEPTED': return const Color(0xFF0A9748);
      case 'SENT':     return const Color(0xFFC37600);
      case 'DRAFT':    return const Color(0xFF6A7282);
      case 'REJECTED': return const Color(0xFFE53935);
      default:         return const Color(0xFF6A7282);
    }
  }

  List<DevisSummary> get _filtered {
    if (_data == null) return [];
    var all = _data!.content;
    if (_searchQuery.isNotEmpty) {
      all = all.where((d) =>
        d.reference.toLowerCase().contains(_searchQuery) ||
        d.requestTitle.toLowerCase().contains(_searchQuery)
      ).toList();
    }
    switch (_selectedFilter) {
      case 1: return all.where((d) => d.status == 'ACCEPTED').toList();
      case 2: return all.where((d) => d.status == 'SENT' || d.status == 'DRAFT').toList();
      case 3: return all.where((d) => d.status == 'REJECTED').toList();
      default: return all;
    }
  }

  Widget _devisCard(DevisSummary d) {
    return Container(
      width: 365,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ligne 1: ref + badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                d.reference,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  height: 1.0,
                  letterSpacing: 0,
                  color: const Color(0xFF2D2520),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: _badgeBg(d.status),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  _statusLabel(d.status),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    height: 1.0,
                    color: _badgeText(d.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Titre
          Text(
            d.requestTitle,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              height: 1.2,
              color: const Color(0xFF2D2520),
            ),
          ),
          const SizedBox(height: 12),
          // Divider
          const Divider(color: Color(0xFFF3F4F6), thickness: 1, height: 1),
          const SizedBox(height: 12),
          // Date + Montant
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(d.createdAt),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  height: 1.0,
                  color: const Color(0xFF6A7282),
                ),
              ),
              Text(
                _formatAmount(d.totalAmount),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  height: 1.0,
                  letterSpacing: -0.3,
                  color: const Color(0xFF6F675E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final totalValide = _data?.totalMontantValide ?? 0;

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
                            width: 40, height: 40,
                            decoration: const BoxDecoration(color: Color(0x33FFFFFF), shape: BoxShape.circle),
                            child: Center(child: SvgPicture.asset('assets/icons/fleche gauche.svg', width: 20, height: 20)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Mes devis',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 20, height: 32 / 20, letterSpacing: 0.07, color: const Color(0xFFFFFFFF)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Consultez les devis',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFFFFFFFF)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Carte montant total validé
            Container(
              width: 365,
              height: 96,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6F675E), Color(0xFF6D655C), Color(0xFF6A625A), Color(0xFF686058),
                    Color(0xFF665E55), Color(0xFF635B53), Color(0xFF615951), Color(0xFF5F574F),
                    Color(0xFF5C544D), Color(0xFF5A524B),
                  ],
                  stops: [0.0, 0.1111, 0.2222, 0.3333, 0.4444, 0.5556, 0.6667, 0.7778, 0.8889, 1.0],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: const Color(0x33FFFFFF), borderRadius: BorderRadius.circular(14)),
                    child: Center(child: SvgPicture.asset('assets/icons/preview.svg', width: 20, height: 20)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Montant total validé',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFFFFFFFF)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _loading ? '...' : _formatAmount(totalValide),
                        style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 24, height: 32 / 24, letterSpacing: 0.07, color: const Color(0xFFFFFFFF)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Barre de recherche
            Container(
              width: 365,
              height: 49,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFD6D2C9), width: 0.5),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  SvgPicture.asset('assets/icons/search1.svg', width: 20, height: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                      style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, color: const Color(0xFF2D2520)),
                      decoration: InputDecoration(
                        hintText: 'Rechercher un devis...',
                        hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, color: const Color(0x800A0A0A)),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Ligne filtres
            SizedBox(
              width: 365,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SvgPicture.asset('assets/icons/filtrer.svg', width: 16, height: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Filtrer :',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFF4A5565)),
                    ),
                    const SizedBox(width: 10),
                    ...List.generate(_filters.length, (i) {
                      final selected = _selectedFilter == i;
                      return Padding(
                        padding: EdgeInsets.only(right: i < _filters.length - 1 ? 8 : 0),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedFilter = i),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: selected ? const Color(0xFF6F675E) : const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(999),
                              border: selected ? null : Border.all(color: const Color(0xFFD6D2C9), width: 0.5),
                            ),
                            child: Text(
                              _filters[i],
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                height: 1.0,
                                color: selected ? const Color(0xFFFFFFFF) : const Color(0xFF2F3542),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: CircularProgressIndicator(color: Color(0xFF6F675E)),
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
              SizedBox(
                width: 365,
                child: Text(
                  '${filtered.length} devis trouvés',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15, height: 1.0, color: const Color(0xFF2D2520)),
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(filtered.length, (i) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (c, a, s) => DevisDetailPage(id: filtered[i].id),
                    transitionsBuilder: (c, anim, s, child) => FadeTransition(
                      opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
                    transitionDuration: const Duration(milliseconds: 300),
                  )),
                  child: _devisCard(filtered[i]),
                ),
              )),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
