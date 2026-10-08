import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/features/auth/data/services/auth_service.dart';
import 'package:solimus_prestataire/features/home/presentation/pages/home.dart';
import 'package:solimus_prestataire/features/profil/presentation/pages/activation_requise.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_header_logo.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';
import 'forgot_password.dart';
import 'inscription.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _identifierCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _passwordVisible = false;
  bool _loading = false;

  @override
  void dispose() {
    _identifierCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final identifier = _identifierCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    if (identifier.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
        ),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final result = await AuthService().login(identifier, password);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (_, _, _) => result.otpRequired
              ? const ActivationRequisePage()
              : const HomePage(),
          transitionsBuilder: (_, anim, _, child) => FadeTransition(
            opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 300),
        ),
        (_) => false,
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
                  'CONNEXION',
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
                  controller: _identifierCtrl,
                  label: 'Identifiant',
                  hint: 'Saisir',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                AuthTextField(
                  controller: _passwordCtrl,
                  label: 'Mot de passe',
                  hint: '•••••••',
                  obscureText: !_passwordVisible,
                  suffixIcon: GestureDetector(
                    onTap: () => setState(
                      () => _passwordVisible = !_passwordVisible,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        'assets/icons/oeil masquer.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (_, _, _) =>
                              const ForgotPasswordPage(),
                          transitionsBuilder: (_, anim, _, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration:
                              const Duration(milliseconds: 300),
                        ),
                      );
                    },
                    child: Text(
                      'Mot de passe oublié ?',
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.0,
                        letterSpacing: 0,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                AuthPrimaryButton(
                  text: 'Se connecter',
                  isLoading: _loading,
                  onPressed: _login,
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
                  "Vous n'avez pas de compte ?",
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.0,
                    letterSpacing: 0,
                    color: AppColors.textPrimary60,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const InscriptionPage(),
                    ),
                  ),
                  child: Text(
                    "S'inscrire",
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 1.0,
                      letterSpacing: 0,
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
