import '../../data/models/auth_models.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class LoginSubmitted extends AuthEvent {
  final String identifier;
  final String password;
  const LoginSubmitted({required this.identifier, required this.password});
}

class RegisterSubmitted extends AuthEvent {
  final RegisterRequest request;
  const RegisterSubmitted({required this.request});
}

class VerifyCodeSubmitted extends AuthEvent {
  final String email;
  final String code;
  const VerifyCodeSubmitted({required this.email, required this.code});
}

class ForgotPasswordSubmitted extends AuthEvent {
  final String emailOrPhone;
  const ForgotPasswordSubmitted({required this.emailOrPhone});
}

class ResetPasswordSubmitted extends AuthEvent {
  final String token;
  final String password;
  final String confirmPassword;
  const ResetPasswordSubmitted({
    required this.token,
    required this.password,
    required this.confirmPassword,
  });
}
