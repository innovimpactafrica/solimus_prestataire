import 'package:solimus_prestataire/features/home/data/models/dashboard_models.dart';
import 'package:solimus_prestataire/features/home/data/services/dashboard_service.dart';

/// Repository for Dashboard/Home feature following Innov & Impact Africa Guidelines.
class DashboardRepository {
  final DashboardService _dashboardService;

  DashboardRepository({DashboardService? dashboardService})
      : _dashboardService = dashboardService ?? DashboardService();

  Future<DashboardData> getDashboard() => _dashboardService.getDashboard();
}
