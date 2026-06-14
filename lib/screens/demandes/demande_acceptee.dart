import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'demande_en_cours.dart';

class DemandeAccepteePage extends StatelessWidget {
  const DemandeAccepteePage({super.key});

  Widget _workflowStep({
    required String label,
    String? date,
    required bool done,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: done ? const Color(0xFF0A9748) : const Color(0xFFE5E7EB),
                shape: BoxShape.circle,
              ),
              child: done
                  ? Center(
                      child: SvgPicture.asset(
                        'assets/icons/donew.svg',
                        width: 16,
                        height: 16,
                      ),
                    )
                  : null,
            ),
            if (!isLast)
              Container(width: 2, height: 24, color: done ? const Color(0xFF0A9748) : const Color(0xFFE5E7EB)),
          ],
        ),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: done ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 14,
                  height: 20 / 14,
                  color: done ? const Color(0xFF2D2520) : const Color(0xFF9CA3AF),
                ),
              ),
              if (date != null)
                Text(
                  date,
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
                              'Résidence Diana',
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

            // Card 1 — Infos demande
            Container(
              width: 370,
              padding: const EdgeInsets.fromLTRB(16.5, 16.5, 16.5, 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(15),
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
                          color: const Color(0xFF1447E6),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(color: Color(0x1A000000), offset: Offset(0, 1), blurRadius: 2, spreadRadius: -1),
                            BoxShadow(color: Color(0x1A000000), offset: Offset(0, 1), blurRadius: 3),
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset('assets/icons/donew.svg', width: 20, height: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Fuite d\'eau salle de bain',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              height: 20 / 14,
                              letterSpacing: -0.15,
                              color: const Color(0xFF2D2520),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0x1A1447E6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Accepté',
                              style: GoogleFonts.beVietnamPro(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                height: 1.0,
                                color: const Color(0xFF1447E6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Fuite importante sous le lavabo de la salle de bain principale. L\'eau s\'écoule continuellement et le résident a dû fermer l\'arrivée d\'eau.',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 22.75 / 14,
                      letterSpacing: -0.15,
                      color: const Color(0xFF4A5565),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 12),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Color(0xFFF3F4F6), width: 0.5)),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/calendar.svg', width: 14, height: 14),
                        const SizedBox(width: 8),
                        Text(
                          '2026-05-12',
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
              ),
            ),

            const SizedBox(height: 12),

            // Card 2 — Photos du problème
            Container(
              width: 370,
              padding: const EdgeInsets.fromLTRB(16.5, 16.5, 16.5, 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(15),
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
                      color: const Color(0xFF2D2520),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset('assets/images/prob1.jpg', width: 152, height: 112, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset('assets/images/prob2.jpg', width: 152, height: 112, fit: BoxFit.cover),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Card 3 — Contact résident
            Container(
              width: 370,
              padding: const EdgeInsets.fromLTRB(16.5, 16.5, 16.5, 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact résident',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 20 / 14,
                      letterSpacing: -0.15,
                      color: const Color(0xFF2D2520),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset('assets/icons/telephone.svg', width: 16, height: 16),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Téléphone',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: const Color(0xFF99A1AF),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '+221 77 123 45 67',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: const Color(0xFF2D2520),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset('assets/icons/Email.svg', width: 16, height: 16),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: const Color(0xFF99A1AF),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'diop@email.com',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: const Color(0xFF2D2520),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Card 4 — Workflow
            Container(
              width: 370,
              padding: const EdgeInsets.fromLTRB(16.5, 16.5, 16.5, 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(15),
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
                      color: const Color(0xFF2D2520),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _workflowStep(label: 'Demande reçue', date: '12 Mai 09:30', done: true, isLast: false),
                  const SizedBox(height: 8),
                  _workflowStep(label: 'Devis envoyé', date: '15 Mai 11:30', done: true, isLast: false),
                  const SizedBox(height: 8),
                  _workflowStep(label: 'Validation syndic', done: false, isLast: false),
                  const SizedBox(height: 8),
                  _workflowStep(label: 'Intervention démarrée', done: false, isLast: false),
                  const SizedBox(height: 8),
                  _workflowStep(label: 'Travail terminé', done: false, isLast: false),
                  const SizedBox(height: 8),
                  _workflowStep(label: 'Validation finale', done: false, isLast: true),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bouton Démarrer
            GestureDetector(
              onTap: () => Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (c, a, s) => const DemandeEnCoursPage(requestId: 0, residenceName: ''),
                transitionsBuilder: (c, anim, s, child) => FadeTransition(
                  opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
                transitionDuration: const Duration(milliseconds: 300),
              )),
              child: Container(
              width: 350,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF9C20A),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/start.svg', width: 20, height: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Démarrer',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      height: 24 / 18,
                      letterSpacing: -0.31,
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ],
              ),
            ),
            ),

            const SizedBox(height: 12),

            // Bouton Annuler
            Container(
              width: 350,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF6F675E), width: 1),
              ),
              child: Center(
                child: Text(
                  'Annuler',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    height: 24 / 18,
                    letterSpacing: -0.31,
                    color: const Color(0xFF6F675E),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
