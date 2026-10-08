import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/core/widgets/subpage_header.dart';
import '../widgets/file_upload_box.dart';
import '../widgets/upload_format_chip.dart';
import 'devis_success.dart';

class UploadDevisPage extends StatefulWidget {
  final int requestId;
  const UploadDevisPage({super.key, required this.requestId});

  @override
  State<UploadDevisPage> createState() => _UploadDevisPageState();
}

class _UploadDevisPageState extends State<UploadDevisPage> {
  PlatformFile? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SubpageHeader(
              title: 'Téléverser un devis',
              subtitle: 'Demande #${widget.requestId}',
            ),
            const SizedBox(height: 20),
            FileUploadBox(
              selectedFile: _selectedFile,
              onFilePicked: (file) => setState(() => _selectedFile = file),
            ),
            const SizedBox(height: 16),
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
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      UploadFormatChip(icon: 'assets/icons/file1.svg', label: 'PDF'),
                      SizedBox(width: 16),
                      UploadFormatChip(icon: 'assets/icons/png.svg', label: 'JPG, PNG'),
                      SizedBox(width: 16),
                      UploadFormatChip(icon: 'assets/icons/word1.svg', label: 'Word'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 350,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warningBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warning, width: 1),
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
                        color: AppColors.warning,
                      ),
                    ),
                    TextSpan(
                      text: ' : Assurez-vous que votre devis est lisible et contient toutes les informations nécessaires (matériel, prix, délais).',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 22 / 14,
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: _selectedFile == null
                  ? null
                  : () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (c, a, s) => const DevisSuccessPage(),
                          transitionsBuilder: (c, anim, s, child) =>
                              FadeTransition(
                            opacity: CurvedAnimation(
                              parent: anim,
                              curve: Curves.easeOut,
                            ),
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
                      ? AppColors.warning.withValues(alpha: 0.4)
                      : AppColors.warning,
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
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 350,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.primary, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/brouillon.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
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
                          color: AppColors.primary,
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
