import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/features/demandes/data/models/demandes_models.dart';

class WorkflowStepTile extends StatelessWidget {
  final WorkflowStep? step;
  final String? label;
  final bool? completed;
  final DateTime? date;
  final String? dateString;
  final bool isLast;
  final bool nextCompleted;
  final bool isCurrent;

  const WorkflowStepTile({
    super.key,
    this.step,
    this.label,
    this.completed,
    this.date,
    this.dateString,
    this.isLast = false,
    this.nextCompleted = false,
    this.isCurrent = false,
  });

  String _formatDateTime(DateTime d) {
    const months = [
      '',
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Jun',
      'Jul',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc'
    ];
    return '${d.day} ${months[d.month]} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final effectiveLabel = label ?? step?.label ?? '';
    final isDone = completed ?? step?.completed ?? false;
    final effectiveDate = dateString ??
        (date != null
            ? _formatDateTime(date!)
            : (step?.date != null ? _formatDateTime(step!.date!) : null));

    Color circleBg;
    Widget circleChild;

    if (isDone) {
      circleBg = AppColors.success;
      circleChild = Center(
        child: SvgPicture.asset(
          'assets/icons/donew.svg',
          width: 16,
          height: 16,
        ),
      );
    } else if (isCurrent) {
      circleBg = AppColors.primaryDark;
      circleChild = Center(
        child: SvgPicture.asset(
          'assets/icons/En attente.svg',
          width: 16,
          height: 16,
        ),
      );
    } else {
      circleBg = AppColors.grey200;
      circleChild = const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: circleBg,
                shape: BoxShape.circle,
              ),
              child: circleChild,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 24,
                color: (nextCompleted || isDone) ? AppColors.success : AppColors.grey200,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                effectiveLabel,
                style: GoogleFonts.inter(
                  fontWeight: isDone ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 14,
                  height: 20 / 14,
                  color: isDone ? AppColors.primaryDark : AppColors.grey400,
                ),
              ),
              if (effectiveDate != null)
                Text(
                  effectiveDate,
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
    );
  }
}
