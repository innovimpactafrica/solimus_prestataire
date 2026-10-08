import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/core/widgets/subpage_header.dart';
import 'package:solimus_prestataire/features/demandes/data/services/demandes_service.dart';

class TravauxEnCoursPage extends StatefulWidget {
  final int id;
  final String title;

  const TravauxEnCoursPage({
    super.key,
    required this.id,
    required this.title,
  });

  @override
  State<TravauxEnCoursPage> createState() => _TravauxEnCoursPageState();
}

class _TravauxEnCoursPageState extends State<TravauxEnCoursPage> {
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
        photo = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );
      } catch (_) {
        photo = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );
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
        commentaire: _commentController.text.trim().isEmpty
            ? null
            : _commentController.text.trim(),
        photos: _photos.isEmpty ? null : _photos,
      );
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
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SubpageHeader(
              title: widget.title,
              subtitle: 'Intervention en cours',
            ),
            const SizedBox(height: 16),

            // Card Photos
            Container(
              width: 365,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
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
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _prendreLaPhoto,
                    child: Container(
                      width: 352,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/photo.svg',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Prendre la photo',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              height: 24 / 16,
                              letterSpacing: -0.31,
                              color: AppColors.white,
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
                      children: _photos
                          .map(
                            (p) => ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(p.path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                          .toList(),
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
                color: AppColors.white,
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
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _commentController,
                      maxLines: 5,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.primaryDark,
                      ),
                      decoration: InputDecoration(
                        hintText: "Ajoutez des notes sur l'intervention...",
                        hintStyle: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.textDisabled,
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
                  color: AppColors.warning,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: _terminerLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Center(
                        child: Text(
                          'Terminer',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            height: 24 / 18,
                            letterSpacing: -0.31,
                            color: AppColors.white,
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
