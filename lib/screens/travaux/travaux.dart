import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home.dart';
import '../demandes/demandes.dart';
import '../wallet/wallet.dart';
import '../profil/profil.dart';
import '../../models/travaux_models.dart';
import '../../services/demandes_service.dart';
import 'travaux_detail.dart';
import '../../widgets/nav_item.dart';

class TravauxPage extends StatefulWidget {
  const TravauxPage({super.key});

  @override
  State<TravauxPage> createState() => _TravauxPageState();
}

class _TravauxPageState extends State<TravauxPage> {
  List<TravauxSummary>? _items;
  int _pendingCount = 0;
  int _totalElements = 0;
  bool _loading = true;
  String? _error;
  final _searchController = TextEditingController();
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final page = await DemandesService().getTravaux(
        search: _searchController.text.isEmpty ? null : _searchController.text,
        status: _selectedStatus,
      );
      if (mounted) setState(() {
        _items = page.content;
        _pendingCount = page.pendingCount;
        _totalElements = page.totalElements;
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString().replaceFirst('Exception: ', ''); _loading = false; });
    }
  }

  void _showFilterSheet() {
    final statuses = [null, 'PENDING', 'SYNDIC_ASSIGNED', 'QUOTE_VALIDATED', 'STARTED', 'FINISHED', 'FINAL_VALIDATION', 'CANCELLED'];
    final labels = ['Tous', 'En attente', 'Assigné', 'Devis validé', 'Démarré', 'Terminé', 'Validation finale', 'Annulé'];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFD1D5DB), borderRadius: BorderRadius.circular(999)))),
            const SizedBox(height: 16),
            Text('Filtrer par statut', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16, color: const Color(0xFF2D2520))),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: List.generate(statuses.length, (i) {
                final selected = _selectedStatus == statuses[i];
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedStatus = statuses[i]);
                    _load();
                    Navigator.of(ctx).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF6F675E) : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(labels[i], style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13, color: selected ? Colors.white : const Color(0xFF4A5565))),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  String _relativeTime(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inDays >= 1) return 'il y a ${diff.inDays}j';
    if (diff.inHours >= 1) return 'il y a ${diff.inHours}h';
    return 'il y a ${diff.inMinutes}min';
  }

  Color _badgeBg(String status) {
    switch (status) {
      case 'PENDING':          return const Color(0x1AF9C20A);
      case 'STARTED':          return const Color(0x1AAD46FF);
      case 'FINISHED':         return const Color(0x1AFE9A00);
      case 'CANCELLED':        return const Color(0x1AFD3C4A);
      default:                 return const Color(0x1A6F675E);
    }
  }

  Color _badgeText(String status) {
    switch (status) {
      case 'PENDING':          return const Color(0xFFF9C20A);
      case 'STARTED':          return const Color(0xFFAD46FF);
      case 'FINISHED':         return const Color(0xFFC37600);
      case 'CANCELLED':        return const Color(0xFFFD3C4A);
      default:                 return const Color(0xFF6F675E);
    }
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
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            boxShadow: [BoxShadow(color: Color(0x1A000000), offset: Offset(0, -1), blurRadius: 32)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NavItem(iconPath: 'assets/icons/accueil.svg', label: 'Accueil',
                onTap: () => Navigator.of(ctx).pushReplacement(PageRouteBuilder(
                  pageBuilder: (c, a, s) => const HomePage(),
                  transitionsBuilder: (c, anim, s, child) => FadeTransition(opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
                  transitionDuration: const Duration(milliseconds: 300),
                )),
              ),
              const SizedBox(width: 30),
              NavItem(iconPath: 'assets/icons/demande nav.svg', label: 'Demandes',
                onTap: () => Navigator.of(ctx).pushReplacement(PageRouteBuilder(
                  pageBuilder: (c, a, s) => const DemandesPage(),
                  transitionsBuilder: (c, anim, s, child) => FadeTransition(opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
                  transitionDuration: const Duration(milliseconds: 300),
                )),
              ),
              const SizedBox(width: 30),
              const NavItem(iconPath: 'assets/icons/travaux.svg', label: 'Travaux', isActive: true),
              const SizedBox(width: 30),
              NavItem(iconPath: 'assets/icons/wallet.svg', label: 'Wallet',
                onTap: () => Navigator.of(ctx).pushReplacement(PageRouteBuilder(
                  pageBuilder: (c, a, s) => const WalletPage(),
                  transitionsBuilder: (c, anim, s, child) => FadeTransition(opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
                  transitionDuration: const Duration(milliseconds: 300),
                )),
              ),
              const SizedBox(width: 30),
              NavItem(iconPath: 'assets/icons/profil.svg', label: 'Mon profil',
                onTap: () => Navigator.of(ctx).pushReplacement(PageRouteBuilder(
                  pageBuilder: (c, a, s) => const ProfilPage(),
                  transitionsBuilder: (c, anim, s, child) => FadeTransition(opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
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
            SizedBox(
              height: 135,
              child: Stack(
                children: [
                  Container(width: double.infinity, height: 135, color: const Color(0xFF6F675E)),
                  Container(width: double.infinity, height: 135, color: const Color(0x66000000)),
                  Positioned(
                    top: 65, left: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mes travaux', style: GoogleFonts.jost(fontWeight: FontWeight.w700, fontSize: 20, height: 25 / 20, letterSpacing: 20 * 0.005, color: const Color(0xFFFDFDFD))),
                        Text(
                          _loading ? 'Chargement...' : _error != null ? 'Erreur de chargement' : '$_totalElements travail${_totalElements > 1 ? 'x' : ''} • $_pendingCount en attente',
                          style: GoogleFonts.jost(fontWeight: FontWeight.w400, fontSize: 14, height: 22 / 14, color: const Color(0xFFFFFFFF)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 23),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Container(
                width: 365,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFD6D2C9), width: 1),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/icons/Search.svg', width: 24, height: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => _load(),
                        style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w400, fontSize: 16, color: const Color(0xFF292B2D)),
                        decoration: InputDecoration(
                          hintText: 'Rechercher',
                          hintStyle: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w400, fontSize: 16, color: const Color(0xFF575B66)),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _showFilterSheet,
                      child: SvgPicture.asset('assets/icons/Filter.svg', width: 24, height: 24),
                    ),
                  ],
                ),
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
                    Text(_error!, textAlign: TextAlign.center, style: GoogleFonts.beVietnamPro(color: Colors.red)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _load,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6F675E)),
                      child: const Text('Réessayer', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              )
            else if (_items == null || _items!.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text('Aucun travail en cours', style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w500, fontSize: 16, color: const Color(0xFF91919F))),
              )
            else
              ..._items!.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Center(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TravauxDetailPage(id: t.id))).then((_) => _load()),
                    child: Container(
                      width: 370,
                      height: 92,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                Container(
                                  width: 60, height: 60,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: const Color(0x1A6F675E), borderRadius: BorderRadius.circular(10)),
                                  child: Center(child: SvgPicture.asset('assets/icons/travaux.svg', width: 27.5, height: 27.5)),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(t.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w500, fontSize: 18, height: 1.0, color: const Color(0xFF292B2D))),
                                      const SizedBox(height: 8),
                                      Text(t.residenceName, maxLines: 1, overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w500, fontSize: 14, height: 1.0, color: const Color(0xFF91919F))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: _badgeBg(t.status), borderRadius: BorderRadius.circular(4)),
                                child: Text(t.statusLabel, style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600, fontSize: 12, height: 1.0, color: _badgeText(t.status))),
                              ),
                              const SizedBox(height: 6),
                              Text(_relativeTime(t.createdAt), style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w500, fontSize: 13, height: 1.0, color: const Color(0xFF91919F))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
