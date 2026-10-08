import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'wallet.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';

class VersementSuccessPage extends StatefulWidget {
  const VersementSuccessPage({super.key});

  @override
  State<VersementSuccessPage> createState() => _VersementSuccessPageState();
}

class _VersementSuccessPageState extends State<VersementSuccessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      _controller.forward().then((_) {
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, a, b) => const WalletPage(),
            transitionDuration: Duration.zero,
          ),
          (_) => false,
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/Successmark.svg',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 24),
              Text(
                'Demande de versement\nenvoyée !',
                textAlign: TextAlign.center,
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  height: 1.3,
                  letterSpacing: 0,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 300,
                child: Text(
                  'Votre demande de versement a bien été transmise. Le traitement est en cours et vous recevrez une notification dès validation.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    height: 1.5,
                    letterSpacing: 0,
                    color: AppColors.textSubtitle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
