import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home.dart';
import '../../services/user_session.dart';
import '../demandes/demandes.dart';
import '../wallet/wallet.dart';
import '../travaux/travaux.dart';
import '../../widgets/nav_item.dart';
import 'informations_personnelles.dart';
import 'mes_devis.dart';
import 'mon_abonnement.dart';
import '../../models/profile_models.dart' show ProviderProfile;
import '../../services/auth_service.dart';
import '../../services/demandes_service.dart';
import '../../screens/auth/login.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool _notificationsEnabled = true;
  ProviderProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await DemandesService().getProfile();
      if (mounted) setState(() => _profile = profile);
      return;
    } catch (_) {}

    try {
      final info = await DemandesService().getPersonalInfo();
      if (mounted) {
        setState(() {
          _profile = ProviderProfile(
            companyName: info.companyName,
            specialtyName: info.specialtyName,
            available: true,
            email: info.email,
            phone: info.phone,
            language: '',
            memberSince: DateTime.now(),
            profilePhotoUrl: info.profilePhotoUrl,
          );
        });
      }
    } catch (_) {}
  }

  Widget _infoRow(String iconPath, String text) {
    return Row(
      children: [
        SvgPicture.asset(iconPath, width: 16, height: 16),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            height: 16 / 12,
            letterSpacing: 0,
            color: const Color(0xE5FFFFFF),
          ),
        ),
      ],
    );
  }

  String _initials() {
    final name = _profile?.companyName.trim() ?? '';
    if (name.isNotEmpty) {
      final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
      if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  Widget _defaultAvatar() {
    return Container(
      width: 64,
      height: 64,
      color: const Color(0x33FFFFFF),
      child: Center(
        child: Text(
          _initials(),
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _menuCard({required Widget child}) {
    return Container(
      width: 365,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }

  Widget _menuItem({
    required String iconPath,
    required String title,
    String? subtitle,
    required Color iconBgColor,
    Widget? trailing,
    VoidCallback? onTap,
    Color titleColor = const Color(0xFF2F3542),
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 365,
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        decoration: const BoxDecoration(),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(iconPath, width: 24, height: 24),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      height: 1.0,
                      letterSpacing: 0,
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        height: 16 / 12,
                        letterSpacing: 0,
                        color: const Color(0xFF6A7282),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F4),
      bottomNavigationBar: Builder(
        builder: (ctx) => Container(
          height: 75,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0xFF6F675E),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            boxShadow: [
              BoxShadow(color: Color(0x1A000000), offset: Offset(0, -1), blurRadius: 32),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NavItem(iconPath: 'assets/icons/accueil.svg', label: 'Accueil',
                onTap: () => Navigator.of(ctx).pushReplacement(PageRouteBuilder(
                  pageBuilder: (c, a, s) => const HomePage(),
                  transitionsBuilder: (c, anim, s, child) => FadeTransition(opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
                  transitionDuration: const Duration(milliseconds: 300),
                ))),
              const SizedBox(width: 30),
              NavItem(iconPath: 'assets/icons/demande nav.svg', label: 'Demandes',
                onTap: () => Navigator.of(ctx).pushReplacement(PageRouteBuilder(
                  pageBuilder: (c, a, s) => const DemandesPage(),
                  transitionsBuilder: (c, anim, s, child) => FadeTransition(opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
                  transitionDuration: const Duration(milliseconds: 300),
                ))),
              const SizedBox(width: 30),
              NavItem(iconPath: 'assets/icons/travaux.svg', label: 'Travaux',
                onTap: () => Navigator.of(ctx).pushReplacement(PageRouteBuilder(
                  pageBuilder: (c, a, s) => const TravauxPage(),
                  transitionsBuilder: (c, anim, s, child) => FadeTransition(opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
                  transitionDuration: const Duration(milliseconds: 300),
                ))),
              const SizedBox(width: 30),
              NavItem(iconPath: 'assets/icons/wallet.svg', label: 'Wallet',
                onTap: () => Navigator.of(ctx).pushReplacement(PageRouteBuilder(
                  pageBuilder: (c, a, s) => const WalletPage(),
                  transitionsBuilder: (c, anim, s, child) => FadeTransition(opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
                  transitionDuration: const Duration(milliseconds: 300),
                ))),
              const SizedBox(width: 30),
              const NavItem(iconPath: 'assets/icons/profil.svg', label: 'Mon profil', isActive: true),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            SizedBox(
              height: 135,
              child: Stack(
                children: [
                  Container(width: double.infinity, height: 135, color: const Color(0xFF6F675E)),
                  Positioned(
                    top: 72,
                    left: 24,
                    child: Text(
                      'Profil',
                      style: GoogleFonts.jost(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        height: 25 / 24,
                        letterSpacing: 24 * 0.005,
                        color: const Color(0xFFFDFDFD),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Carte profil
            Container(
              width: 365,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6F675E), Color(0xB36F675E)],
                  stops: [0.0, 1.0],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar + nom + badges
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ValueListenableBuilder<String?>(
                        valueListenable: UserSession.instance.localPhotoPath,
                        builder: (_, localPath, __) => ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(11),
                              child: localPath != null
                                  ? Image.file(
                                      File(localPath),
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _defaultAvatar(),
                                    )
                                  : _defaultAvatar(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _profile?.companyName.isNotEmpty == true
                                ? _profile!.companyName
                                : '···',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              height: 28 / 20,
                              letterSpacing: -0.45,
                              color: const Color(0xFFFFFFFF),
                            ),
                          ),
                          const SizedBox(height: 9),
                          Row(
                            children: [
                              if (_profile?.specialtyName.isNotEmpty == true)
                                Container(
                                  height: 24,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0x33FFFFFF),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _profile!.specialtyName,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        height: 16 / 12,
                                        letterSpacing: 0,
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _profile?.available != false
                                      ? const Color(0xFF05DF72)
                                      : const Color(0xFFFD3C4A),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _profile?.available != false ? 'Disponible' : 'Indisponible',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  height: 16 / 12,
                                  letterSpacing: 0,
                                  color: const Color(0xE5FFFFFF),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Infos de contact
                  if (_profile?.email.isNotEmpty == true) ...[
                    _infoRow('assets/icons/mail.svg', _profile!.email),
                    const SizedBox(height: 10),
                  ],
                  if (_profile?.phone.isNotEmpty == true) ...[
                    _infoRow('assets/icons/phone.svg', _profile!.phone),
                    const SizedBox(height: 10),
                  ],
                  if (_profile?.language.isNotEmpty == true) ...[
                    _infoRow('assets/icons/langue.svg', _profile!.language),
                    const SizedBox(height: 10),
                  ],
                  _infoRow('assets/icons/calen.svg', _profile?.memberSinceLabel ?? 'Membre depuis Janvier 2026'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Menu items
            _menuCard(child: _menuItem(
              iconPath: 'assets/icons/edit.svg',
              title: 'Informations personnelles',
              iconBgColor: const Color(0x1A6F675E),
              trailing: const Icon(Icons.chevron_right, color: Color(0xFF2F3542), size: 20),
              onTap: () async {
                final result = await Navigator.of(context).push<Map<String, dynamic>>(PageRouteBuilder(
                  pageBuilder: (c, a, s) => const InformationsPersonnellesPage(),
                  transitionsBuilder: (c, anim, s, child) => FadeTransition(
                    opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
                  transitionDuration: const Duration(milliseconds: 300),
                ));
                if (result?['updated'] == true) {
                  await _loadProfile();
                }
              },
            )),
            const SizedBox(height: 9),
            _menuCard(child: _menuItem(
              iconPath: 'assets/icons/devis.svg',
              title: 'Mes devis',
              iconBgColor: const Color(0x1A6F675E),
              trailing: const Icon(Icons.chevron_right, color: Color(0xFF2F3542), size: 20),
              onTap: () => Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (c, a, s) => const MesDevisPage(),
                transitionsBuilder: (c, anim, s, child) => FadeTransition(
                  opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
                transitionDuration: const Duration(milliseconds: 300),
              )),
            )),
            const SizedBox(height: 9),
            _menuCard(child: _menuItem(
              iconPath: 'assets/icons/souscrip.svg',
              title: 'Mon abonnement',
              iconBgColor: const Color(0x1A6F675E),
              trailing: const Icon(Icons.chevron_right, color: Color(0xFF2F3542), size: 20),
              onTap: () => Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (c, a, s) => const MonAbonnementPage(),
                transitionsBuilder: (c, anim, s, child) => FadeTransition(
                  opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
                transitionDuration: const Duration(milliseconds: 300),
              )),
            )),
            const SizedBox(height: 9),
            _menuCard(child: _menuItem(
              iconPath: 'assets/icons/notif.svg',
              title: 'Notifications',
              subtitle: 'Alertes et rappels',
              iconBgColor: const Color(0x1A6F675E),
              trailing: GestureDetector(
                onTap: () => setState(() => _notificationsEnabled = !_notificationsEnabled),
                child: SvgPicture.asset(
                  'assets/icons/Button.svg',
                  width: 48,
                  height: 24,
                  colorFilter: _notificationsEnabled
                      ? null
                      : const ColorFilter.mode(Color(0xFFD1D5DB), BlendMode.srcIn),
                ),
              ),
            )),
            const SizedBox(height: 9),
            _menuCard(child: _menuItem(
              iconPath: 'assets/icons/logout.svg',
              title: 'Se déconnecter',
              iconBgColor: const Color(0x0DFF6B6B),
              titleColor: const Color(0xFFFF6B6B),
              trailing: const SizedBox.shrink(),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Déconnexion', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                    content: Text('Voulez-vous vraiment vous déconnecter ?', style: GoogleFonts.inter()),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text('Annuler', style: GoogleFonts.inter(color: const Color(0xFF6F675E))),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: Text('Déconnecter', style: GoogleFonts.inter(color: const Color(0xFFFF6B6B), fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                );
                if (confirm == true && mounted) {
                  await AuthService().logout();
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      PageRouteBuilder(
                        pageBuilder: (c, a, s) => const LoginPage(),
                        transitionsBuilder: (c, anim, s, child) => FadeTransition(
                          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child),
                        transitionDuration: const Duration(milliseconds: 300),
                      ),
                      (route) => false,
                    );
                  }
                }
              },
            )),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
