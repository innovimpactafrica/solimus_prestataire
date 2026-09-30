import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'devis_success.dart';

class UploadDevisPage extends StatefulWidget {
  final int requestId;
  const UploadDevisPage({super.key, required this.requestId});

  @override
  State<UploadDevisPage> createState() => _UploadDevisPageState();
}

class _UploadDevisPageState extends State<UploadDevisPage> {
  PlatformFile? _selectedFile;
  String? get _selectedFileName => _selectedFile?.name;

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes o';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} Ko';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} Mo';
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
                  Container(
                    width: double.infinity,
                    height: 135,
                    color: const Color(0xFF6F675E),
                  ),
                  Container(
                    width: double.infinity,
                    height: 135,
                    color: const Color(0x66000000),
                  ),
                  Positioned(
                    top: 48,
                    left: 24,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
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
                              'Téléverser un devis',
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
                              'Demande #${widget.requestId}',
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

            const SizedBox(height: 20),

            // Zone de téléversement
            SizedBox(
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
                          color: _selectedFile != null
                              ? const Color(0xFFDCFCE7)
                              : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: _selectedFile != null
                              ? const Icon(Icons.check_circle_rounded,
                                  color: Color(0xFF00A63E), size: 32)
                              : SvgPicture.asset(
                                  'assets/icons/download1.svg',
                                  width: 32,
                                  height: 32,
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _selectedFileName ?? 'Glissez votre fichier ici',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          height: 24 / 16,
                          letterSpacing: -0.15,
                          color: const Color(0xFF2D2520),
                        ),
                      ),
                      if (_selectedFile != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _formatSize(_selectedFile!.size),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: const Color(0xFF6A7282),
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
                            color: const Color(0xFF6A7282),
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
                              setState(() => _selectedFile = result.files.first);
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Impossible d\'ouvrir le sélecteur de fichiers')),
                              );
                            }
                          }
                        },
                        child: Container(
                          width: 171,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6F675E),
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
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Formats acceptés
            Container(
              width: 350,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Formats acceptés',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      height: 20 / 14,
                      letterSpacing: -0.15,
                      color: const Color(0xFF2D2520),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _FormatChip(icon: 'assets/icons/file1.svg', label: 'PDF'),
                      const SizedBox(width: 16),
                      _FormatChip(icon: 'assets/icons/png.svg', label: 'JPG, PNG'),
                      const SizedBox(width: 16),
                      _FormatChip(icon: 'assets/icons/word1.svg', label: 'Word'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Astuce
            Container(
              width: 350,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF9C20A), width: 1),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(text: '💡 '),
                    TextSpan(
                      text: 'Astuce',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 22 / 14,
                        color: const Color(0xFFF9C20A),
                      ),
                    ),
                    TextSpan(
                      text: ' : Assurez-vous que votre devis est lisible et contient toutes les informations nécessaires (matériel, prix, délais).',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 22 / 14,
                        color: const Color(0xFF4A5565),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Bouton Enregistrer
            GestureDetector(
              onTap: _selectedFile == null ? null : () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (c, a, s) => const DevisSuccessPage(),
                    transitionsBuilder: (c, anim, s, child) => FadeTransition(
                      opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
                      child: child,
                    ),
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                );
              },
              child: Container(
                width: 350,
                height: 56,
                decoration: BoxDecoration(
                  color: _selectedFile == null
                      ? const Color(0xFFF9C20A).withValues(alpha: 0.4)
                      : const Color(0xFFF9C20A),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/save.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 24,
                      child: Text(
                        'Enregistrer',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          height: 24 / 18,
                          letterSpacing: -0.31,
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Bouton Brouillon
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 350,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFF6F675E), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/brouillon.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF6F675E),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 24,
                      child: Text(
                        'Brouillon',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          height: 24 / 18,
                          letterSpacing: -0.31,
                          color: const Color(0xFF6F675E),
                        ),
                      ),
                    ),
                  ],
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

class _FormatChip extends StatelessWidget {
  final String icon;
  final String label;

  const _FormatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(icon, width: 18, height: 18),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            height: 20 / 13,
            letterSpacing: -0.1,
            color: const Color(0xFF4A5565),
          ),
        ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD1D5DB)
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
