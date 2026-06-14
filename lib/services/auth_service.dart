import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_models.dart';

class AuthService {
  static const _base = 'https://api.solimus.innovimpactdev.cloud';

  Future<String> register(RegisterRequest req) async {
    final response = await http.post(
      Uri.parse('$_base/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(req.toJson()),
    );
    if (response.statusCode == 201) return response.body;
    throw Exception(_extractMessage(response));
  }

  Future<LoginResponse> login(String identifier, String password) async {
    final response = await http.post(
      Uri.parse('$_base/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'identifier': identifier, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final result = LoginResponse.fromJson(data);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', result.accessToken);
      await prefs.setInt('userId', result.id);
      await prefs.setString('userEmail', result.email);
      await prefs.setString('firstName', result.firstName);
      await prefs.setString('lastName', result.lastName);
      await prefs.setString('role', result.role);
      await prefs.setString('status', result.status);
      return result;
    }
    throw Exception(_extractMessage(response));
  }

  Future<String> verifyCode(String email, String code) async {
    final response = await http.post(
      Uri.parse('$_base/api/auth/verify-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );
    if (response.statusCode == 200) return response.body;
    throw Exception(_extractMessage(response));
  }

  Future<String> setPassword(
      String email, String password, String confirmPassword) async {
    final response = await http.post(
      Uri.parse('$_base/api/auth/set-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      }),
    );
    if (response.statusCode == 200) return response.body;
    throw Exception(_extractMessage(response));
  }

  Future<String> resetPassword(
      String token, String password, String confirmPassword) async {
    final response = await http.post(
      Uri.parse('$_base/api/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': token,
        'newPassword': password,
        'confirmPassword': confirmPassword,
      }),
    );
    if (response.statusCode == 200) return response.body;
    throw Exception(_extractMessage(response));
  }

  Future<String> forgotPassword(String emailOrPhone) async {
    final response = await http.post(
      Uri.parse('$_base/api/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'emailOrPhone': emailOrPhone}),
    );
    if (response.statusCode == 200) return response.body;
    throw Exception(_extractMessage(response));
  }

  // Retourne le token UUID nécessaire pour reset-password
  Future<String> verifyResetCode(String emailOrPhone, String code) async {
    final response = await http.post(
      Uri.parse('$_base/api/auth/verify-reset-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'emailOrPhone': emailOrPhone, 'code': code}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['token'] as String;
    }
    throw Exception(_extractMessage(response));
  }

  Future<String> resendActivationLink(String email) async {
    final response = await http.post(
      Uri.parse('$_base/api/auth/resend-activation-link'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    throw Exception(_extractMessage(response));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';
    try {
      await http.post(
        Uri.parse('$_base/api/auth/logout'),
        headers: {'Authorization': 'Bearer $token'},
      );
    } catch (_) {}
    await prefs.clear();
  }

  String _extractMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['message'] as String? ?? response.body;
    } catch (_) {
      return response.body;
    }
  }
}
