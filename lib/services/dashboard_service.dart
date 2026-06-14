import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dashboard_models.dart';

class DashboardService {
  static const _base = 'https://api.solimus.innovimpactdev.cloud';

  Future<DashboardData> getDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';
    final response = await http.get(
      Uri.parse('$_base/api/provider/accueil/dashboard'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return DashboardData.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Erreur chargement tableau de bord (${response.statusCode})');
  }
}
