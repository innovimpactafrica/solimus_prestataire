import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import '../../models/devis_models.dart';
import '../../services/demandes_service.dart';

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
    setState(() { _loading = true; _error = null; });
    try {
      final data = await DemandesService().getQuoteById(widget.id);
      if (mounted) setState(() { _data = data; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString().replaceFirst('Exception: ', ''); _loading = false; });
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

      pw.TextStyle s(double size, {bool bold = false, PdfColor color = PdfColors.black}) =>
          pw.TextStyle(font: bold ? fontBold : font, fontSize: size, color: color);

      final pdf = pw.Document();
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        build: (ctx) => [
          // En-tête
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text(d.reference, style: s(18, bold: true)),
                pw.Text(d.titre, style: s(13, color: PdfColors.grey600)),
              ]),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: pw.BoxDecoration(color: PdfColors.grey200, borderRadius: pw.BorderRadius.circular(6)),
                child: pw.Text(d.statLabel, style: s(12, bold: true)),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(children: [
            if (d.dateEnvoi != null) pw.Text('Envoye le : ${_formatDate(d.dateEnvoi!)}', style: s(11, color: PdfColors.grey600)),
            if (d.dateValidation != null) ...[
              pw.SizedBox(width: 24),
              pw.Text('Valide le : ${_formatDate(d.dateValidation!)}', style: s(11, color: PdfColors.grey600)),
            ],
          ]),
          pw.Divider(height: 24),

          // Client
          pw.Text('Informations client', style: s(14, bold: true)),
          pw.SizedBox(height: 8),
          if (d.clientNom.isNotEmpty) pw.Text('Nom : ${d.clientNom}', style: s(12)),
          if (d.clientTelephone.isNotEmpty) pw.Text('Tel : ${d.clientTelephone}', style: s(12)),
          if (d.clientEmail.isNotEmpty) pw.Text('Email : ${d.clientEmail}', style: s(12)),
          if (d.clientAdresse.isNotEmpty) pw.Text('Adresse : ${d.clientAdresse}', style: s(12)),
          pw.Divider(height: 24),

          // Materiaux
          if (d.materiaux.isNotEmpty) ...[
            pw.Text('Materiels', style: s(14, bold: true)),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              columnWidths: {0: const pw.FlexColumnWidth(3), 1: const pw.FlexColumnWidth(2), 2: const pw.FlexColumnWidth(2)},
              children: [
                pw.TableRow(decoration: const pw.BoxDecoration(color: PdfColors.grey200), children: [
                  pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Description', style: s(11, bold: true))),
                  pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Detail', style: s(11, bold: true))),
                  pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Montant', style: s(11, bold: true))),
                ]),
                ...d.materiaux.map((m) => pw.TableRow(children: [
                  pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(m.description, style: s(11))),
                  pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(m.detail, style: s(11))),
                  pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(_formatAmount(m.montant), style: s(11))),
                ])),
                pw.TableRow(decoration: const pw.BoxDecoration(color: PdfColors.grey100), children: [
                  pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Sous-total', style: s(11, bold: true))),
                  pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('')),
                  pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(_formatAmount(d.sousTotalMateriaux), style: s(11, bold: true))),
                ]),
              ],
            ),
            pw.SizedBox(height: 16),
          ],

          // Main d'oeuvre
          if (d.mainOeuvre.isNotEmpty) ...[
            pw.Text('Main d\'oeuvre', style: s(14, bold: true)),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              columnWidths: {0: const pw.FlexColumnWidth(3), 1: const pw.FlexColumnWidth(2), 2: const pw.FlexColumnWidth(2)},
              children: [
                pw.TableRow(decoration: const pw.BoxDecoration(color: PdfColors.grey200), children: [
                  pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Description', style: s(11, bold: true))),
                  pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Detail', style: s(11, bold: true))),
                  pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Montant', style: s(11, bold: true))),
                ]),
                ...d.mainOeuvre.map((m) => pw.TableRow(children: [
                  pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(m.description, style: s(11))),
                  pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(m.detail, style: s(11))),
                  pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(_formatAmount(m.montant), style: s(11))),
                ])),
                pw.TableRow(decoration: const pw.BoxDecoration(color: PdfColors.grey100), children: [
                  pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Sous-total', style: s(11, bold: true))),
                  pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('')),
                  pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(_formatAmount(d.sousTotalMainOeuvre), style: s(11, bold: true))),
                ]),
              ],
            ),
            pw.SizedBox(height: 16),
          ],

          if (d.estimatedDelayLabel != null && d.estimatedDelayLabel!.isNotEmpty)
            pw.Text('Delai estime : ${d.estimatedDelayLabel}', style: s(12, color: PdfColors.grey700)),
          if (d.notes != null && d.notes!.isNotEmpty) ...[
            pw.SizedBox(height: 8),
            pw.Text('Notes : ${d.notes}', style: s(12, color: PdfColors.grey700)),
          ],
          pw.Divider(height: 24),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: pw.BoxDecoration(color: PdfColors.grey800, borderRadius: pw.BorderRadius.circular(8)),
                child: pw.Text('Total TTC : ${_formatAmount(d.totalTTC)}', style: s(14, bold: true, color: PdfColors.white)),
              ),
            ],
          ),
        ],
      ));

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${d.reference}.pdf');
      await file.writeAsBytes(await pdf.save());
      await OpenFilex.open(file.path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur PDF : $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _pdfLoading = false);
    }
  }

  String _formatDate(DateTime d) {
    const months = ['', 'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month]} ${d.year}';
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

  Widget _infoRow(String iconPath, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(top: 2), child: SvgPicture.asset(iconPath, width: 16, height: 16)),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 12, height: 1.0, color: const Color(0xFF99A1AF))),
            const SizedBox(height: 3),
            Text(value, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFF231F20))),
          ],
        ),
      ],
    );
  }

  Widget _lineItem(String description, String detail, double montant) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(description, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFF231F20))),
              if (detail.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(detail, style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 12, height: 1.0, color: const Color(0xFF6A7282))),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(_formatAmount(montant), style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFF6F675E))),
      ],
    );
  }

  Widget _sectionHeader(String iconPath, String title, Color iconBg) {
    return Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
          child: Center(child: SvgPicture.asset(iconPath, width: 16, height: 16)),
        ),
        const SizedBox(width: 10),
        Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 20, height: 30 / 20, letterSpacing: -0.45, color: const Color(0xFF231F20))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFAF9F4),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF6F675E))),
      );
    }
    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFAF9F4),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _load, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6F675E)), child: const Text('Réessayer', style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
      );
    }

    final d = _data!;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F4),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            SizedBox(
              height: 135,
              child: Stack(
                children: [
                  Container(width: double.infinity, height: 135, color: const Color(0xFF6F675E)),
                  Container(width: double.infinity, height: 135, color: const Color(0x66000000)),
                  Positioned(
                    top: 48, left: 24,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 40, height: 40,
                            decoration: const BoxDecoration(color: Color(0x33FFFFFF), shape: BoxShape.circle),
                            child: Center(child: SvgPicture.asset('assets/icons/fleche gauche.svg', width: 20, height: 20)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(d.reference, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 20, height: 32 / 20, letterSpacing: 0.07, color: const Color(0xFFFFFFFF))),
                            const SizedBox(height: 2),
                            Text(d.titre, style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFFFFFFFF))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Carte statut
            Container(
              width: 365,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6F675E), Color(0xFF6D655C), Color(0xFF6A625A), Color(0xFF686058), Color(0xFF665E55), Color(0xFF635B53), Color(0xFF615951), Color(0xFF5F574F), Color(0xFF5C544D), Color(0xFF5A524B)],
                  stops: [0.0, 0.1111, 0.2222, 0.3333, 0.4444, 0.5556, 0.6667, 0.7778, 0.8889, 1.0],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Statut', style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 12, color: const Color(0xFF99A1AF))),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                SvgPicture.asset('assets/icons/valid.svg', width: 20, height: 20),
                                const SizedBox(width: 6),
                                Text(d.statLabel, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18, color: const Color(0xFFFFFFFF))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Montant total', style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 12, color: const Color(0xFF99A1AF))),
                          const SizedBox(height: 6),
                          Text(_formatAmount(d.montantTotal), style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 20, letterSpacing: 0.07, color: const Color(0xFFFFFFFF))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0x33FFFFFF), thickness: 0.5, height: 1),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (d.dateEnvoi != null)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Envoyé le', style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 12, color: const Color(0xFF99A1AF))),
                              const SizedBox(height: 3),
                              Text(_formatDate(d.dateEnvoi!), style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: const Color(0xFFFFFFFF))),
                            ],
                          ),
                        ),
                      if (d.dateValidation != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Validé le', style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 12, color: const Color(0xFF99A1AF))),
                            const SizedBox(height: 3),
                            Text(_formatDate(d.dateValidation!), style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: const Color(0xFFFFFFFF))),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Informations client
            Container(
              width: 365,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader('assets/icons/infoclient.svg', 'Informations client', const Color(0x1A6F675E)),
                  const SizedBox(height: 16),
                  if (d.clientNom.isNotEmpty) ...[_infoRow('assets/icons/nom.svg', 'Nom', d.clientNom), const SizedBox(height: 14)],
                  if (d.clientTelephone.isNotEmpty) ...[_infoRow('assets/icons/telephone.svg', 'Téléphone', d.clientTelephone), const SizedBox(height: 14)],
                  if (d.clientEmail.isNotEmpty) ...[_infoRow('assets/icons/Email.svg', 'Email', d.clientEmail), const SizedBox(height: 14)],
                  if (d.clientAdresse.isNotEmpty) _infoRow('assets/icons/adress.svg', 'Adresse', d.clientAdresse),
                ],
              ),
            ),

            // Matériaux
            if (d.materiaux.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: 365,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader('assets/icons/materiel.svg', 'Matériels', const Color(0x1A6F675E)),
                    const SizedBox(height: 16),
                    ...d.materiaux.asMap().entries.map((e) => Padding(
                      padding: EdgeInsets.only(bottom: e.key < d.materiaux.length - 1 ? 12 : 0),
                      child: _lineItem(e.value.description, e.value.detail, e.value.montant),
                    )),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFF3F4F6), thickness: 1, height: 1),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Sous-total matériels', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14, color: const Color(0xFF2D2520))),
                        Text(_formatAmount(d.sousTotalMateriaux), style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14, color: const Color(0xFF2D2520))),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            // Main d'œuvre
            if (d.mainOeuvre.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: 365,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader('assets/icons/mainoeuvre.svg', "Main d'œuvre", const Color(0xFFFEF3C6)),
                    const SizedBox(height: 16),
                    ...d.mainOeuvre.asMap().entries.map((e) => Padding(
                      padding: EdgeInsets.only(bottom: e.key < d.mainOeuvre.length - 1 ? 12 : 0),
                      child: _lineItem(e.value.description, e.value.detail, e.value.montant),
                    )),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFF3F4F6), thickness: 1, height: 1),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Sous-total main d'œuvre", style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14, color: const Color(0xFF2D2520))),
                        Text(_formatAmount(d.sousTotalMainOeuvre), style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14, color: const Color(0xFF2D2520))),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            // Total TTC
            const SizedBox(height: 16),
            Container(
              width: 365,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(color: const Color(0xFF231F20), borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total TTC', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16, color: const Color(0xFFFFFFFF))),
                  Text(_formatAmount(d.totalTTC), style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 22, letterSpacing: 0.07, color: const Color(0xFFFFFFFF))),
                ],
              ),
            ),

            // Délai estimé
            if (d.estimatedDelayLabel != null && d.estimatedDelayLabel!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: 365,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Délai estimé', style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, color: const Color(0xFF6A7282))),
                    Text(d.estimatedDelayLabel!, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: const Color(0xFF231F20))),
                  ],
                ),
              ),
            ],

            // Notes
            if (d.notes != null && d.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: 365,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFBEB),
                  border: Border(top: BorderSide(color: Color(0xFFFEE685), width: 0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/icons/note.svg', width: 16, height: 16),
                        const SizedBox(width: 8),
                        Text('Notes', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFF7B3306))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(d.notes!, style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFF973C00))),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Bouton télécharger PDF
            GestureDetector(
              onTap: _downloadPdf,
              child: Container(
                width: 365,
                height: 56,
                decoration: BoxDecoration(color: const Color(0xFF6F675E), borderRadius: BorderRadius.circular(15)),
                child: _pdfLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/download2.svg', width: 20, height: 20),
                          const SizedBox(width: 8),
                          Text('Télécharger le devis PDF', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16, height: 24 / 16, letterSpacing: -0.31, color: const Color(0xFFFFFFFF))),
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
