import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/demandes_service.dart';
import '../../services/user_session.dart';
import '../../widgets/places_autocomplete_field.dart';

class InformationsPersonnellesPage extends StatefulWidget {
  const InformationsPersonnellesPage({super.key});

  @override
  State<InformationsPersonnellesPage> createState() => _InformationsPersonnellesPageState();
}

class _InformationsPersonnellesPageState extends State<InformationsPersonnellesPage> {
  final _entrepriseController = TextEditingController();
  final _prenomController = TextEditingController();
  final _nomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _specialiteController = TextEditingController();
  final _zoneController = TextEditingController();

  bool _loading = true;
  bool _submitting = false;
  String? _error;
  String? _photoUrl;
  String? _localPhotoPath;
  XFile? _newPhoto;
  bool _pickingPhoto = false;
  double? _zoneLat;
  double? _zoneLng;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final info = await DemandesService().getPersonalInfo();
      if (!mounted) return;
      _entrepriseController.text = info.companyName;
      _prenomController.text = info.firstName;
      _nomController.text = info.lastName;
      _telephoneController.text = info.phone;
      _emailController.text = info.email;
      _specialiteController.text = info.specialtyName;
      _zoneController.text = info.interventionZone;
      setState(() {
        _photoUrl = info.profilePhotoUrl;
        _localPhotoPath = UserSession.instance.localPhotoPath.value;
        _zoneLat = info.latitude;
        _zoneLng = info.longitude;
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString().replaceFirst('Exception: ', ''); _loading = false; });
    }
  }

  Future<void> _pickPhoto() async {
    if (_pickingPhoto) return;
    _pickingPhoto = true;
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null && mounted) setState(() => _newPhoto = picked);
    } finally {
      _pickingPhoto = false;
    }
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      final newPhotoUrl = await DemandesService().updatePersonalInfo(
        companyName: _entrepriseController.text.trim(),
        firstName: _prenomController.text.trim(),
        lastName: _nomController.text.trim(),
        phone: _telephoneController.text.trim(),
        email: _emailController.text.trim(),
        interventionZone: _zoneController.text.trim(),
        latitude: _zoneLat,
        longitude: _zoneLng,
        photo: _newPhoto,
      );
      String? permanentPath;
      if (_newPhoto != null) {
        permanentPath = await UserSession.instance.saveLocalPhoto(_newPhoto!.path);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour avec succès')),
      );
      Navigator.of(context).pop({
        'updated': true,
        'permanentPhotoPath': permanentPath,
        'newPhotoUrl': newPhotoUrl,
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
      setState(() => _submitting = false);
    }
  }

  @override
  void dispose() {
    _entrepriseController.dispose();
    _prenomController.dispose();
    _nomController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _specialiteController.dispose();
    _zoneController.dispose();
    super.dispose();
  }

  Widget _buildProfileImage() {
    const fallback = Image(image: AssetImage('assets/images/plumbing.png'), width: 91, height: 92, fit: BoxFit.cover);
    if (_photoUrl == null || _photoUrl!.isEmpty) return fallback;
    if (_photoUrl!.startsWith('data:image')) {
      try {
        final base64Str = _photoUrl!.substring(_photoUrl!.indexOf(',') + 1);
        return Image.memory(base64Decode(base64Str), width: 91, height: 92, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => fallback);
      } catch (_) {
        return fallback;
      }
    }
    return Image.network(_photoUrl!, width: 91, height: 92, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback);
  }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.beVietnamPro(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        height: 1.0,
        letterSpacing: 0,
        color: const Color(0xFF646B78),
      ),
    );
  }

  Widget _textField(TextEditingController controller, String hint, {TextInputType? keyboardType}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0x1A6F675E),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFD6D2C9), width: 1),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.beVietnamPro(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          height: 1.0,
          letterSpacing: 0,
          color: const Color(0xFF202221),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.beVietnamPro(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 1.0,
            letterSpacing: 0,
            color: const Color(0x99202221),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, String hint, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        const SizedBox(height: 8),
        _textField(controller, hint, keyboardType: keyboardType),
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
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(color: Color(0x33FFFFFF), shape: BoxShape.circle),
                            child: Center(child: SvgPicture.asset('assets/icons/fleche gauche.svg', width: 20, height: 20)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Informations personnelles',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 20, height: 32 / 20, letterSpacing: 0.07, color: const Color(0xFFFFFFFF)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Modifiez vos informations',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 14, height: 20 / 14, letterSpacing: -0.15, color: const Color(0xFFFFFFFF)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: CircularProgressIndicator(color: Color(0xFF6F675E)),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                child: Column(
                  children: [
                    Text(_error!, textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.red)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _load,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6F675E)),
                      child: const Text('Réessayer', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              )
            else ...[
              const SizedBox(height: 24),

              // Photo de profil (cliquable pour changer)
              GestureDetector(
                onTap: _pickPhoto,
                child: Stack(
                  children: [
                    Container(
                      width: 91,
                      height: 92,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: _newPhoto != null
                            ? Image.file(File(_newPhoto!.path), width: 91, height: 92, fit: BoxFit.cover)
                            : _localPhotoPath != null
                                ? Image.file(File(_localPhotoPath!), width: 91, height: 92, fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset('assets/images/plumbing.png', width: 91, height: 92, fit: BoxFit.cover))
                                : _buildProfileImage(),
                      ),
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: Container(
                        width: 24, height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFF6F675E),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Text(
                _entrepriseController.text.isNotEmpty
                    ? _entrepriseController.text
                    : '${_prenomController.text} ${_nomController.text}'.trim(),
                textAlign: TextAlign.center,
                style: GoogleFonts.workSans(fontWeight: FontWeight.w600, fontSize: 24, height: 1.0, color: const Color(0xFF2F3542)),
              ),

              const SizedBox(height: 6),

              Text(
                _specialiteController.text.isNotEmpty ? _specialiteController.text : '',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 16, height: 1.0, letterSpacing: 16 * 0.02, color: const Color(0xFF747D8C)),
              ),

              const SizedBox(height: 28),

              // Formulaire
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _field('Entreprise', _entrepriseController, 'Nom de l\'entreprise'),
                    const SizedBox(height: 16),
                    _field('Prénom', _prenomController, 'Saisir'),
                    const SizedBox(height: 16),
                    _field('Nom', _nomController, 'Saisir'),
                    const SizedBox(height: 16),
                    _field('Téléphone', _telephoneController, '+221 77 567 89 90', keyboardType: TextInputType.phone),
                    const SizedBox(height: 16),
                    _field('Email', _emailController, 'example@gmail.com', keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 16),
                    _field('Spécialité', _specialiteController, 'Plomberie'),
                    const SizedBox(height: 16),
                    _fieldLabel('Zone d\'intervention'),
                    const SizedBox(height: 8),
                    PlacesAutocompleteField(
                      controller: _zoneController,
                      hint: 'Dakar, Sénégal',
                      onCoordinatesSelected: (lat, lng) {
                        _zoneLat = lat;
                        _zoneLng = lng;
                      },
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _submitting ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF9C20A),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 0,
                        ),
                        child: _submitting
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(
                                'Mettre à jour',
                                style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16, height: 1.0, color: const Color(0xFFFFFFFF)),
                              ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
