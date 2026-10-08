import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/features/demandes/data/models/demandes_models.dart';
import 'package:solimus_prestataire/features/demandes/data/services/demandes_service.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/core/widgets/subpage_header.dart';
import 'create_devis.dart';
import 'demande_en_cours.dart';
import 'upload_devis.dart';
import '../widgets/workflow_step_tile.dart';
import '../widgets/problem_photo_tile.dart';
import '../widgets/demande_action_button.dart';
import '../widgets/devis_method_bottom_sheet.dart';

class DemandeDetailsPage extends StatefulWidget {
  final int requestId;

  const DemandeDetailsPage({super.key, required this.requestId});

  @override
  State<DemandeDetailsPage> createState() => _DemandeDetailsPageState();
}

class _DemandeDetailsPageState extends State<DemandeDetailsPage> {
  DemandeRequest? _data;
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
      final data = await DemandesService().getRequestById(widget.requestId);
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

  Future<void> _demarrer(DemandeRequest req) async {
    if (_actionLoading) return;
    setState(() => _actionLoading = true);
    try {
      await DemandesService().startRequest(widget.requestId);
      if (!mounted) return;
      setState(() => _actionLoading = false);
      final refresh = await Navigator.of(context).push<bool>(PageRouteBuilder(
        pageBuilder: (c, a, s) => DemandeEnCoursPage(
          requestId: widget.requestId,
          residenceName: req.residenceName,
        ),
        transitionsBuilder: (c, anim, s, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ));
      if (refresh == true && mounted) _load();
    } catch (e) {
      if (mounted) {
        setState(() => _actionLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _reprendreEnCours(DemandeRequest req) async {
    final refresh = await Navigator.of(context).push<bool>(PageRouteBuilder(
      pageBuilder: (c, a, s) => DemandeEnCoursPage(
        requestId: widget.requestId,
        residenceName: req.residenceName,
      ),
      transitionsBuilder: (c, anim, s, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 300),
    ));
    if (refresh == true && mounted) _load();
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
      case 'SYNDIC_ASSIGNED':
      case 'PENDING_QUOTE':
        return AppColors.warning10;
      case 'QUOTE_SENT':
        return AppColors.info10;
      case 'SYNDIC_VALIDATED':
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

  Color _statusIconBg(String status) {
    switch (status) {
      case 'PENDING':
      case 'SYNDIC_ASSIGNED':
      case 'PENDING_QUOTE':
        return AppColors.warning;
      case 'QUOTE_SENT':
        return AppColors.info;
      case 'SYNDIC_VALIDATED':
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
      case 'SYNDIC_ASSIGNED':
      case 'PENDING_QUOTE':
        return 'assets/icons/En attente.svg';
      case 'QUOTE_SENT':
        return 'assets/icons/donew.svg';
      case 'SYNDIC_VALIDATED':
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

  Color _badgeText(String status) {
    switch (status) {
      case 'PENDING':
      case 'SYNDIC_ASSIGNED':
      case 'PENDING_QUOTE':
        return AppColors.warning;
      case 'QUOTE_SENT':
        return AppColors.info;
      case 'SYNDIC_VALIDATED':
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

  void _showDevisBottomSheet() {
    DevisMethodBottomSheet.show(
      context: context,
      onPlatformDevis: () {
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (c, a, s) => CreateDevisPage(requestId: widget.requestId),
          transitionsBuilder: (c, anim, s, child) => FadeTransition(
            opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 300),
        ));
      },
      onUploadDevis: () {
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (c, a, s) => UploadDevisPage(requestId: widget.requestId),
          transitionsBuilder: (c, anim, s, child) => FadeTransition(
            opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 300),
        ));
      },
    );
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

    final req = _data!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SubpageHeader(
              title: req.residenceName,
              subtitle: 'Consultez la demande',
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
                          color: _statusIconBg(req.status),
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
                            _statusIcon(req.status),
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
                              req.title,
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
                                color: _badgeBg(req.status),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                req.statusLabel,
                                style: GoogleFonts.beVietnamPro(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  height: 1.0,
                                  color: _badgeText(req.status),
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
                    req.description,
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
                          _formatDate(req.createdAt),
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

            // Photos du problème
            if (req.photoUrls.isNotEmpty) ...[
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
                      children: req.photoUrls
                          .map((url) => ProblemPhotoTile(url: url))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],

            // Workflow
            if (req.workflowSteps.isNotEmpty) ...[
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
                          req.workflowSteps.indexWhere((s) => !s.completed);
                      return req.workflowSteps.asMap().entries.map((entry) {
                        final i = entry.key;
                        final isLast = i == req.workflowSteps.length - 1;
                        final nextCompleted = isLast
                            ? false
                            : req.workflowSteps[i + 1].completed;
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
            if (req.status == 'PENDING' ||
                req.status == 'SYNDIC_ASSIGNED' ||
                req.status == 'PENDING_QUOTE') ...[
              DemandeActionButton(
                icon: 'assets/icons/file.svg',
                label: 'Créer un devis',
                isLoading: _actionLoading,
                onTap: _showDevisBottomSheet,
              ),
              const SizedBox(height: 12),
              _cancelButton(),
            ] else if (req.status == 'SYNDIC_VALIDATED') ...[
              DemandeActionButton(
                icon: 'assets/icons/En cours.svg',
                label: 'Démarrer',
                isLoading: _actionLoading,
                onTap: () => _demarrer(req),
              ),
              const SizedBox(height: 12),
              _cancelButton(),
            ] else if (req.status == 'STARTED') ...[
              DemandeActionButton(
                icon: 'assets/icons/En cours.svg',
                label: 'Intervention en cours',
                isLoading: _actionLoading,
                onTap: () => _reprendreEnCours(req),
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
