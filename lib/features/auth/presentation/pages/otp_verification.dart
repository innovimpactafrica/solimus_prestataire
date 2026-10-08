import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/features/auth/data/models/auth_models.dart';
import 'package:solimus_prestataire/features/auth/data/services/auth_service.dart';
import 'reset_password.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_header_logo.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/otp_input_box.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;
  final OtpMode mode;

  const OtpVerificationPage({
    super.key,
    required this.email,
    required this.mode,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _loading = false;
  bool _resending = false;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _maskedEmail {
    final parts = widget.email.split('@');
    if (parts.length != 2) return widget.email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 3) return '${name[0]}***@$domain';
    return '${name.substring(0, 3)}***@$domain';
  }

  Future<void> _verify() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer le code à 4 chiffres')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      String? resetToken;
      if (widget.mode == OtpMode.forgotPassword) {
        resetToken = await AuthService().verifyResetCode(widget.email, code);
      } else {
        await AuthService().verifyCode(widget.email, code);
      }
      if (!mounted) return;
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, _, _) => ResetPasswordPage(
            email: widget.email,
            mode: widget.mode,
            resetToken: resetToken,
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

  Future<void> _resend() async {
    setState(() => _resending = true);
    try {
      final message = widget.mode == OtpMode.forgotPassword
          ? await AuthService().forgotPassword(widget.email)
          : await AuthService().resendActivationLink(widget.email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
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
      if (mounted) setState(() => _resending = false);
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
          Positioned(
            top: 150,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vérification OTP',
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
                  "Entrez le code de vérification envoyé à $_maskedEmail.",
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 30 / 16,
                    letterSpacing: 0,
                    color: AppColors.charcoal60,
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    4,
                    (index) => OtpInputBox(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        if (index == 3 && value.isNotEmpty) {
                          _verify();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                AuthPrimaryButton(
                  text: 'Vérifier',
                  isLoading: _loading,
                  onPressed: _verify,
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
                  "Vous n'avez pas reçu le code ?",
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    height: 1.0,
                    color: AppColors.textPrimary60,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: _resending ? null : _resend,
                  child: _resending
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.warning,
                          ),
                        )
                      : Text(
                          'Renvoyer',
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
