import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/core/widgets/subpage_header.dart';
import '../widgets/demande_action_button.dart';
import '../widgets/problem_photo_tile.dart';
import '../widgets/resident_contact_card.dart';
import '../widgets/workflow_step_tile.dart';
import 'demande_en_cours.dart';

class DemandeAccepteePage extends StatelessWidget {
  const DemandeAccepteePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SubpageHeader(
              title: 'Résidence Diana',
              subtitle: 'Consultez la demande',
            ),
            const SizedBox(height: 16),

            // Card 1 — Infos demande
            Container(
              width: 370,
              padding: const EdgeInsets.fromLTRB(16.5, 16.5, 16.5, 16),
              decoration: BoxDecoration(
                color: AppColors.white,
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
                          color: AppColors.info,
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
                            'assets/icons/donew.svg',
                            width: 20,
                            height: 20,
                          ),
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
                              color: AppColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.info10,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Accepté',
                              style: GoogleFonts.beVietnamPro(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                height: 1.0,
                                color: AppColors.info,
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
                      color: AppColors.grey600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
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
                          '2026-05-12',
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

            const SizedBox(height: 12),

            // Card 2 — Photos du problème
            Container(
              width: 370,
              padding: const EdgeInsets.fromLTRB(16.5, 16.5, 16.5, 16),
              decoration: BoxDecoration(
                color: AppColors.white,
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
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      ProblemPhotoTile(url: 'assets/images/prob1.jpg'),
                      SizedBox(width: 8),
                      ProblemPhotoTile(url: 'assets/images/prob2.jpg'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Card 3 — Contact résident
            const ResidentContactCard(
              phone: '+221 77 123 45 67',
              email: 'diop@email.com',
            ),

            const SizedBox(height: 12),

            // Card 4 — Workflow
            Container(
              width: 370,
              padding: const EdgeInsets.fromLTRB(16.5, 16.5, 16.5, 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Workflow',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 20 / 14,
                      letterSpacing: -0.15,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  SizedBox(height: 16),
                  WorkflowStepTile(
                    label: 'Demande reçue',
                    dateString: '12 Mai 09:30',
                    completed: true,
                    isLast: false,
                  ),
                  SizedBox(height: 8),
                  WorkflowStepTile(
                    label: 'Devis envoyé',
                    dateString: '15 Mai 11:30',
                    completed: true,
                    isLast: false,
                  ),
                  SizedBox(height: 8),
                  WorkflowStepTile(
                    label: 'Validation syndic',
                    completed: false,
                    isLast: false,
                  ),
                  SizedBox(height: 8),
                  WorkflowStepTile(
                    label: 'Intervention démarrée',
                    completed: false,
                    isLast: false,
                  ),
                  SizedBox(height: 8),
                  WorkflowStepTile(
                    label: 'Travail terminé',
                    completed: false,
                    isLast: false,
                  ),
                  SizedBox(height: 8),
                  WorkflowStepTile(
                    label: 'Validation finale',
                    completed: false,
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bouton Démarrer
            DemandeActionButton(
              label: 'Démarrer',
              icon: 'assets/icons/start.svg',
              onTap: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (c, a, s) => const DemandeEnCoursPage(
                    requestId: 0,
                    residenceName: 'Résidence Diana',
                  ),
                  transitionsBuilder: (c, anim, s, child) => FadeTransition(
                    opacity: CurvedAnimation(
                      parent: anim,
                      curve: Curves.easeOut,
                    ),
                    child: child,
                  ),
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Bouton Annuler
            GestureDetector(
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
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
