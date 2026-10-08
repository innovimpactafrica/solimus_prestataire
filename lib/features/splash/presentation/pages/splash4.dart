import 'package:flutter/material.dart';
import 'package:solimus_prestataire/features/auth/presentation/pages/login.dart';
import '../widgets/onboarding_page_template.dart';

class Splash4 extends StatelessWidget {
  const Splash4({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      imagePath: 'assets/images/image3.png',
      title: 'Suivez vos paiements facilement',
      subtitle: 'Consultez vos revenus et demandez vos versements via Wave ou Orange Money.',
      activeIndex: 2,
      buttonText: 'Commencer',
      onNext: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
    );
  }
}
