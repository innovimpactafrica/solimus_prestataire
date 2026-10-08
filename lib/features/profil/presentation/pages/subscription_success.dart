import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import 'package:solimus_prestataire/features/home/presentation/pages/home.dart';

class SubscriptionSuccessPage extends StatefulWidget {
  const SubscriptionSuccessPage({super.key});

  @override
  State<SubscriptionSuccessPage> createState() =>
      _SubscriptionSuccessPageState();
}

class _SubscriptionSuccessPageState extends State<SubscriptionSuccessPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomePage()),
          (_) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: AppColors.green,
                  width: 0,
                ),
              ),
              child: const Icon(Icons.verified, color: Colors.white, size: 50),
            ),
            const SizedBox(height: 24),
            Text(
              'Abonnement activé avec succès !',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppColors.black1C,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Bienvenu dans votre espace personnel',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
