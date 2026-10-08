import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/widgets/app_bottom_nav_bar.dart';
import '../widgets/demande_card.dart';
import '../widgets/demande_search_bar.dart';
import 'demande_details.dart';
import 'package:solimus_prestataire/features/demandes/data/services/demandes_service.dart';
import 'package:solimus_prestataire/features/demandes/data/models/demandes_models.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

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
                decoration: BoxDecoration(color: AppColors.grey300, borderRadius: BorderRadius.circular(999)),
              ),
            ),
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
                    _applyFilters();
                    Navigator.of(ctx).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : AppColors.grey100,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(labels[i], style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600, fontSize: 13,
                      color: selected ? Colors.white : AppColors.grey600,
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



  @override
  Widget build(BuildContext context) {
    final countLabel = _loading
        ? 'Chargement...'
        : _error != null
            ? 'Erreur de chargement'
            : '$_totalCount demande${_totalCount > 1 ? 's' : ''} reçue${_totalCount > 1 ? 's' : ''}';

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNavBar(currentTab: AppTab.demandes),
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
                  color: AppColors.primary,
                ),
                Container(
                  width: double.infinity,
                  height: 135,
                  color: AppColors.black40,
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
                            color: AppColors.surfaceMuted,
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
                          color: AppColors.white,
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
          DemandeSearchBar(
            controller: _searchController,
            onChanged: (_) => _applyFilters(),
            onFilterTap: _showFilterSheet,
          ),
          // Liste des demandes
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
                        backgroundColor: AppColors.primary),
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
                  color: AppColors.greyCool,
                ),
              ),
            )
          else
            ..._requests!.map((DemandeRequestSummary req) {
              return DemandeCard(
                request: req,
                onTap: () => Navigator.of(context).push(
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
              );
            }),
          const SizedBox(height: 16),
        ],
      ),
      ),
    );
  }
}
