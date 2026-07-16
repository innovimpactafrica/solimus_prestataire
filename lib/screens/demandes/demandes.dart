import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home.dart';
import '../wallet/wallet.dart';
import '../profil/profil.dart';
import '../travaux/travaux.dart';
import '../../widgets/nav_item.dart';
import 'demande_details.dart';
import '../../services/demandes_service.dart';
import '../../models/demandes_models.dart';

class DemandesPage extends StatefulWidget {
  const DemandesPage({super.key});

  @override
  State<DemandesPage> createState() => _DemandesPageState();
}

class _DemandesPageState extends State<DemandesPage> {
  List<DemandeRequestSummary>? _requests;
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
    if (!mounted) return;
    setState(() { _loading = true; _error = null; });
    try {
      final page = await DemandesService().getAvailableRequests(
        search: _searchController.text.isEmpty ? null : _searchController.text,
        status: _selectedStatus,
      );
      if (!mounted) return;
      setState(() {
        _requests = page.content;
        _totalElements = page.totalReceivedRequests;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  void _applyFilters() => _load();

  void _showFilterSheet() {
    final statuses = [
      null,
      'PENDING_QUOTE',
      'QUOTE_SENT',
      'REJECTED',
    ];
    final labels = [
      'Tous',
      'En attente de devis',
      'Devis envoyé',
      'Rejeté',
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: const Color(0xFFD1D5DB), borderRadius: BorderRadius.circular(999)),
              ),
            ),
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
                    _applyFilters();
                    Navigator.of(ctx).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF6F675E) : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(labels[i], style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600, fontSize: 13,
                      color: selected ? Colors.white : const Color(0xFF4A5565),
                    )),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  int get _totalCount => _requests?.length ?? _totalElements;

  String _relativeTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays >= 1) return 'il y a ${diff.inDays} jour${diff.inDays > 1 ? 's' : ''}';
    if (diff.inHours >= 1) return 'il y a ${diff.inHours}h';
    if (diff.inMinutes >= 1) return 'il y a ${diff.inMinutes} min';
    return "à l'instant";
  }

  Color _badgeBg(String status) {
    switch (status) {
      case 'PENDING':           return const Color(0x1AF9C20A);
      case 'QUOTE_SENT':        return const Color(0x1AAD46FF);
      case 'SYNDIC_VALIDATED':  return const Color(0x1A1447E6);
      case 'STARTED':           return const Color(0x1AAD46FF);
      case 'FINISHED':          return const Color(0x1AFE9A00);
      case 'FINAL_VALIDATION':  return const Color(0x1A0A9748);
      case 'CANCELLED':         return const Color(0x1AFD3C4A);
      // labels français
      case 'Signalé':           return const Color(0x1AF9C20A);
      case 'En cours':          return const Color(0x1AAD46FF);
      case 'Devis':             return const Color(0x1A1447E6);
      case 'Démarré':           return const Color(0x1AAD46FF);
      case 'Terminé':           return const Color(0x1AFE9A00);
      case 'Validé':            return const Color(0x1A0A9748);
      case 'Clôturé':           return const Color(0x1A0A9748);
      case 'Annulé':            return const Color(0x1AFD3C4A);
      default:                  return const Color(0x1A6F675E);
    }
  }

  Color _badgeText(String status) {
    switch (status) {
      case 'PENDING':           return const Color(0xFFF9C20A);
      case 'QUOTE_SENT':        return const Color(0xFFAD46FF);
      case 'SYNDIC_VALIDATED':  return const Color(0xFF1447E6);
      case 'STARTED':           return const Color(0xFFAD46FF);
      case 'FINISHED':          return const Color(0xFFC37600);
      case 'FINAL_VALIDATION':  return const Color(0xFF0A9748);
      case 'CANCELLED':         return const Color(0xFFFD3C4A);
      // labels français
      case 'Signalé':           return const Color(0xFFF9C20A);
      case 'En cours':          return const Color(0xFFAD46FF);
      case 'Devis':             return const Color(0xFF1447E6);
      case 'Démarré':           return const Color(0xFFAD46FF);
      case 'Terminé':           return const Color(0xFFC37600);
      case 'Validé':            return const Color(0xFF0A9748);
      case 'Clôturé':           return const Color(0xFF0A9748);
      case 'Annulé':            return const Color(0xFFFD3C4A);
      default:                  return const Color(0xFF6F675E);
    }
  }

  @override
  Widget build(BuildContext context) {
    final countLabel = _loading
        ? 'Chargement...'
        : _error != null
            ? 'Erreur de chargement'
            : '$_totalCount demande${_totalCount > 1 ? 's' : ''} reçue${_totalCount > 1 ? 's' : ''}';

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
              NavItem(iconPath: 'assets/icons/accueil.svg', label: 'Accueil',
                onTap: () => Navigator.of(ctx).pushReplacement(PageRouteBuilder(
                  pageBuilder: (c, a, s) => const HomePage(),
                  transitionsBuilder: (c, anim, s, child) => FadeTransition(opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
                  transitionDuration: const Duration(milliseconds: 300),
                )),
              ),
              const SizedBox(width: 30),
              const NavItem(iconPath: 'assets/icons/demande nav.svg', label: 'Demandes', isActive: true),
              const SizedBox(width: 30),
              NavItem(iconPath: 'assets/icons/travaux.svg', label: 'Travaux',
                onTap: () => Navigator.of(ctx).pushReplacement(PageRouteBuilder(
                  pageBuilder: (c, a, s) => const TravauxPage(),
                  transitionsBuilder: (c, anim, s, child) => FadeTransition(opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
                  transitionDuration: const Duration(milliseconds: 300),
                )),
              ),
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
                Container(
                  width: double.infinity,
                  height: 135,
                  color: const Color(0x66000000),
                ),
                Positioned(
                  top: 65,
                  left: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 198,
                        child: Text(
                          'Demande de travaux',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.jost(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            height: 25 / 20,
                            letterSpacing: 20 * 0.005,
                            color: const Color(0xFFFDFDFD),
                          ),
                        ),
                      ),
                      Text(
                        countLabel,
                        style: GoogleFonts.jost(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 22 / 14,
                          letterSpacing: 14 * 0.005,
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Barre de recherche
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
                      onChanged: (_) => _applyFilters(),
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
          // Liste des demandes
          const SizedBox(height: 20),
          if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFF6F675E)),
              ),
            )
          else if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: Column(
                children: [
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.beVietnamPro(color: Colors.red),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _load,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6F675E)),
                    child: const Text('Réessayer',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            )
          else if (_requests!.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'Aucune demande reçue',
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: const Color(0xFF91919F),
                ),
              ),
            )
          else
            ..._requests!.map((DemandeRequestSummary req) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Center(
                  child: Builder(
                    builder: (ctx) => GestureDetector(
                      onTap: () => Navigator.of(ctx).push(
                        PageRouteBuilder(
                          pageBuilder: (c, a, s) =>
                              DemandeDetailsPage(requestId: req.id),
                          transitionsBuilder: (c, anim, s, child) =>
                              FadeTransition(
                            opacity: CurvedAnimation(
                                parent: anim, curve: Curves.easeOut),
                            child: child,
                          ),
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      ),
                      child: Container(
                        width: 370,
                        height: 92,
                        padding: const EdgeInsets.only(
                          top: 16,
                          right: 12,
                          bottom: 16,
                          left: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0x1A6F675E),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/icons/clef.svg',
                                        width: 27.5,
                                        height: 27.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          req.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.beVietnamPro(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            height: 1.0,
                                            letterSpacing: 0,
                                            color: const Color(0xFF292B2D),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          req.residenceName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.beVietnamPro(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            height: 1.0,
                                            letterSpacing: 0,
                                            color: const Color(0xFF91919F),
                                          ),
                                        ),
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _badgeBg(req.status),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    req.statusLabel,
                                    style: GoogleFonts.beVietnamPro(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      height: 1.0,
                                      letterSpacing: 0,
                                      color: _badgeText(req.status),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _relativeTime(req.createdAt),
                                  style: GoogleFonts.beVietnamPro(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    height: 1.0,
                                    letterSpacing: 0,
                                    color: const Color(0xFF91919F),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          const SizedBox(height: 16),
        ],
      ),
      ),
    );
  }
}
