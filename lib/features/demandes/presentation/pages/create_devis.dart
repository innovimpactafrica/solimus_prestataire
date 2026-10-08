import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/features/demandes/data/services/demandes_service.dart';
import 'devis_success.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/core/widgets/subpage_header.dart';
import '../widgets/devis_material_row.dart';
import '../widgets/devis_total_summary_card.dart';

class _ItemData {
  final TextEditingController description = TextEditingController();
  final TextEditingController quantity = TextEditingController(text: '1');
  final TextEditingController unitPrice = TextEditingController(text: '0');

  void dispose() {
    description.dispose();
    quantity.dispose();
    unitPrice.dispose();
  }

  int get qty => int.tryParse(quantity.text) ?? 0;
  int get price => int.tryParse(unitPrice.text) ?? 0;
  int get total => qty * price;
}

class CreateDevisPage extends StatefulWidget {
  final int requestId;
  const CreateDevisPage({super.key, required this.requestId});

  @override
  State<CreateDevisPage> createState() => _CreateDevisPageState();
}

class _CreateDevisPageState extends State<CreateDevisPage> {
  final List<_ItemData> _materials = [_ItemData()];
  final _laborController = TextEditingController(text: '0');
  final _commentsController = TextEditingController();
  int? _selectedDelayId;
  bool _loading = false;
  Map<int, String> _delays = {};

  static const Map<int, String> _fallbackDelays = {
    1: '24 heures',
    2: '48 heures',
    3: '72 heures',
    4: '1 semaine',
  };

  @override
  void initState() {
    super.initState();
    _loadDelays();
  }

  Future<void> _loadDelays() async {
    try {
      final list = await DemandesService().getEstimatedDelays(widget.requestId);
      if (list.isNotEmpty && mounted) {
        final map = <int, String>{};
        for (final d in list) {
          final id = (d['id'] as num).toInt();
          final label = d['label'] as String? ??
              d['name'] as String? ??
              d['libelle'] as String? ??
              (d['days'] != null ? '${d['days']} jours' : '$id h');
          map[id] = label;
        }
        setState(() {
          _delays = map;
          if (_selectedDelayId == null && map.isNotEmpty) {
            _selectedDelayId = map.keys.first;
          }
        });
        return;
      }
    } catch (_) {}
    if (mounted) setState(() => _delays = _fallbackDelays);
  }

  @override
  void dispose() {
    for (final item in _materials) {
      item.dispose();
    }
    _laborController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  int get _materialsTotal =>
      _materials.fold(0, (sum, item) => sum + item.total);
  int get _laborTotal => int.tryParse(_laborController.text) ?? 0;
  int get _grandTotal => _materialsTotal + _laborTotal;

  Future<void> _submit({required bool draft}) async {
    if (_selectedDelayId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez sélectionner un délai d'intervention"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final items = <Map<String, dynamic>>[];
    for (final m in _materials) {
      if (m.description.text.trim().isNotEmpty) {
        items.add({
          'description': m.description.text.trim(),
          'quantity': m.qty,
          'unitPrice': m.price,
          'type': 'MATERIAL',
        });
      }
    }
    final labor = _laborTotal;
    if (labor > 0) {
      items.add({
        'description': "Main d'œuvre",
        'quantity': 1,
        'unitPrice': labor,
        'type': 'LABOR',
      });
    }

    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Veuillez ajouter au moins un élément (matériel ou main d'œuvre)"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await DemandesService().createQuote(
        interventionRequestId: widget.requestId,
        estimatedDelayId: _selectedDelayId!,
        additionalComments: _commentsController.text.trim(),
        items: items,
        draft: draft,
      );
      if (!mounted) return;
      Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (c, a, s) => const DevisSuccessPage(),
        transitionsBuilder: (c, anim, s, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          height: 1.0,
          letterSpacing: -0.15,
          color: AppColors.overlayDark,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        filled: true,
        fillColor: AppColors.grey50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.grey200, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.grey200, width: 0.5),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SubpageHeader(
              title: 'Créer un devis',
              subtitle: 'Remplissez les informations',
            ),
            const SizedBox(height: 16),

            // Section Matériel
            Container(
              width: 370,
              padding: const EdgeInsets.all(16.5),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.white, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Matériel',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 20 / 14,
                          letterSpacing: -0.15,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _materials.add(_ItemData())),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ajout.svg',
                              width: 14,
                              height: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Ajouter',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                height: 16 / 12,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    _materials.length,
                    (index) {
                      final item = _materials[index];
                      return Padding(
                        padding: EdgeInsets.only(top: index > 0 ? 20.0 : 0.0),
                        child: DevisMaterialRow(
                          descriptionController: item.description,
                          quantityController: item.quantity,
                          unitPriceController: item.unitPrice,
                          total: item.total,
                          canDelete: _materials.length > 1,
                          onChanged: () => setState(() {}),
                          onDelete: () {
                            item.dispose();
                            setState(() => _materials.removeAt(index));
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Section Main d'œuvre
            Container(
              width: 370,
              padding: const EdgeInsets.all(16.5),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.white, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Main d'œuvre",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 20 / 14,
                      letterSpacing: -0.15,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 37,
                    child: TextField(
                      controller: _laborController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.blackDark,
                      ),
                      onChanged: (_) => setState(() {}),
                      decoration: _fieldDecoration('0'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Section Délai d'intervention
            Container(
              width: 370,
              padding: const EdgeInsets.all(16.5),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.white, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Délai d'intervention",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 20 / 14,
                      letterSpacing: -0.15,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 37,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.grey200,
                        width: 0.5,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _selectedDelayId,
                        hint: Text(
                          _delays.isEmpty
                              ? 'Chargement...'
                              : 'Sélectionner un délai',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 20 / 14,
                            letterSpacing: -0.15,
                            color: AppColors.blackDark,
                          ),
                        ),
                        icon: _delays.isEmpty
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              )
                            : const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.blackDark,
                                size: 20,
                              ),
                        isDense: true,
                        isExpanded: true,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.blackDark,
                        ),
                        items: _delays.entries
                            .map((e) => DropdownMenuItem(
                                  value: e.key,
                                  child: Text(e.value),
                                ))
                            .toList(),
                        onChanged: _delays.isEmpty
                            ? null
                            : (v) => setState(() => _selectedDelayId = v),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Section Commentaires additionnels
            Container(
              width: 370,
              padding: const EdgeInsets.all(16.5),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.white, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Commentaires additionnels (optionnel)",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 20 / 14,
                      letterSpacing: -0.15,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _commentsController,
                    maxLines: 3,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.blackDark,
                    ),
                    decoration: _fieldDecoration(
                      'Précisions ou remarques sur le devis...',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Récap total
            DevisTotalSummaryCard(
              materialsTotal: _materialsTotal,
              laborTotal: _laborTotal,
              grandTotal: _grandTotal,
            ),
            const SizedBox(height: 16),

            // Bouton Enregistrer
            GestureDetector(
              onTap: _loading ? null : () => _submit(draft: false),
              child: Container(
                width: 350,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: _loading
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
                            'assets/icons/save.svg',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Enregistrer',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              height: 24 / 18,
                              letterSpacing: -0.31,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 12),

            // Bouton Brouillon
            GestureDetector(
              onTap: _loading ? null : () => _submit(draft: true),
              child: Container(
                width: 350,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: AppColors.primary,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/brouillon.svg',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Brouillon',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        height: 24 / 18,
                        letterSpacing: -0.31,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
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
