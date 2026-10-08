import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import 'package:solimus_prestataire/features/demandes/data/models/devis_models.dart';
import 'package:solimus_prestataire/features/demandes/data/services/demandes_service.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/core/widgets/subpage_header.dart';
import '../widgets/devis_status_gradient_card.dart';
import '../widgets/devis_client_info_card.dart';
import '../widgets/devis_items_section_card.dart';

class DevisDetailPage extends StatefulWidget {
  final int id;
  const DevisDetailPage({super.key, required this.id});

  @override
  State<DevisDetailPage> createState() => _DevisDetailPageState();
}

class _DevisDetailPageState extends State<DevisDetailPage> {
  DevisDetail? _data;
  bool _loading = true;
  String? _error;
  bool _pdfLoading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await DemandesService().getQuoteById(widget.id);
      if (mounted) {
        setState(() {
          _data = data;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
          _loading = false;
        });
      }
    }
  }

  Future<void> _downloadPdf() async {
    if (_data == null || _pdfLoading) return;
    setState(() => _pdfLoading = true);
    try {
      final d = _data!;
      final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
      final fontBoldData = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');
      final font = pw.Font.ttf(fontData);
      final fontBold = pw.Font.ttf(fontBoldData);

      pw.TextStyle s(double size,
              {bool bold = false, PdfColor color = PdfColors.black}) =>
          pw.TextStyle(
              font: bold ? fontBold : font, fontSize: size, color: color);

      final pdf = pw.Document();
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          theme: pw.ThemeData.withFont(base: font, bold: fontBold),
          build: (ctx) => [
            // En-tête
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(d.reference, style: s(18, bold: true)),
                    pw.Text(d.titre, style: s(13, color: PdfColors.grey600)),
                  ],
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Text(d.statLabel, style: s(12, bold: true)),
                ),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Row(
              children: [
                if (d.dateEnvoi != null)
                  pw.Text('Envoyé le : ${_formatDate(d.dateEnvoi!)}',
                      style: s(11, color: PdfColors.grey600)),
                if (d.dateValidation != null) ...[
                  pw.SizedBox(width: 24),
                  pw.Text('Validé le : ${_formatDate(d.dateValidation!)}',
                      style: s(11, color: PdfColors.grey600)),
                ],
              ],
            ),
            pw.Divider(height: 24),

            // Client
            pw.Text('Informations client', style: s(14, bold: true)),
            pw.SizedBox(height: 8),
            if (d.clientNom.isNotEmpty)
              pw.Text('Nom : ${d.clientNom}', style: s(12)),
            if (d.clientTelephone.isNotEmpty)
              pw.Text('Tél : ${d.clientTelephone}', style: s(12)),
            if (d.clientEmail.isNotEmpty)
              pw.Text('Email : ${d.clientEmail}', style: s(12)),
            if (d.clientAdresse.isNotEmpty)
              pw.Text('Adresse : ${d.clientAdresse}', style: s(12)),
            pw.Divider(height: 24),

            // Matériaux
            if (d.materiaux.isNotEmpty) ...[
              pw.Text('Matériels', style: s(14, bold: true)),
              pw.SizedBox(height: 8),
              pw.TableHelper.fromTextArray(
                headers: ['Description', 'Qté', 'Prix unit.', 'Sous-total'],
                data: d.materiaux
                    .map((m) => [
                          m.description,
                          '${m.quantity}',
                          _formatAmount(m.unitPrice.toDouble()),
                          _formatAmount(m.subtotal.toDouble()),
                        ])
                    .toList(),
                headerStyle: s(11, bold: true),
                cellStyle: s(11),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.grey100),
              ),
              pw.SizedBox(height: 4),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                    'Sous-total matériels : ${_formatAmount(d.sousTotalMateriaux)}',
                    style: s(11, bold: true)),
              ),
              pw.Divider(height: 20),
            ],

            // Main d'œuvre
            if (d.mainOeuvre.isNotEmpty) ...[
              pw.Text("Main d'œuvre", style: s(14, bold: true)),
              pw.SizedBox(height: 8),
              pw.TableHelper.fromTextArray(
                headers: ['Description', 'Qté', 'Prix unit.', 'Sous-total'],
                data: d.mainOeuvre
                    .map((m) => [
                          m.description,
                          '${m.quantity}',
                          _formatAmount(m.unitPrice.toDouble()),
                          _formatAmount(m.subtotal.toDouble()),
                        ])
                    .toList(),
                headerStyle: s(11, bold: true),
                cellStyle: s(11),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.grey100),
              ),
              pw.SizedBox(height: 4),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                    "Sous-total main d'œuvre : ${_formatAmount(d.sousTotalMainOeuvre)}",
                    style: s(11, bold: true)),
              ),
              pw.Divider(height: 20),
            ],

            // Total
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Text(
                  'Total TTC : ${_formatAmount(d.totalTTC)}',
                  style: s(14, bold: true),
                ),
              ),
            ),

            if (d.notes != null && d.notes!.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              pw.Text('Notes :', style: s(12, bold: true)),
              pw.Text(d.notes!, style: s(11)),
            ],
          ],
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/devis_${d.reference}.pdf');
      await file.writeAsBytes(await pdf.save());
      await OpenFilex.open(file.path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur génération PDF : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _pdfLoading = false);
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  String _formatAmount(double amount) {
    final str = amount.toInt().toString();
    final buf = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(' ');
      buf.write(str[i]);
    }
    return '${buf.toString()} FCFA';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }
    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _load,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary),
                child: const Text('Réessayer',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    final d = _data!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SubpageHeader(
              title: d.reference,
              subtitle: d.titre,
            ),
            const SizedBox(height: 16),
            DevisStatusGradientCard(
              statLabel: d.statLabel,
              formattedAmount: _formatAmount(d.montantTotal),
              dateEnvoi:
                  d.dateEnvoi != null ? _formatDate(d.dateEnvoi!) : null,
              dateValidation: d.dateValidation != null
                  ? _formatDate(d.dateValidation!)
                  : null,
            ),
            const SizedBox(height: 16),
            DevisClientInfoCard(
              nom: d.clientNom,
              telephone: d.clientTelephone,
              email: d.clientEmail,
              adresse: d.clientAdresse,
            ),
            if (d.materiaux.isNotEmpty) ...[
              const SizedBox(height: 16),
              DevisItemsSectionCard(
                iconPath: 'assets/icons/materiel.svg',
                title: 'Matériels',
                iconBg: AppColors.primary10,
                items: d.materiaux
                    .map((m) => DevisSectionItemData(
                          description: m.description,
                          quantity: m.quantity,
                          unitPrice: m.unitPrice,
                          subtotal: m.subtotal,
                        ))
                    .toList(),
                subtotalLabel: 'Sous-total matériels',
                subtotalAmount: d.sousTotalMateriaux,
                formatAmount: _formatAmount,
              ),
            ],
            if (d.mainOeuvre.isNotEmpty) ...[
              const SizedBox(height: 16),
              DevisItemsSectionCard(
                iconPath: 'assets/icons/mainoeuvre.svg',
                title: "Main d'œuvre",
                iconBg: AppColors.warningLight,
                items: d.mainOeuvre
                    .map((m) => DevisSectionItemData(
                          description: m.description,
                          quantity: m.quantity,
                          unitPrice: m.unitPrice,
                          subtotal: m.subtotal,
                        ))
                    .toList(),
                subtotalLabel: "Sous-total main d'œuvre",
                subtotalAmount: d.sousTotalMainOeuvre,
                formatAmount: _formatAmount,
              ),
            ],
            const SizedBox(height: 16),
            Container(
              width: 365,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.textCharcoal,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total TTC',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    _formatAmount(d.totalTTC),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      letterSpacing: 0.07,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            if (d.estimatedDelayLabel != null &&
                d.estimatedDelayLabel!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: 365,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Délai estimé',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.greySlate,
                      ),
                    ),
                    Text(
                      d.estimatedDelayLabel!,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.textCharcoal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (d.notes != null && d.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: 365,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.warningBg,
                  border: Border(
                    top: BorderSide(color: AppColors.amberLight, width: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/note.svg',
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Notes',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            height: 20 / 14,
                            letterSpacing: -0.15,
                            color: AppColors.warningDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      d.notes!,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 20 / 14,
                        letterSpacing: -0.15,
                        color: AppColors.warningText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _downloadPdf,
              child: Container(
                width: 365,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: _pdfLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/download2.svg',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Télécharger le devis PDF',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              height: 24 / 16,
                              letterSpacing: -0.31,
                              color: AppColors.white,
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
