import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/demandes_models.dart';
import '../../services/demandes_service.dart';
import 'create_devis.dart';
import 'demande_en_cours.dart';
import 'upload_devis.dart';

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
    setState(() { _loading = true; _error = null; });
    try {
      final data = await DemandesService().getRequestById(widget.requestId);
      if (mounted) { setState(() { _data = data; _loading = false; }); }
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
        transitionsBuilder: (c, anim, s, child) =>
            FadeTransition(opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ));
      if (refresh == true && mounted) _load();
    } catch (e) {
      if (mounted) {
        setState(() => _actionLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', '')), backgroundColor: Colors.red),
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
      transitionsBuilder: (c, anim, s, child) =>
          FadeTransition(opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
      transitionDuration: const Duration(milliseconds: 300),
    ));
    if (refresh == true && mounted) _load();
  }

  String _formatDate(DateTime d) {
    const months = ['', 'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month]} ${d.year}';
  }

  String _formatDateTime(DateTime d) {
    const months = ['', 'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    return '${d.day} ${months[d.month]} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  Color _badgeBg(String status) {
    switch (status) {
      case 'PENDING':
      case 'SYNDIC_ASSIGNED':
      case 'PENDING_QUOTE':   return const Color(0x1AF9C20A);
      case 'QUOTE_SENT':      return const Color(0x1A1447E6);
      case 'SYNDIC_VALIDATED':
      case 'STARTED':          return const Color(0x1AAD46FF);
      case 'FINISHED':         return const Color(0x1AFE9A00);
      case 'FINAL_VALIDATION': return const Color(0x1A0A9748);
      case 'CANCELLED':        return const Color(0x1AFD3C4A);
      default:                 return const Color(0x1A6F675E);
    }
  }

  Color _statusIconBg(String status) {
    switch (status) {
      case 'PENDING':
      case 'SYNDIC_ASSIGNED':
      case 'PENDING_QUOTE':   return const Color(0xFFF9C20A);
      case 'QUOTE_SENT':      return const Color(0xFF1447E6);
      case 'SYNDIC_VALIDATED':
      case 'STARTED':          return const Color(0xFFAD46FF);
      case 'FINISHED':         return const Color(0xFFC37600);
      case 'FINAL_VALIDATION': return const Color(0xFF0A9748);
      case 'CANCELLED':        return const Color(0xFFFD3C4A);
      default:                 return const Color(0xFF6F675E);
    }
  }

  String _statusIcon(String status) {
    switch (status) {
      case 'PENDING':
      case 'SYNDIC_ASSIGNED':
      case 'PENDING_QUOTE':   return 'assets/icons/En attente.svg';
      case 'QUOTE_SENT':      return 'assets/icons/donew.svg';
      case 'SYNDIC_VALIDATED':
      case 'STARTED':          return 'assets/icons/En cours.svg';
      case 'FINISHED':         return 'assets/icons/Valide.svg';
      case 'FINAL_VALIDATION': return 'assets/icons/Valide.svg';
      case 'CANCELLED':        return 'assets/icons/En attente.svg';
      default:                 return 'assets/icons/En attente.svg';
    }
  }

  Color _badgeText(String status) {
    switch (status) {
      case 'PENDING':
      case 'SYNDIC_ASSIGNED':
      case 'PENDING_QUOTE':   return const Color(0xFFF9C20A);
      case 'QUOTE_SENT':      return const Color(0xFF1447E6);
      case 'SYNDIC_VALIDATED':
      case 'STARTED':          return const Color(0xFFAD46FF);
      case 'FINISHED':         return const Color(0xFFC37600);
      case 'FINAL_VALIDATION': return const Color(0xFF0A9748);
      case 'CANCELLED':        return const Color(0xFFFD3C4A);
      default:                 return const Color(0xFF6F675E);
    }
  }

  Widget _buildWorkflowStep(WorkflowStep step, {required bool isLast, required bool nextCompleted, required bool isCurrent}) {
    Color circleBg;
    Widget circleChild;

    if (step.completed) {
      circleBg = const Color(0xFF0A9748);
      circleChild = Center(child: SvgPicture.asset('assets/icons/donew.svg', width: 16, height: 16));
    } else if (isCurrent) {
      circleBg = const Color(0xFF2D2520);
      circleChild = Center(child: SvgPicture.asset('assets/icons/En attente.svg', width: 16, height: 16));
    } else {
      circleBg = const Color(0xFFE5E7EB);
      circleChild = const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(color: circleBg, shape: BoxShape.circle),
              child: circleChild,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 24,
                color: nextCompleted ? const Color(0xFF0A9748) : const Color(0xFFE5E7EB),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.label,
                style: GoogleFonts.inter(
                  fontWeight: step.completed ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 14,
                  height: 20 / 14,
                  color: step.completed ? const Color(0xFF2D2520) : const Color(0xFF9CA3AF),
                ),
              ),
              if (step.completed && step.date != null)
                Text(
                  _formatDateTime(step.date!),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 16 / 12,
                    color: const Color(0xFF6A7282),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionButton({required String icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: _actionLoading ? null : onTap,
      child: Container(
        width: 350, height: 56,
        decoration: BoxDecoration(color: const Color(0xFFF9C20A), borderRadius: BorderRadius.circular(15)),
        child: _actionLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(icon, width: 20, height: 20),
                  const SizedBox(width: 8),
                  Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 18, height: 24 / 18, letterSpacing: -0.31, color: const Color(0xFFFFFFFF))),
                ],
              ),
      ),
    );
  }

  Widget _cancelButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 350, height: 56,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFF6F675E), width: 1)),
        child: Center(child: Text('Annuler', style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 18, height: 24 / 18, letterSpacing: -0.31, color: const Color(0xFF6F675E)))),
      ),
    );
  }

  void _showDevisBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        int selectedCard = 0;
        return StatefulBuilder(
          builder: (ctx2, setModalState) => Container(
            width: 430,
            height: 454,
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0x80212121),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Créer un devis',
                              style: GoogleFonts.workSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                height: 32 / 24,
                                color: const Color(0xFF231F20),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(ctx).pop(),
                            child: SvgPicture.asset('assets/icons/close-rounded.svg', width: 24, height: 24),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Choisissez votre méthode de création',
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          height: 24 / 16,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
                  child: Column(
                    children: [
                      _devisCard(
                        ctx: ctx, ctx2: ctx2, setModalState: setModalState,
                        selectedCard: selectedCard, cardIndex: 1,
                        iconAsset: 'assets/icons/file.svg',
                        title: 'Créer un devis sur la plateforme',
                        subtitle: 'Utilisez notre formulaire intégré pour créer votre devis',
                        destination: CreateDevisPage(requestId: widget.requestId),
                      ),
                      const SizedBox(height: 20),
                      _devisCard(
                        ctx: ctx, ctx2: ctx2, setModalState: setModalState,
                        selectedCard: selectedCard, cardIndex: 2,
                        iconAsset: 'assets/icons/download.svg',
                        title: 'Téléverser un devis',
                        subtitle: 'Importez un devis existant (PDF, image ou Word)',
                        destination: UploadDevisPage(requestId: widget.requestId),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _devisCard({
    required BuildContext ctx,
    required BuildContext ctx2,
    required StateSetter setModalState,
    required int selectedCard,
    required int cardIndex,
    required String iconAsset,
    required String title,
    required String subtitle,
    required Widget destination,
  }) {
    final selected = selectedCard == cardIndex;
    return GestureDetector(
      onTap: () {
        setModalState(() => selectedCard = cardIndex);
        Future.delayed(const Duration(milliseconds: 300), () {
          if (ctx2.mounted) { Navigator.of(ctx2).pop(); }
          if (!mounted) return;
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (c, a, s) => destination,
            transitionsBuilder: (c, anim, s, child) =>
                FadeTransition(opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
            transitionDuration: const Duration(milliseconds: 300),
          ));
        });
      },
      child: Container(
        width: 382,
        height: 125,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: selected ? const Color(0x1AF9C20A) : const Color(0xFFFAF9F4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFFF9C20A) : const Color(0xFFFAF9F4),
            width: 2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFF9C20A) : const Color(0xFF6F675E),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(child: SvgPicture.asset(iconAsset, width: 28, height: 28)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14, height: 24 / 14, letterSpacing: -0.31, color: const Color(0xFF2D2520))),
                  const SizedBox(height: 2),
                  Text(subtitle, style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 12, height: 22.75 / 12, letterSpacing: -0.15, color: const Color(0xFF4A5565))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFAF9F4),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF6F675E))),
      );
    }
    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAF9F4),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _load,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6F675E)),
                child: const Text('Réessayer', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    final req = _data!;
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
                    top: 48, left: 24, right: 24,
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(req.residenceName, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 20, height: 32 / 20, letterSpacing: 0.07, color: const Color(0xFFFFFFFF))),
                              const SizedBox(height: 2),
                              Text('Consultez la demande',
                                style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFFFFFFFF))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Carte info principale
            Container(
              width: 370,
              padding: const EdgeInsets.all(16.5),
              decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFFFFFFF), width: 0.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: _statusIconBg(req.status), borderRadius: BorderRadius.circular(14),
                          boxShadow: const [BoxShadow(color: Color(0x1A000000), offset: Offset(0, 1), blurRadius: 2, spreadRadius: -1), BoxShadow(color: Color(0x1A000000), offset: Offset(0, 1), blurRadius: 3)]),
                        child: Center(child: SvgPicture.asset(_statusIcon(req.status), width: 20, height: 20)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(req.title, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFF2D2520))),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: _badgeBg(req.status), borderRadius: BorderRadius.circular(4)),
                              child: Text(req.statusLabel, style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600, fontSize: 12, height: 1.0, color: _badgeText(req.status))),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(req.description, style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, height: 22.75 / 14, letterSpacing: -0.15, color: const Color(0xFF4A5565))),
                  const SizedBox(height: 8),
                  Container(
                    height: 28.5,
                    padding: const EdgeInsets.only(top: 12),
                    decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFF3F4F6), width: 0.5))),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/calendar.svg', width: 14, height: 14),
                        const SizedBox(width: 8),
                        Text(_formatDate(req.createdAt), style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 12, height: 16 / 12, color: const Color(0xFF6A7282))),
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
                decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFFFFFFF), width: 0.5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Photos du problème', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFF2D2520))),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: req.photoUrls.map((url) => _PhotoTile(url: url)).toList(),
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
                decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFFFFFFF), width: 0.5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Workflow', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFF2D2520))),
                    const SizedBox(height: 16),
                    ...() {
                      // Trouve le 1er step non complété = step courant/actif
                      final currentIndex = req.workflowSteps.indexWhere((s) => !s.completed);
                      return req.workflowSteps.asMap().entries.map((entry) {
                        final i = entry.key;
                        final isLast = i == req.workflowSteps.length - 1;
                        final nextCompleted = isLast ? false : req.workflowSteps[i + 1].completed;
                        final isCurrent = i == currentIndex;
                        return Padding(
                          padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
                          child: _buildWorkflowStep(entry.value, isLast: isLast, nextCompleted: nextCompleted, isCurrent: isCurrent),
                        );
                      });
                    }(),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),
            if (req.status == 'PENDING' || req.status == 'SYNDIC_ASSIGNED' || req.status == 'PENDING_QUOTE') ...[
              _actionButton(
                icon: 'assets/icons/file.svg',
                label: 'Créer un devis',
                onTap: _showDevisBottomSheet,
              ),
              const SizedBox(height: 12),
              _cancelButton(),
            ] else if (req.status == 'SYNDIC_VALIDATED') ...[
              _actionButton(
                icon: 'assets/icons/En cours.svg',
                label: 'Démarrer',
                onTap: () => _demarrer(req),
              ),
              const SizedBox(height: 12),
              _cancelButton(),
            ] else if (req.status == 'STARTED') ...[
              _actionButton(
                icon: 'assets/icons/En cours.svg',
                label: 'Intervention en cours',
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

class _PhotoTile extends StatelessWidget {
  final String url;
  const _PhotoTile({required this.url});

  @override
  Widget build(BuildContext context) {
    debugPrint('[PhotoTile] building with url: $url');
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.network(url, fit: BoxFit.contain),
            ),
          ),
        ),
      )),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          url,
          width: 152,
          height: 112,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) => progress == null
              ? child
              : Container(
                  width: 152, height: 112, color: const Color(0xFFE5E7EB),
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF6F675E))),
                ),
          errorBuilder: (_, err, ___) {
            debugPrint('[PhotoTile] ERREUR chargement image: $url');
            debugPrint('[PhotoTile] erreur détail: $err');
            return Container(
              width: 152, height: 112, color: const Color(0xFFE5E7EB),
              child: const Icon(Icons.broken_image, color: Color(0xFF9CA3AF)),
            );
          },
        ),
      ),
    );
  }
}
