import 'package:solimus_prestataire/features/auth/data/models/auth_models.dart';
import '../services/auth_service.dart';

/// Repository for Auth feature following Innov & Impact Africa Guidelines.
class AuthRepository {
  final AuthService _authService;

  AuthRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  Future<String> register(RegisterRequest req) => _authService.register(req);

  Future<LoginResponse> login(String identifier, String password) =>
      _authService.login(identifier, password);

  Future<String> verifyCode(String email, String code) =>
      _authService.verifyCode(email, code);

  Future<String> forgotPassword(String emailOrPhone) =>
      _authService.forgotPassword(emailOrPhone);

  Future<String> setPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) =>
      _authService.setPassword(email, password, confirmPassword);

  Future<String> resetPassword({
    required String token,
    required String password,
    required String confirmPassword,
  }) =>
      _authService.resetPassword(token, password, confirmPassword);
}
