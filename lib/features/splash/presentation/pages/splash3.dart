import 'package:flutter/material.dart';
import 'splash4.dart';
import '../widgets/onboarding_page_template.dart';

class Splash3 extends StatelessWidget {
  const Splash3({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      imagePath: 'assets/images/image2.png',
      title: 'Gérez vos devis et interventions',
      subtitle: 'Envoyez vos devis, démarrez les travaux et suivez chaque étape de validation.',
      activeIndex: 1,
      buttonText: 'Suivant',
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Splash4()),
        );
      },
    );
  }
}
