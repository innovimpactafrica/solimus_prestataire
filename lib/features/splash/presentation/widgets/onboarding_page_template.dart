import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'onboarding_dots.dart';

class OnboardingPageTemplate extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final int activeIndex;
  final String buttonText;
  final VoidCallback onNext;

  const OnboardingPageTemplate({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.activeIndex,
    this.buttonText = 'Suivant',
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -5,
            left: -60,
            width: 527,
            height: 943,
            child: Image.asset(
              imagePath,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  AppColors.primary,
                ],
                stops: [0.0, 0.5787, 0.7721],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 155,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.jost(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      height: 32 / 24,
                      letterSpacing: 24 * 0.005,
                      color: AppColors.surfaceLight,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.jost(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      height: 22 / 18,
                      letterSpacing: 18 * 0.005,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                OnboardingDots(activeIndex: activeIndex),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 52,
            child: Center(
              child: SizedBox(
                width: 340,
                height: 58,
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    buttonText,
                    style: GoogleFonts.jost(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      height: 26 / 18,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
