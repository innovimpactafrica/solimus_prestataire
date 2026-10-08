import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/core/widgets/subpage_header.dart';
import 'package:solimus_prestataire/features/demandes/data/services/demandes_service.dart';
import '../widgets/intervention_timer_card.dart';
import '../widgets/travaux_photos_picker.dart';
import '../widgets/travaux_comment_field.dart';

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
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SubpageHeader(
              title: widget.residenceName,
              subtitle: 'Consultez la demande',
              onBack: () => Navigator.of(context).pop(false),
            ),
            const SizedBox(height: 16),
            InterventionTimerCard(timerText: _timerText),
            const SizedBox(height: 16),
            TravauxPhotosPicker(
              photos: _photos,
              onTakePhoto: _prendreLaPhoto,
            ),
            const SizedBox(height: 16),
            TravauxCommentField(controller: _commentController),
            const SizedBox(height: 24),
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
