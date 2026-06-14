import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/demandes_service.dart';

class DemandeEnCoursPage extends StatefulWidget {
  final int requestId;
  final String residenceName;

  const DemandeEnCoursPage({
    super.key,
    required this.requestId,
    required this.residenceName,
  });

  @override
  State<DemandeEnCoursPage> createState() => _DemandeEnCoursPageState();
}

class _DemandeEnCoursPageState extends State<DemandeEnCoursPage> {
  int _seconds = 0;
  late Timer _timer;
  final _commentController = TextEditingController();
  final List<XFile> _photos = [];
  final _picker = ImagePicker();
  bool _terminerLoading = false;
  bool _pickingPhoto = false;

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
      try {
        await DemandesService().uploadWorkPhoto(widget.requestId, photo);
      } catch (e) {
        if (mounted) {
          setState(() => _photos.remove(photo));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceFirst('Exception: ', '')),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _pickingPhoto = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _commentController.dispose();
    super.dispose();
  }

  String get _timerText {
    final mins = (_seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  Future<void> _terminer() async {
    setState(() => _terminerLoading = true);
    try {
      final comment = _commentController.text.trim();
      if (comment.isNotEmpty) {
        await DemandesService().addComment(widget.requestId, comment);
      }
      await DemandesService().finishRequest(widget.requestId);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
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
                          onTap: () => Navigator.of(context).pop(false),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0x33FFFFFF),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icons/fleche gauche.svg',
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.residenceName,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                height: 32 / 20,
                                letterSpacing: 0.07,
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Consultez la demande',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 20 / 14,
                                letterSpacing: -0.15,
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Container En cours + timer
            Container(
              width: 365,
              height: 67,
              padding: const EdgeInsets.fromLTRB(21.5, 21.5, 21.5, 1.51),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFB9F8CF), width: 1.51),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00C950),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'En cours',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 20 / 14,
                          letterSpacing: -0.15,
                          color: const Color(0xFF0D542B),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _timerText,
                    style: const TextStyle(
                      fontFamily: 'Menlo',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      height: 28 / 20,
                      letterSpacing: 0,
                      color: Color(0xFF0D542B),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Card Photos des travaux
            Container(
              width: 365,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Photos des travaux',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 20 / 14,
                      letterSpacing: -0.15,
                      color: const Color(0xFF2D2520),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _prendreLaPhoto,
                    child: Container(
                      width: 352,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6F675E),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/photo.svg', width: 20, height: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Prendre la photo',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              height: 24 / 16,
                              letterSpacing: -0.31,
                              color: const Color(0xFFFFFFFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_photos.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _photos.map((photo) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(File(photo.path), width: 100, height: 100, fit: BoxFit.cover),
                      )).toList(),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Card Commentaires
            Container(
              width: 365,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Commentaires',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 20 / 14,
                      letterSpacing: -0.15,
                      color: const Color(0xFF2D2520),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _commentController,
                      maxLines: 5,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: const Color(0xFF2D2520),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ajoutez des notes sur l\'intervention...',
                        hintStyle: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: const Color(0xFF9EA8B3),
                        ),
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
                width: 350,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9C20A),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: _terminerLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : Center(
                        child: Text(
                          'Terminer',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            height: 24 / 18,
                            letterSpacing: -0.31,
                            color: const Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
