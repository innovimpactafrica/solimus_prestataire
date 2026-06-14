import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/auth_models.dart';
import '../../services/auth_service.dart';
import '../../widgets/places_autocomplete_field.dart';
import 'login.dart';
import 'otp_verification.dart';

class Inscription2Page extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;

  const Inscription2Page({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
  });

  @override
  State<Inscription2Page> createState() => _Inscription2PageState();
}

class _Inscription2PageState extends State<Inscription2Page> {
  final _companyNameCtrl = TextEditingController();
  final _zoneCtrl = TextEditingController();
  String? _specialite;
  double _zoneLat = 0.0;
  double _zoneLng = 0.0;
  bool _loading = false;

  static const _specialiteIds = {
    'Plombier': 1,
    'Électricien': 2,
    'Informaticien': 3,
    'Enseignant': 4,
    'Menuisier': 5,
    'Maçon': 6,
    'Peintre': 7,
    'Mécanicien': 8,
  };

  @override
  void dispose() {
    _companyNameCtrl.dispose();
    _zoneCtrl.dispose();
    super.dispose();
  }

  TextStyle get _labelStyle => GoogleFonts.beVietnamPro(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        height: 1.0,
        letterSpacing: 0,
        color: const Color(0xFF646B78),
      );

  InputDecoration _inputDecoration({required String hint}) => InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.beVietnamPro(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          height: 1.0,
          color: const Color(0x4D202221),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        filled: true,
        fillColor: const Color(0x1A6F675E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFD6D2C9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFD6D2C9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF6F675E)),
        ),
      );

  Widget _styledDropdown<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0x1A6F675E),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFD6D2C9)),
      ),
      child: DropdownButton<T>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: const Color(0xFFFAF9F4),
        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6F675E)),
        hint: Text(
          hint,
          style: GoogleFonts.beVietnamPro(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: const Color(0x4D202221),
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    item.toString(),
                    style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Future<void> _submit() async {
    final companyName = _companyNameCtrl.text.trim();
    final zone = _zoneCtrl.text.trim();
    if (companyName.isEmpty || _specialite == null || zone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    final specialtyId = _specialiteIds[_specialite!]!;

    setState(() => _loading = true);
    try {
      await AuthService().register(RegisterRequest(
        firstName: widget.firstName,
        lastName: widget.lastName,
        phone: widget.phone,
        email: widget.email,
        companyName: companyName,
        specialtyId: specialtyId,
        latitude: _zoneLat,
        longitude: _zoneLng,
        interventionZone: zone,
      ));
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => OtpVerificationPage(
            email: widget.email,
            mode: OtpMode.registration,
          ),
        ),
        (route) => route.isFirst,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F4),
      body: Stack(
        children: [
          Positioned(
            top: 62,
            left: 275,
            width: 95,
            height: 36,
            child: SvgPicture.asset(
              'assets/images/solimus logo2.svg',
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 62,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFF6F675E),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomPaint(
                    size: const Size(6.67, 13.33),
                    painter: _ChevronPainter(),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 130,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'INSCRIPTION',
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      height: 1.0,
                      letterSpacing: 24 * 0.05,
                      color: const Color(0xFF231F20),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text('Entreprise', style: _labelStyle),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _companyNameCtrl,
                      decoration: _inputDecoration(
                          hint: "Entrez le nom de l'entreprise"),
                      style: GoogleFonts.beVietnamPro(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Spécialité', style: _labelStyle),
                  const SizedBox(height: 8),
                  _styledDropdown<String>(
                    value: _specialite,
                    hint: 'Choisir votre spécialité',
                    items: _specialiteIds.keys.toList(),
                    onChanged: (v) => setState(() => _specialite = v),
                  ),
                  const SizedBox(height: 20),
                  Text("Zone d'intervention", style: _labelStyle),
                  const SizedBox(height: 8),
                  PlacesAutocompleteField(
                    controller: _zoneCtrl,
                    hint: "Entrez votre zone d'intervention",
                    onCoordinatesSelected: (lat, lng) {
                      _zoneLat = lat;
                      _zoneLng = lng;
                    },
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6F675E),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            const Color(0xFF6F675E).withValues(alpha: 0.6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 17),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        elevation: 0,
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              "S'inscrire",
                              style: GoogleFonts.barlow(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                height: 1.0,
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 55,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Vous avez déjà un compte ?',
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.0,
                    color: const Color(0x99231F20),
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (_) => false,
                  ),
                  child: Text(
                    'Se connecter',
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 1.0,
                      color: const Color(0xFFF9C20A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChevronPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 1.11
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, size.height / 2)
      ..lineTo(size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
