import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/travaux_models.dart';
import '../../services/demandes_service.dart';
import '../demandes/create_devis.dart';

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
    setState(() { _loading = true; _error = null; });
    try {
      final d = await DemandesService().getTravauxDetail(widget.id);
      if (mounted) setState(() { _detail = d; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString().replaceFirst('Exception: ', ''); _loading = false; });
    }
  }

  Future<void> _createDevis() async {
    await Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (c, a, s) => CreateDevisPage(requestId: widget.id),
      transitionsBuilder: (c, anim, s, child) => FadeTransition(opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
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
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', '')), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  Future<void> _goToEnCours() async {
    final d = _detail!;
    await Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (c, a, s) => _TravauxEnCoursPage(id: widget.id, title: d.title),
      transitionsBuilder: (c, anim, s, child) => FadeTransition(opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
      transitionDuration: const Duration(milliseconds: 300),
    ));
    _load();
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
      case 'PENDING':          return const Color(0x1AF9C20A);
      case 'QUOTE_VALIDATED':  return const Color(0x1A1447E6);
      case 'STARTED':          return const Color(0x1AAD46FF);
      case 'FINISHED':         return const Color(0x1AFE9A00);
      case 'FINAL_VALIDATION': return const Color(0x1A0A9748);
      case 'CANCELLED':        return const Color(0x1AFD3C4A);
      default:                 return const Color(0x1A6F675E);
    }
  }

  Color _badgeText(String status) {
    switch (status) {
      case 'PENDING':          return const Color(0xFFF9C20A);
      case 'QUOTE_VALIDATED':  return const Color(0xFF1447E6);
      case 'STARTED':          return const Color(0xFFAD46FF);
      case 'FINISHED':         return const Color(0xFFC37600);
      case 'FINAL_VALIDATION': return const Color(0xFF0A9748);
      case 'CANCELLED':        return const Color(0xFFFD3C4A);
      default:                 return const Color(0xFF6F675E);
    }
  }

  Color _statusIconBg(String status) {
    switch (status) {
      case 'PENDING':          return const Color(0xFFF9C20A);
      case 'QUOTE_VALIDATED':  return const Color(0xFF1447E6);
      case 'STARTED':          return const Color(0xFFAD46FF);
      case 'FINISHED':         return const Color(0xFFC37600);
      case 'FINAL_VALIDATION': return const Color(0xFF0A9748);
      case 'CANCELLED':        return const Color(0xFFFD3C4A);
      default:                 return const Color(0xFF6F675E);
    }
  }

  String _statusIcon(String status) {
    switch (status) {
      case 'PENDING':          return 'assets/icons/En attente.svg';
      case 'QUOTE_VALIDATED':  return 'assets/icons/donew.svg';
      case 'STARTED':          return 'assets/icons/En cours.svg';
      case 'FINISHED':         return 'assets/icons/Valide.svg';
      case 'FINAL_VALIDATION': return 'assets/icons/Valide.svg';
      case 'CANCELLED':        return 'assets/icons/En attente.svg';
      default:                 return 'assets/icons/En attente.svg';
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
              width: 28, height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(color: circleBg, shape: BoxShape.circle),
              child: circleChild,
            ),
            if (!isLast) Container(width: 2, height: 24, color: nextCompleted ? const Color(0xFF0A9748) : const Color(0xFFE5E7EB)),
          ],
        ),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(step.label, style: GoogleFonts.inter(
                fontWeight: step.completed ? FontWeight.w600 : FontWeight.w400,
                fontSize: 14, height: 20 / 14,
                color: step.completed ? const Color(0xFF2D2520) : const Color(0xFF9CA3AF),
              )),
              if (step.completed && step.date != null)
                Text(_formatDateTime(step.date!), style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 12, height: 16 / 12, color: const Color(0xFF6A7282))),
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
        body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(_error!, textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _load, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6F675E)), child: const Text('Réessayer', style: TextStyle(color: Colors.white))),
        ])),
      );
    }

    final d = _detail!;
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
                              Text(d.residenceName, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 20, height: 32 / 20, letterSpacing: 0.07, color: const Color(0xFFFFFFFF))),
                              const SizedBox(height: 2),
                              Text('Détail du travail', style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFFFFFFFF))),
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
                        decoration: BoxDecoration(color: _statusIconBg(d.status), borderRadius: BorderRadius.circular(14),
                          boxShadow: const [BoxShadow(color: Color(0x1A000000), offset: Offset(0, 1), blurRadius: 2, spreadRadius: -1), BoxShadow(color: Color(0x1A000000), offset: Offset(0, 1), blurRadius: 3)]),
                        child: Center(child: SvgPicture.asset(_statusIcon(d.status), width: 20, height: 20)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(d.title, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFF2D2520))),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: _badgeBg(d.status), borderRadius: BorderRadius.circular(4)),
                              child: Text(d.statusLabel, style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600, fontSize: 12, height: 1.0, color: _badgeText(d.status))),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(d.description, style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, height: 22.75 / 14, letterSpacing: -0.15, color: const Color(0xFF4A5565))),
                  const SizedBox(height: 8),
                  Container(
                    height: 28.5,
                    padding: const EdgeInsets.only(top: 12),
                    decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFF3F4F6), width: 0.5))),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/calendar.svg', width: 14, height: 14),
                        const SizedBox(width: 8),
                        Text(_formatDate(d.createdAt), style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 12, height: 16 / 12, color: const Color(0xFF6A7282))),
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
                decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFFFFFFF), width: 0.5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Photos du problème', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFF2D2520))),
                    const SizedBox(height: 12),
                    Wrap(spacing: 8, runSpacing: 8, children: d.photoUrls.map((url) => _PhotoTile(url: url)).toList()),
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
                decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFFFFFFF), width: 0.5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Workflow', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFF2D2520))),
                    const SizedBox(height: 16),
                    ...() {
                      final currentIndex = d.workflowSteps.indexWhere((s) => !s.completed);
                      return d.workflowSteps.asMap().entries.map((entry) {
                        final i = entry.key;
                        final isLast = i == d.workflowSteps.length - 1;
                        final nextCompleted = isLast ? false : d.workflowSteps[i + 1].completed;
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

            // Boutons action
            if (d.status == 'PENDING') ...[
              _actionButton(icon: 'assets/icons/donew.svg', label: 'Créer un devis', onTap: _createDevis),
              const SizedBox(height: 12),
              _cancelButton(),
            ] else if (d.status == 'QUOTE_VALIDATED') ...[
              _actionButton(icon: 'assets/icons/En cours.svg', label: 'Démarrer', onTap: _start),
              const SizedBox(height: 12),
              _cancelButton(),
            ] else if (d.status == 'STARTED') ...[
              _actionButton(icon: 'assets/icons/En cours.svg', label: 'Intervention en cours', onTap: _goToEnCours),
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
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black, leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.of(ctx).pop())),
          body: Center(child: InteractiveViewer(child: Image.network(url, fit: BoxFit.contain))),
        ),
      )),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(url, width: 152, height: 112, fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) => progress == null ? child : Container(width: 152, height: 112, color: const Color(0xFFE5E7EB), child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF6F675E)))),
          errorBuilder: (_, __, ___) => Container(width: 152, height: 112, color: const Color(0xFFE5E7EB), child: const Icon(Icons.broken_image, color: Color(0xFF9CA3AF))),
        ),
      ),
    );
  }
}

// Page "en cours" pour les travaux STARTED
class _TravauxEnCoursPage extends StatefulWidget {
  final int id;
  final String title;
  const _TravauxEnCoursPage({required this.id, required this.title});

  @override
  State<_TravauxEnCoursPage> createState() => _TravauxEnCoursPageState();
}

class _TravauxEnCoursPageState extends State<_TravauxEnCoursPage> {
  final _commentController = TextEditingController();
  final List<XFile> _photos = [];
  final _picker = ImagePicker();
  bool _terminerLoading = false;
  bool _pickingPhoto = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _prendreLaPhoto() async {
    if (_pickingPhoto) return;
    setState(() => _pickingPhoto = true);
    try {
      XFile? photo;
      try {
        photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
      } catch (_) {
        photo = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      }
      if (photo == null) return;
      setState(() => _photos.add(photo!));
    } finally {
      if (mounted) setState(() => _pickingPhoto = false);
    }
  }

  Future<void> _terminer() async {
    setState(() => _terminerLoading = true);
    try {
      await DemandesService().finishTravail(
        widget.id,
        commentaire: _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
        photos: _photos.isEmpty ? null : _photos,
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', '')), backgroundColor: Colors.red));
        setState(() => _terminerLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F4),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 135,
              child: Stack(
                children: [
                  Container(width: double.infinity, height: 135, color: const Color(0xFF6F675E)),
                  Container(width: double.infinity, height: 135, color: const Color(0x66000000)),
                  Positioned(
                    top: 48, left: 24,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(false),
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
                            Text(widget.title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 20, height: 32 / 20, letterSpacing: 0.07, color: const Color(0xFFFFFFFF))),
                            const SizedBox(height: 2),
                            Text('Intervention en cours', style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFFFFFFFF))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Card Photos
            Container(
              width: 365,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Photos des travaux', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFF2D2520))),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _prendreLaPhoto,
                    child: Container(
                      width: 352, height: 56,
                      decoration: BoxDecoration(color: const Color(0xFF6F675E), borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/photo.svg', width: 20, height: 20),
                          const SizedBox(width: 8),
                          Text('Prendre la photo', style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 16, height: 24 / 16, letterSpacing: -0.31, color: const Color(0xFFFFFFFF))),
                        ],
                      ),
                    ),
                  ),
                  if (_photos.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(spacing: 8, runSpacing: 8, children: _photos.map((p) => ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(File(p.path), width: 100, height: 100, fit: BoxFit.cover))).toList()),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Card Commentaires
            Container(
              width: 365,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Commentaires', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFF2D2520))),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: _commentController,
                      maxLines: 5,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, color: const Color(0xFF2D2520)),
                      decoration: InputDecoration(
                        hintText: 'Ajoutez des notes sur l\'intervention...',
                        hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, color: const Color(0xFF9EA8B3)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bouton Terminer
            GestureDetector(
              onTap: _terminerLoading ? null : _terminer,
              child: Container(
                width: 350, height: 56,
                decoration: BoxDecoration(color: const Color(0xFFF9C20A), borderRadius: BorderRadius.circular(15)),
                child: _terminerLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : Center(child: Text('Terminer', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 18, height: 24 / 18, letterSpacing: -0.31, color: const Color(0xFFFFFFFF)))),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
