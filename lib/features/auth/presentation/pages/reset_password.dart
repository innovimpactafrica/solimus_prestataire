import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/features/auth/data/models/auth_models.dart';
import 'package:solimus_prestataire/features/auth/data/services/auth_service.dart';
import 'password_success.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_header_logo.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final OtpMode mode;
  final String? resetToken;

  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.mode,
    this.resetToken,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _loading = false;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final password = _passwordCtrl.text.trim();
    final confirm = _confirmCtrl.text.trim();

    if (password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }
    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
      return;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Le mot de passe doit comporter au moins 6 caractères')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      if (widget.mode == OtpMode.registration) {
        await AuthService().setPassword(
          widget.email,
          password,
          confirm,
        );
      } else {
        if (widget.resetToken == null) {
          throw Exception('Jeton de réinitialisation manquant.');
        }
        await AuthService().resetPassword(
          widget.resetToken!,
          password,
          confirm,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const PasswordSuccessPage(),
          transitionsBuilder: (_, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 300),
        ),
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

  Widget _buildEyeIcon({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SvgPicture.asset(
          'assets/icons/oeil masquer.svg',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRegistration = widget.mode == OtpMode.registration;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const AuthHeaderLogo(),
          const AuthBackButton(),
          Positioned(
            top: 150,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isRegistration
                      ? 'Création mot de passe'
                      : 'Réinitialisation',
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    height: 1.0,
                    letterSpacing: 24 * 0.05,
                    color: AppColors.textCharcoal,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isRegistration
                      ? 'Créez un mot de passe sécurisé pour finaliser l\'activation de votre compte.'
                      : 'Votre nouveau mot de passe doit être unique par rapport à ceux précédemment utilisés.',
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 30 / 16,
                    letterSpacing: 0,
                    color: AppColors.charcoal60,
                  ),
                ),
                const SizedBox(height: 28),
                AuthTextField(
                  controller: _passwordCtrl,
                  label: 'Nouveau mot de passe',
                  hint: '•••••••',
                  obscureText: !_newPasswordVisible,
                  suffixIcon: _buildEyeIcon(
                    onTap: () => setState(
                        () => _newPasswordVisible = !_newPasswordVisible),
                  ),
                ),
                const SizedBox(height: 20),
                AuthTextField(
                  controller: _confirmCtrl,
                  label: 'Confirmez le mot de passe',
                  hint: '•••••••',
                  obscureText: !_confirmPasswordVisible,
                  suffixIcon: _buildEyeIcon(
                    onTap: () => setState(() =>
                        _confirmPasswordVisible = !_confirmPasswordVisible),
                  ),
                ),
                const SizedBox(height: 48),
                AuthPrimaryButton(
                  text: 'Continuer',
                  isLoading: _loading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
