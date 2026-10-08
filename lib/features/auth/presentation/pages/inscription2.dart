import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/features/auth/data/models/auth_models.dart';
import 'package:solimus_prestataire/features/auth/data/services/auth_service.dart';
import 'package:solimus_prestataire/core/widgets/places_autocomplete_field.dart';
import 'login.dart';
import 'otp_verification.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_header_logo.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_dropdown_field.dart';

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
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const AuthHeaderLogo(),
          const AuthBackButton(),
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
                      color: AppColors.textCharcoal,
                    ),
                  ),
                  const SizedBox(height: 28),
                  AuthTextField(
                    controller: _companyNameCtrl,
                    label: 'Entreprise',
                    hint: "Entrez le nom de l'entreprise",
                  ),
                  const SizedBox(height: 20),
                  AuthDropdownField<String>(
                    label: 'Spécialité',
                    value: _specialite,
                    hint: 'Choisir votre spécialité',
                    items: _specialiteIds.keys.toList(),
                    onChanged: (v) => setState(() => _specialite = v),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Zone d'intervention",
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      height: 1.0,
                      letterSpacing: 0,
                      color: AppColors.textSecondary,
                    ),
                  ),
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
                  AuthPrimaryButton(
                    text: "S'inscrire",
                    isLoading: _loading,
                    onPressed: _submit,
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
                    color: AppColors.textPrimary60,
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
                      color: AppColors.warning,
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
