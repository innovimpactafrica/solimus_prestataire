import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/features/travaux/data/models/travaux_models.dart';
import 'package:solimus_prestataire/features/demandes/data/services/demandes_service.dart';
import 'package:solimus_prestataire/features/demandes/presentation/pages/create_devis.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/core/widgets/subpage_header.dart';
import 'package:solimus_prestataire/features/demandes/presentation/widgets/workflow_step_tile.dart';
import 'package:solimus_prestataire/features/demandes/presentation/widgets/problem_photo_tile.dart';
import 'package:solimus_prestataire/features/demandes/presentation/widgets/demande_action_button.dart';
import 'travaux_en_cours.dart';

class TravauxDetailPage extends StatefulWidget {
  final int id;
  const TravauxDetailPage({super.key, required this.id});

  @override
  State<TravauxDetailPage> createState() => _TravauxDetailPageState();
}

class _TravauxDetailPageState extends State<TravauxDetailPage> {
  TravauxDetail? _detail;
  bool _loading = true;
  String? _error;
  bool _actionLoading = false;

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
      final d = await DemandesService().getTravauxDetail(widget.id);
      if (mounted) {
        setState(() {
          _detail = d;
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

  Future<void> _createDevis() async {
    await Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (c, a, s) => CreateDevisPage(requestId: widget.id),
      transitionsBuilder: (c, anim, s, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 300),
    ));
    _load();
  }

  Future<void> _start() async {
    setState(() => _actionLoading = true);
    try {
      await DemandesService().startTravail(widget.id);
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  Future<void> _goToEnCours() async {
    final d = _detail!;
    await Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (c, a, s) =>
          TravauxEnCoursPage(id: widget.id, title: d.title),
      transitionsBuilder: (c, anim, s, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 300),
    ));
    _load();
  }

  String _formatDate(DateTime d) {
    const months = [
      '',
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Jun',
      'Jul',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc'
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month]} ${d.year}';
  }

  Color _badgeBg(String status) {
    switch (status) {
      case 'PENDING':
        return AppColors.warning10;
      case 'QUOTE_VALIDATED':
        return AppColors.info10;
      case 'STARTED':
        return AppColors.purple10;
      case 'FINISHED':
        return AppColors.amber10;
      case 'FINAL_VALIDATION':
        return AppColors.success10;
      case 'CANCELLED':
        return AppColors.error10;
      default:
        return AppColors.primary10;
    }
  }

  Color _badgeText(String status) {
    switch (status) {
      case 'PENDING':
        return AppColors.warning;
      case 'QUOTE_VALIDATED':
        return AppColors.info;
      case 'STARTED':
        return AppColors.purple;
      case 'FINISHED':
        return AppColors.orangeDark;
      case 'FINAL_VALIDATION':
        return AppColors.success;
      case 'CANCELLED':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  Color _statusIconBg(String status) {
    switch (status) {
      case 'PENDING':
        return AppColors.warning;
      case 'QUOTE_VALIDATED':
        return AppColors.info;
      case 'STARTED':
        return AppColors.purple;
      case 'FINISHED':
        return AppColors.orangeDark;
      case 'FINAL_VALIDATION':
        return AppColors.success;
      case 'CANCELLED':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  String _statusIcon(String status) {
    switch (status) {
      case 'PENDING':
        return 'assets/icons/En attente.svg';
      case 'QUOTE_VALIDATED':
        return 'assets/icons/donew.svg';
      case 'STARTED':
        return 'assets/icons/En cours.svg';
      case 'FINISHED':
      case 'FINAL_VALIDATION':
        return 'assets/icons/Valide.svg';
      case 'CANCELLED':
      default:
        return 'assets/icons/En attente.svg';
    }
  }

  Widget _cancelButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 350,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        child: Center(
          child: Text(
            'Annuler',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              height: 24 / 18,
              letterSpacing: -0.31,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }
    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.red),
              ),
              const SizedBox(height: 16),
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
        ),
      );
    }

    final d = _detail!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SubpageHeader(
              title: d.residenceName,
              subtitle: 'Détail du travail',
            ),
            const SizedBox(height: 16),

            // Carte info principale
            Container(
              width: 370,
              padding: const EdgeInsets.all(16.5),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.white, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _statusIconBg(d.status),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.black10,
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              spreadRadius: -1,
                            ),
                            BoxShadow(
                              color: AppColors.black10,
                              offset: Offset(0, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            _statusIcon(d.status),
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              d.title,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                height: 20 / 14,
                                letterSpacing: -0.15,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _badgeBg(d.status),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                d.statusLabel,
                                style: GoogleFonts.beVietnamPro(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  height: 1.0,
                                  color: _badgeText(d.status),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    d.description,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 22.75 / 14,
                      letterSpacing: -0.15,
                      color: AppColors.grey600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 28.5,
                    padding: const EdgeInsets.only(top: 12),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.grey100, width: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/calendar.svg',
                          width: 14,
                          height: 14,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(d.createdAt),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            height: 16 / 12,
                            color: AppColors.greySlate,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Photos
            if (d.photoUrls.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: 370,
                padding: const EdgeInsets.all(16.5),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.white, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Photos du problème',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 20 / 14,
                        letterSpacing: -0.15,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: d.photoUrls
                          .map((url) => ProblemPhotoTile(url: url))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],

            // Workflow
            if (d.workflowSteps.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: 370,
                padding: const EdgeInsets.all(16.5),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.white, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Workflow',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 20 / 14,
                        letterSpacing: -0.15,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...() {
                      final currentIndex =
                          d.workflowSteps.indexWhere((s) => !s.completed);
                      return d.workflowSteps.asMap().entries.map((entry) {
                        final i = entry.key;
                        final isLast = i == d.workflowSteps.length - 1;
                        final nextCompleted = isLast
                            ? false
                            : d.workflowSteps[i + 1].completed;
                        final isCurrent = i == currentIndex;
                        return Padding(
                          padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
                          child: WorkflowStepTile(
                            step: entry.value,
                            isLast: isLast,
                            nextCompleted: nextCompleted,
                            isCurrent: isCurrent,
                          ),
                        );
                      });
                    }(),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Boutons action
            if (d.status == 'PENDING') ...[
              DemandeActionButton(
                icon: 'assets/icons/donew.svg',
                label: 'Créer un devis',
                onTap: _createDevis,
              ),
              const SizedBox(height: 12),
              _cancelButton(),
            ] else if (d.status == 'QUOTE_VALIDATED') ...[
              DemandeActionButton(
                icon: 'assets/icons/En cours.svg',
                label: 'Démarrer',
                isLoading: _actionLoading,
                onTap: _start,
              ),
              const SizedBox(height: 12),
              _cancelButton(),
            ] else if (d.status == 'STARTED') ...[
              DemandeActionButton(
                icon: 'assets/icons/En cours.svg',
                label: 'Intervention en cours',
                onTap: _goToEnCours,
              ),
              const SizedBox(height: 12),
              _cancelButton(),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
