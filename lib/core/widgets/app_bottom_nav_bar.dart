import 'package:flutter/material.dart';
import 'nav_item.dart';
import '../utils/app_colors.dart';
import '../../features/home/presentation/pages/home.dart';
import '../../features/demandes/presentation/pages/demandes.dart';
import '../../features/travaux/presentation/pages/travaux.dart';
import '../../features/wallet/presentation/pages/wallet.dart';
import '../../features/profil/presentation/pages/profil.dart';

enum AppTab { home, demandes, travaux, wallet, profil }

class AppBottomNavBar extends StatelessWidget {
  final AppTab currentTab;

  const AppBottomNavBar({
    super.key,
    required this.currentTab,
  });

  void _navigateTo(BuildContext context, Widget target) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (c, a, s) => target,
        transitionsBuilder: (c, anim, s, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black10,
            offset: Offset(0, -2),
            blurRadius: 24,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: NavItem(
                  iconPath: 'assets/icons/accueil.svg',
                  activeIconPath: 'assets/icons/accueil_active.svg',
                  label: 'Accueil',
                  isActive: currentTab == AppTab.home,
                  onTap: currentTab == AppTab.home
                      ? null
                      : () => _navigateTo(context, const HomePage()),
                ),
              ),
              Expanded(
                child: NavItem(
                  iconPath: 'assets/icons/demande nav.svg',
                  activeIconPath: 'assets/icons/demande_active.svg',
                  label: 'Demandes',
                  isActive: currentTab == AppTab.demandes,
                  onTap: currentTab == AppTab.demandes
                      ? null
                      : () => _navigateTo(context, const DemandesPage()),
                ),
              ),
              Expanded(
                child: NavItem(
                  iconPath: 'assets/icons/travaux.svg',
                  activeIconPath: 'assets/icons/travaux_active.svg',
                  label: 'Travaux',
                  isActive: currentTab == AppTab.travaux,
                  onTap: currentTab == AppTab.travaux
                      ? null
                      : () => _navigateTo(context, const TravauxPage()),
                ),
              ),
              Expanded(
                child: NavItem(
                  iconPath: 'assets/icons/wallet.svg',
                  activeIconPath: 'assets/icons/wallet_active.svg',
                  label: 'Wallet',
                  isActive: currentTab == AppTab.wallet,
                  onTap: currentTab == AppTab.wallet
                      ? null
                      : () => _navigateTo(context, const WalletPage()),
                ),
              ),
              Expanded(
                child: NavItem(
                  iconPath: 'assets/icons/profil.svg',
                  activeIconPath: 'assets/icons/profil_active.svg',
                  label: 'Mon profil',
                  isActive: currentTab == AppTab.profil,
                  onTap: currentTab == AppTab.profil
                      ? null
                      : () => _navigateTo(context, const ProfilPage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
