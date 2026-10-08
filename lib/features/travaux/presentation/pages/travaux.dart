import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/widgets/app_bottom_nav_bar.dart';
import '../widgets/travaux_card.dart';
import 'package:solimus_prestataire/features/travaux/data/models/travaux_models.dart';
import 'package:solimus_prestataire/features/demandes/data/services/demandes_service.dart';
import 'travaux_detail.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

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
      if (mounted) {
        setState(() {
          _items = page.content;
          _pendingCount = page.pendingCount;
          _totalElements = page.totalElements;
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
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.grey300, borderRadius: BorderRadius.circular(999)))),
            const SizedBox(height: 16),
            Text('Filtrer par statut', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.primaryDark)),
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
                      color: selected ? AppColors.primary : AppColors.grey100,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(labels[i], style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13, color: selected ? Colors.white : AppColors.grey600)),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNavBar(currentTab: AppTab.travaux),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 135,
              child: Stack(
                children: [
                  Container(width: double.infinity, height: 135, color: AppColors.primary),
                  Container(width: double.infinity, height: 135, color: AppColors.black40),
                  Positioned(
                    top: 65, left: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mes travaux', style: GoogleFonts.jost(fontWeight: FontWeight.w700, fontSize: 20, height: 25 / 20, letterSpacing: 20 * 0.005, color: AppColors.surfaceMuted)),
                        Text(
                          _loading ? 'Chargement...' : _error != null ? 'Erreur de chargement' : '$_totalElements travail${_totalElements > 1 ? 'x' : ''} • $_pendingCount en attente',
                          style: GoogleFonts.jost(fontWeight: FontWeight.w400, fontSize: 14, height: 22 / 14, color: AppColors.white),
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
                  border: Border.all(color: AppColors.warmGrey, width: 1),
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
                        style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w400, fontSize: 16, color: AppColors.darkNeutral),
                        decoration: InputDecoration(
                          hintText: 'Rechercher',
                          hintStyle: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w400, fontSize: 16, color: AppColors.slate700),
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
                child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
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
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: const Text('Réessayer', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              )
            else if (_items == null || _items!.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text('Aucun travail en cours', style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w500, fontSize: 16, color: AppColors.greyCool)),
              )
            else
              ..._items!.map((t) => TravauxCard(
                item: t,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => TravauxDetailPage(id: t.id)),
                ).then((_) => _load()),
              )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
