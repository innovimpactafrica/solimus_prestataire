import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class FileUploadBox extends StatelessWidget {
  final PlatformFile? selectedFile;
  final ValueChanged<PlatformFile?> onFilePicked;

  const FileUploadBox({
    super.key,
    required this.selectedFile,
    required this.onFilePicked,
  });

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes o';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} Ko';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} Mo';
  }

  @override
  Widget build(BuildContext context) {
    final fileName = selectedFile?.name;

    return SizedBox(
      width: 350,
      child: CustomPaint(
        painter: _DashedBorderPainter(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: selectedFile != null
                      ? AppColors.successLight
                      : AppColors.grey100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: selectedFile != null
                      ? const Icon(Icons.check_circle_rounded,
                          color: AppColors.greenEmerald, size: 32)
                      : SvgPicture.asset(
                          'assets/icons/download1.svg',
                          width: 32,
                          height: 32,
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                fileName ?? 'Glissez votre fichier ici',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  height: 24 / 16,
                  letterSpacing: -0.15,
                  color: AppColors.primaryDark,
                ),
              ),
              if (selectedFile != null) ...[
                const SizedBox(height: 4),
                Text(
                  _formatSize(selectedFile!.size),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: AppColors.greySlate,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 4),
                Text(
                  'ou cliquez pour parcourir',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 20 / 14,
                    letterSpacing: -0.15,
                    color: AppColors.greySlate,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  try {
                    final result = await FilePicker.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
                    );
                    if (result != null && result.files.isNotEmpty) {
                      onFilePicked(result.files.first);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Impossible d\'ouvrir le sélecteur de fichiers'),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  width: 171,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Choisir un fichier',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 20 / 14,
                        letterSpacing: -0.15,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.grey300
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double dash = 6.0;
    const double gap = 5.0;
    const double r = 16.0;
    final double w = size.width;
    final double h = size.height;

    void drawDashed(Offset a, Offset b) {
      final dir = b - a;
      final len = dir.distance;
      final unit = dir / len;
      double pos = 0;
      bool on = true;
      while (pos < len) {
        final seg = (on ? dash : gap).clamp(0.0, len - pos);
        if (on) canvas.drawLine(a + unit * pos, a + unit * (pos + seg), paint);
        pos += seg;
        on = !on;
      }
    }

    drawDashed(Offset(r, 0), Offset(w - r, 0));
    drawDashed(Offset(w, r), Offset(w, h - r));
    drawDashed(Offset(w - r, h), Offset(r, h));
    drawDashed(Offset(0, h - r), Offset(0, r));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
