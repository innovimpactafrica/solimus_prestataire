import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/features/demandes/data/models/devis_models.dart';
import 'package:solimus_prestataire/features/demandes/data/services/demandes_service.dart';
import 'devis_detail.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/core/widgets/subpage_header.dart';
import '../widgets/mes_devis_item_card.dart';
import '../widgets/devis_total_valide_card.dart';

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
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await DemandesService().getQuotes();
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

  List<DevisSummary> get _filtered {
    if (_data == null) return [];
    var all = _data!.content;
    if (_searchQuery.isNotEmpty) {
      all = all
          .where((d) =>
              d.reference.toLowerCase().contains(_searchQuery) ||
              d.requestTitle.toLowerCase().contains(_searchQuery))
          .toList();
    }
    switch (_selectedFilter) {
      case 1:
        return all.where((d) => d.status == 'ACCEPTED').toList();
      case 2:
        return all
            .where((d) => d.status == 'SENT' || d.status == 'DRAFT')
            .toList();
      case 3:
        return all.where((d) => d.status == 'REJECTED').toList();
      default:
        return all;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final totalValide = _data?.totalMontantValide ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SubpageHeader(
              title: 'Mes devis',
              subtitle: 'Consultez les devis',
            ),
            const SizedBox(height: 20),

            // Carte montant total validé
            DevisTotalValideCard(
              totalAmount: totalValide,
              isLoading: _loading,
            ),
            const SizedBox(height: 16),

            // Barre de recherche
            Container(
              width: 365,
              height: 49,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.warmGrey, width: 0.5),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  SvgPicture.asset('assets/icons/search1.svg',
                      width: 20, height: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) =>
                          setState(() => _searchQuery = v.toLowerCase()),
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.primaryDark,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Rechercher un devis...',
                        hintStyle: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.overlayDark,
                        ),
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
                    SvgPicture.asset('assets/icons/filtrer.svg',
                        width: 16, height: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Filtrer :',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height: 20 / 14,
                        letterSpacing: -0.15,
                        color: AppColors.grey600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ...List.generate(_filters.length, (i) {
                      final selected = _selectedFilter == i;
                      return Padding(
                        padding: EdgeInsets.only(
                            right: i < _filters.length - 1 ? 8 : 0),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedFilter = i),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(999),
                              border: selected
                                  ? null
                                  : Border.all(
                                      color: AppColors.warmGrey,
                                      width: 0.5,
                                    ),
                            ),
                            child: Text(
                              _filters[i],
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                height: 1.0,
                                color: selected
                                    ? AppColors.white
                                    : AppColors.charcoal,
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
            else ...[
              SizedBox(
                width: 365,
                child: Text(
                  '${filtered.length} devis trouvés',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    height: 1.0,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(
                filtered.length,
                (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: MesDevisItemCard(
                    devis: filtered[i],
                    onTap: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (c, a, s) =>
                            DevisDetailPage(id: filtered[i].id),
                        transitionsBuilder: (c, anim, s, child) =>
                            FadeTransition(
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
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
