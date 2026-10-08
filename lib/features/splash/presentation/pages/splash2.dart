import 'package:flutter/material.dart';
import 'splash3.dart';
import '../widgets/onboarding_page_template.dart';

class Splash2 extends StatelessWidget {
  const Splash2({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      imagePath: 'assets/images/image1.png',
      title: 'Recevez vos interventions rapidement',
      subtitle: 'Soyez notifié dès qu’un client près de chez vous a besoin de vos services.',
      activeIndex: 0,
      buttonText: 'Suivant',
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Splash3()),
        );
      },
    );
  }
}
