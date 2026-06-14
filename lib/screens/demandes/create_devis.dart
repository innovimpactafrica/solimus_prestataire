import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/demandes_service.dart';
import 'devis_success.dart';

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
      final list = await DemandesService().getEstimatedDelays();
      if (list.isNotEmpty && mounted) {
        final map = <int, String>{};
        for (final d in list) {
          final id = (d['id'] as num).toInt();
          final label = d['label'] as String? ??
              d['name'] as String? ??
              d['libelle'] as String? ??
              d['value'] as String? ??
              '$id h';
          map[id] = label;
        }
        setState(() => _delays = map);
        return;
      }
    } catch (_) {}
    if (mounted) setState(() => _delays = _fallbackDelays);
  }

  @override
  void dispose() {
    for (final item in _materials) { item.dispose(); }
    _laborController.dispose();
    super.dispose();
  }

  int get _materialsTotal => _materials.fold(0, (sum, item) => sum + item.total);
  int get _laborTotal => int.tryParse(_laborController.text) ?? 0;
  int get _grandTotal => _materialsTotal + _laborTotal;

  Future<void> _submit({required bool draft}) async {
    if (!draft && _selectedDelayId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un délai'), backgroundColor: Colors.red),
      );
      return;
    }
    setState(() => _loading = true);
    try {
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
      await DemandesService().createQuote(
        interventionRequestId: widget.requestId,
        estimatedDelayId: _selectedDelayId ?? 1,
        items: items,
        draft: draft,
      );
      if (!mounted) return;
      Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (c, a, s) => const DevisSuccessPage(),
        transitionsBuilder: (c, anim, s, child) =>
            FadeTransition(opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', '')), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, height: 1.0, letterSpacing: -0.15, color: const Color(0x800A0A0A)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 0.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 0.5)),
      );

  Widget _materialRow(int index) {
    final item = _materials[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index > 0) const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: 37,
                child: TextField(
                  controller: item.description,
                  style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF0A0A0A)),
                  decoration: _fieldDecoration('Description du matériel'),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                if (_materials.length > 1) {
                  item.dispose();
                  setState(() => _materials.removeAt(index));
                }
              },
              child: SvgPicture.asset('assets/icons/Delete.svg', width: 16, height: 16),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: Text('Quantité', style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 12, height: 16 / 12, color: const Color(0xFF6A7282)))),
            const SizedBox(width: 8),
            Expanded(child: Text('Prix (FCFA)', style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 12, height: 16 / 12, color: const Color(0xFF6A7282)))),
            const SizedBox(width: 8),
            Expanded(child: Text('Total', style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 12, height: 16 / 12, color: const Color(0xFF6A7282)))),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 37,
                child: TextField(
                  controller: item.quantity,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF0A0A0A)),
                  onChanged: (_) => setState(() {}),
                  decoration: _fieldDecoration('1'),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 37,
                child: TextField(
                  controller: item.unitPrice,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF0A0A0A)),
                  onChanged: (_) => setState(() {}),
                  decoration: _fieldDecoration('0'),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 37,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
                ),
                child: Text(
                  '${item.total} FCFA',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFF0A0A0A)),
                ),
              ),
            ),
          ],
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
                            Text('Créer un devis', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 20, height: 32 / 20, letterSpacing: 0.07, color: const Color(0xFFFFFFFF))),
                            const SizedBox(height: 2),
                            Text('Remplissez les informations', style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFFFFFFFF))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Section Matériel
            Container(
              width: 370,
              padding: const EdgeInsets.fromLTRB(16.5, 16.5, 16.5, 16.5),
              decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFFFFFFF), width: 0.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Matériel', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFF2D2520))),
                      GestureDetector(
                        onTap: () => setState(() => _materials.add(_ItemData())),
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/icons/ajout.svg', width: 14, height: 14),
                            const SizedBox(width: 4),
                            Text('Ajouter', style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 12, height: 16 / 12, color: const Color(0xFF2D2520))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(_materials.length, _materialRow),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Section Main d'œuvre
            Container(
              width: 370,
              padding: const EdgeInsets.fromLTRB(16.5, 16.5, 16.5, 16.5),
              decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFFFFFFF), width: 0.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Main d'œuvre", style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFF2D2520))),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 37,
                    child: TextField(
                      controller: _laborController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF0A0A0A)),
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
              padding: const EdgeInsets.fromLTRB(16.5, 16.5, 16.5, 16.5),
              decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFFFFFFF), width: 0.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Délai d'intervention", style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFF2D2520))),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 37,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _selectedDelayId,
                        hint: Text(
                          _delays.isEmpty ? 'Chargement...' : 'Sélectionner un délai',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFF0A0A0A)),
                        ),
                        icon: _delays.isEmpty
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF6F675E)))
                            : const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0A0A0A), size: 20),
                        isDense: true,
                        isExpanded: true,
                        style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, color: const Color(0xFF0A0A0A)),
                        items: _delays.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
                        onChanged: _delays.isEmpty ? null : (v) => setState(() => _selectedDelayId = v),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Récap total
            Container(
              width: 370,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF6F675E),
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(color: Color(0x1A000000), offset: Offset(0, 1), blurRadius: 2, spreadRadius: -1),
                  BoxShadow(color: Color(0x1A000000), offset: Offset(0, 1), blurRadius: 3),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sous-total matériel', style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xB3FFFFFF))),
                      Text('$_materialsTotal FCFA', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFFFFFFFF))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Main d'œuvre", style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xB3FFFFFF))),
                      Text('$_laborTotal FCFA', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFFFFFFFF))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: Color(0x33FFFFFF), thickness: 0.5, height: 1),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Total', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFFFFFFFF))),
                      Text('$_grandTotal FCFA', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 20, height: 28 / 20, letterSpacing: -0.45, color: const Color(0xFFFFFFFF))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Bouton Enregistrer
            GestureDetector(
              onTap: _loading ? null : () => _submit(draft: false),
              child: Container(
                width: 350,
                height: 56,
                decoration: BoxDecoration(color: const Color(0xFFF9C20A), borderRadius: BorderRadius.circular(15)),
                child: _loading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/save.svg', width: 20, height: 20),
                          const SizedBox(width: 8),
                          Text('Enregistrer', style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 18, height: 24 / 18, letterSpacing: -0.31, color: const Color(0xFFFFFFFF))),
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
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFF6F675E), width: 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/brouillon.svg', width: 20, height: 20),
                    const SizedBox(width: 8),
                    Text('Brouillon', style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 18, height: 24 / 18, letterSpacing: -0.31, color: const Color(0xFF6F675E))),
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
