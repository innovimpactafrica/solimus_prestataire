import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';
import 'inscription2.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_header_logo.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});

  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _continuer() {
    final firstName = _firstNameCtrl.text.trim();
    final lastName = _lastNameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final email = _emailCtrl.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || phone.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Inscription2Page(
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          email: email,
        ),
      ),
    );
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
                    controller: _firstNameCtrl,
                    label: 'Prénom',
                    hint: 'Saisir',
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    controller: _lastNameCtrl,
                    label: 'Nom',
                    hint: 'Saisir',
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    controller: _phoneCtrl,
                    label: 'Telephone',
                    hint: '221 771234567',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    controller: _emailCtrl,
                    label: 'Email',
                    hint: 'exemple@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 48),
                  AuthPrimaryButton(
                    text: 'Continuer',
                    onPressed: _continuer,
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
                  onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
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
