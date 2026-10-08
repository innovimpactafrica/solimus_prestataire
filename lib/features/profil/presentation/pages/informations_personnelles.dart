import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solimus_prestataire/features/demandes/data/services/demandes_service.dart';
import 'package:solimus_prestataire/features/auth/data/services/user_session.dart';
import 'package:solimus_prestataire/core/widgets/places_autocomplete_field.dart';
import 'package:solimus_prestataire/core/widgets/subpage_header.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import '../widgets/profile_photo_picker.dart';

class InformationsPersonnellesPage extends StatefulWidget {
  const InformationsPersonnellesPage({super.key});

  @override
  State<InformationsPersonnellesPage> createState() =>
      _InformationsPersonnellesPageState();
}

class _InformationsPersonnellesPageState
    extends State<InformationsPersonnellesPage> {
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
    setState(() {
      _loading = true;
      _error = null;
    });
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
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
          _loading = false;
        });
      }
    }
  }

  Future<void> _pickPhoto() async {
    if (_pickingPhoto) return;
    _pickingPhoto = true;
    try {
      final picked =
          await ImagePicker().pickImage(source: ImageSource.gallery);
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
        permanentPath =
            await UserSession.instance.saveLocalPhoto(_newPhoto!.path);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour avec succès')),
      );
      setState(() {
        if (permanentPath != null) _localPhotoPath = permanentPath;
        _photoUrl = newPhotoUrl;
        _newPhoto = null;
      });
      Navigator.of(context).pop(true);
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
      if (mounted) setState(() => _submitting = false);
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

  String get _initials {
    final entreprise = _entrepriseController.text.trim();
    final prenom = _prenomController.text.trim();
    final nom = _nomController.text.trim();
    if (entreprise.isNotEmpty) {
      final parts = entreprise.split(' ').where((p) => p.isNotEmpty).toList();
      return parts.length >= 2
          ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
          : parts[0][0].toUpperCase();
    }
    return '${prenom.isNotEmpty ? prenom[0] : ''}${nom.isNotEmpty ? nom[0] : ''}'
        .toUpperCase();
  }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.beVietnamPro(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        height: 1.0,
        letterSpacing: 0,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _textField(TextEditingController controller, String hint,
      {TextInputType? keyboardType}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.primary10,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.warmGrey, width: 1),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.beVietnamPro(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          height: 1.0,
          letterSpacing: 0,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.beVietnamPro(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 1.0,
            letterSpacing: 0,
            color: AppColors.textBlack60,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, String hint,
      {TextInputType? keyboardType}) {
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
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SubpageHeader(
              title: 'Informations personnelles',
              subtitle: 'Gérez vos données personnelles',
            ),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            else if (_error != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: Colors.red),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _load,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('Réessayer',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              )
            else ...[
              const SizedBox(height: 24),
              ProfilePhotoPicker(
                photoUrl: _photoUrl,
                localPhotoPath: _localPhotoPath,
                newPhoto: _newPhoto,
                initials: _initials,
                onTap: _pickPhoto,
              ),
              const SizedBox(height: 12),
              Text(
                _entrepriseController.text.isNotEmpty
                    ? _entrepriseController.text
                    : '${_prenomController.text} ${_nomController.text}'.trim(),
                textAlign: TextAlign.center,
                style: GoogleFonts.workSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  height: 1.0,
                  color: AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _specialiteController.text.isNotEmpty
                    ? _specialiteController.text
                    : '',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  height: 1.0,
                  letterSpacing: 16 * 0.02,
                  color: AppColors.greyCool2,
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _field(
                      'Entreprise',
                      _entrepriseController,
                      "Nom de l'entreprise",
                    ),
                    const SizedBox(height: 16),
                    _field('Prénom', _prenomController, 'Saisir'),
                    const SizedBox(height: 16),
                    _field('Nom', _nomController, 'Saisir'),
                    const SizedBox(height: 16),
                    _field(
                      'Téléphone',
                      _telephoneController,
                      '+221 77 567 89 90',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _field(
                      'Email',
                      _emailController,
                      'example@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _field('Spécialité', _specialiteController, 'Plomberie'),
                    const SizedBox(height: 16),
                    _fieldLabel("Zone d'intervention"),
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
                          backgroundColor: AppColors.warning,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: _submitting
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Mettre à jour',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  height: 1.0,
                                  color: AppColors.white,
                                ),
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
