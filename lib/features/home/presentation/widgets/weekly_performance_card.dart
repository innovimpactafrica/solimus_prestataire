import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/features/home/data/models/dashboard_models.dart';
import 'performance_bar_chart.dart';

class WeeklyPerformanceCard extends StatelessWidget {
  final double variationHebdo;
  final List<PerformanceHebdo> performanceHebdo;
  final double totalRevenu;
  final double moyenneParJour;
  final int totalInterventions;

  const WeeklyPerformanceCard({
    super.key,
    required this.variationHebdo,
    required this.performanceHebdo,
    required this.totalRevenu,
    required this.moyenneParJour,
    required this.totalInterventions,
  });

  String _formatVariation(double v) {
    if (v > 0) return '+${v.toStringAsFixed(0)}%';
    if (v < 0) return '${v.toStringAsFixed(0)}%';
    return '0%';
  }

  String _formatFCFA(double v) {
    final n = v.toInt();
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return '${buf.toString()} FCFA';
  }

  Widget _chartStat({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            height: 16 / 12,
            letterSpacing: 0,
            color: AppColors.greySlate,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            height: 20 / 14,
            letterSpacing: -0.15,
            color: AppColors.black60,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      height: 391,
      padding: const EdgeInsets.only(
        top: 20.5,
        right: 20.5,
        bottom: 0.5,
        left: 20.5,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Performance hebdomadaire',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      height: 24 / 16,
                      letterSpacing: -0.31,
                      color: AppColors.black,
                    ),
                  ),
                  Text(
                    'Revenus des 7 derniers jours',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      height: 16 / 12,
                      letterSpacing: 0,
                      color: AppColors.greySlate,
                    ),
                  ),
                ],
              ),
              Container(
                width: 58,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.warning10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    _formatVariation(variationHebdo),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      height: 16 / 12,
                      letterSpacing: 0,
                      color: AppColors.warning,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 339,
            height: 220,
            child: PerformanceBarChart(data: performanceHebdo),
          ),
          Container(
            width: 339,
            height: 56,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.grey100, width: 0.5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _chartStat(
                    label: 'Total',
                    value: _formatFCFA(totalRevenu),
                  ),
                  _chartStat(
                    label: 'Moyenne/jour',
                    value: _formatFCFA(moyenneParJour),
                  ),
                  _chartStat(
                    label: 'Interventions',
                    value: '$totalInterventions',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
