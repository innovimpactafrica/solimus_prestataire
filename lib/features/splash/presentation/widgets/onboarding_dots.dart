import 'package:flutter/material.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class OnboardingDots extends StatelessWidget {
  final int activeIndex;
  final int count;

  const OnboardingDots({
    super.key,
    required this.activeIndex,
    this.count = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Container(
            width: isActive ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? AppColors.warning : AppColors.white,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        );
      }),
    );
  }
}
