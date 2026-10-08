import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solimus_prestataire/features/home/data/models/dashboard_models.dart';
import 'package:solimus_prestataire/features/home/data/services/dashboard_service.dart';
import 'package:solimus_prestataire/features/profil/presentation/pages/activation_requise.dart';
import 'package:solimus_prestataire/core/widgets/app_bottom_nav_bar.dart';
import 'package:solimus_prestataire/core/utils/app_colors.dart';
import '../widgets/dashboard_metric_card.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/weekly_performance_card.dart';
import '../widgets/home_top_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DashboardData? _data;
  bool _loading = true;
  bool _redirecting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await DashboardService().getDashboard();
      if (mounted) setState(() => _data = data);
    } on AbonnementInactifException {
      if (mounted) {
        setState(() => _redirecting = true);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const ActivationRequisePage()),
          (_) => false,
        );
      }
      return;
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _formatVariation(double v) {
    if (v > 0) return '+${v.toStringAsFixed(0)}%';
    if (v < 0) return '${v.toStringAsFixed(0)}%';
    return '0%';
  }

  Color _variationColor(double v) {
    if (v > 0) return AppColors.greenEmerald;
    return AppColors.slate400;
  }

  String _formatAmountShort(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }

  Widget _buildHeader() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(50),
        bottomRight: Radius.circular(50),
      ),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/header image.png',
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
          Container(
            width: double.infinity,
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.primary68,
                  AppColors.primary85,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading || _redirecting) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDashboard,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Réessayer',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    final d = _data!;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 302,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildHeader(),
                Positioned(
                  top: 183,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DashboardMetricCard(
                        iconBgColor: AppColors.infoSky,
                        iconPath: 'assets/icons/Demande.svg',
                        count: '${d.totalRequestsCount}',
                        label: 'Demandes',
                        trend: _formatVariation(d.requestsVariation),
                        trendColor: _variationColor(d.requestsVariation),
                        trendFontSize: 11,
                      ),
                      DashboardMetricCard(
                        iconBgColor: AppColors.warning,
                        iconPath: 'assets/icons/En attente.svg',
                        count: '${d.pendingQuotesCount}',
                        label: 'En attente',
                        trend: _formatVariation(d.pendingQuotesVariation),
                        trendColor: _variationColor(d.pendingQuotesVariation),
                        trendFontSize: 11,
                      ),
                      DashboardMetricCard(
                        iconBgColor: AppColors.purple,
                        iconPath: 'assets/icons/En cours.svg',
                        count: '${d.inProgressCount}',
                        label: 'En cours',
                        trend: _formatVariation(d.inProgressVariation),
                        trendColor: _variationColor(d.inProgressVariation),
                        trendFontSize: 11,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              width: 360,
              height: 119,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DashboardMetricCard(
                    iconBgColor: AppColors.successBright,
                    iconPath: 'assets/icons/Valide.svg',
                    count: '${d.validatedCount}',
                    label: 'Validé',
                    trend: _formatVariation(d.validatedVariation),
                    trendColor: _variationColor(d.validatedVariation),
                    trendFontSize: 11,
                  ),
                  DashboardStatCard(
                    iconPath: 'assets/icons/Missions.svg',
                    title: 'Missions',
                    subtitle: '${d.pendingMissionsCount} en attente',
                  ),
                  DashboardStatCard(
                    iconPath: 'assets/icons/Paiement.svg',
                    title: 'Paiements',
                    subtitle:
                        '${_formatAmountShort(d.pendingPaymentsAmount)} en attente',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          WeeklyPerformanceCard(
            variationHebdo: d.variationHebdo,
            performanceHebdo: d.performanceHebdo,
            totalRevenu: d.totalRevenu,
            moyenneParJour: d.moyenneParJour,
            totalInterventions: d.totalInterventions,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNavBar(currentTab: AppTab.home),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBody(),
          Positioned(
            top: 72,
            left: 0,
            right: 0,
            child: HomeTopBar(
              companyName: _data?.companyName.trim() ?? '',
              photoUrl: _data?.profilePhotoUrl,
            ),
          ),
        ],
      ),
    );
  }
}
