import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/features/home/data/models/dashboard_models.dart';

class PerformanceBarChart extends StatelessWidget {
  final List<PerformanceHebdo> data;

  const PerformanceBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();
    return CustomPaint(
      size: const Size(339, 220),
      painter: _BarChartPainter(data),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<PerformanceHebdo> data;

  _BarChartPainter(this.data);

  String _shortVal(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}k';
    return v.toStringAsFixed(0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    const bottomPadding = 28.0;
    const topPadding = 12.0;
    const yLabelCount = 4;
    final textStyle = TextStyle(
      color: AppColors.grey400,
      fontSize: 10,
      fontFamily: GoogleFonts.inter().fontFamily,
    );

    // Mesure la largeur max des labels Y
    final maxVal = data.map((e) => e.montant).reduce((a, b) => a > b ? a : b);
    double yLabelWidth = 0;
    for (int i = 0; i <= yLabelCount; i++) {
      final val = maxVal * i / yLabelCount;
      final tp = TextPainter(
        text: TextSpan(text: _shortVal(val), style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      if (tp.width > yLabelWidth) yLabelWidth = tp.width;
    }
    const yLabelGap = 6.0;
    final leftPadding = yLabelWidth + yLabelGap;

    final chartWidth = size.width - leftPadding;
    final chartHeight = size.height - bottomPadding - topPadding;
    final barWidth = (chartWidth / data.length) * 0.45;
    final gap = chartWidth / data.length;

    final axisPaint = Paint()
      ..color = AppColors.grey200
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final barPaint = Paint()..color = AppColors.primary;

    // Lignes horizontales + labels Y
    for (int i = 0; i <= yLabelCount; i++) {
      final y = topPadding + chartHeight - (chartHeight * i / yLabelCount);
      canvas.drawLine(Offset(leftPadding, y), Offset(size.width, y), axisPaint);

      final val = maxVal * i / yLabelCount;
      final tp = TextPainter(
        text: TextSpan(text: _shortVal(val), style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(yLabelWidth - tp.width, y - tp.height / 2));
    }

    // Axe vertical gauche
    canvas.drawLine(
      Offset(leftPadding, topPadding),
      Offset(leftPadding, topPadding + chartHeight),
      axisPaint,
    );

    for (int i = 0; i < data.length; i++) {
      final x = leftPadding + gap * i + gap / 2;
      final barH =
          maxVal == 0 ? 8.0 : (data[i].montant / maxVal) * chartHeight;
      final effectiveH = barH < 8 ? 8.0 : barH;

      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(
          x - barWidth / 2,
          topPadding + chartHeight - effectiveH,
          barWidth,
          effectiveH,
        ),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      );
      canvas.drawRRect(rect, barPaint);

      final tp = TextPainter(
        text: TextSpan(text: data[i].jour, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas,
          Offset(x - tp.width / 2, size.height - bottomPadding + 6));
    }
  }

  @override
  bool shouldRepaint(_BarChartPainter old) => old.data != data;
}
