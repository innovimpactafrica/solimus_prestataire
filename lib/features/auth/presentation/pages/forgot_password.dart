import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/features/auth/data/models/auth_models.dart';
import 'package:solimus_prestataire/features/auth/data/services/auth_service.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_header_logo.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';
import 'otp_verification.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _identifierCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _identifierCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final identifier = _identifierCtrl.text.trim();
    if (identifier.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir votre email ou téléphone'),
        ),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await AuthService().forgotPassword(identifier);
      if (!mounted) return;
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, _, _) => OtpVerificationPage(
            email: identifier,
            mode: OtpMode.forgotPassword,
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const AuthHeaderLogo(),
          const Positioned(
            top: 62,
            left: 16,
            child: AuthBackButton(),
          ),
          Positioned(
            top: 150,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mot de passe oublié ?',
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
                  "Veuillez saisir l'adresse e-mail ou numéro de téléphone liée à votre compte.",
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
                  controller: _identifierCtrl,
                  label: 'Téléphone ou Email',
                  hint: 'Saisir',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 48),
                AuthPrimaryButton(
                  text: 'Envoyer le code',
                  isLoading: _loading,
                  onPressed: _sendCode,
                ),
              ],
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
                  'Vous vous souvenez du mot de passe ?',
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    height: 1.0,
                    color: AppColors.textPrimary60,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text(
                    'Se connecter',
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
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
