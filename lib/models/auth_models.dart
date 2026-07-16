enum OtpMode { registration, forgotPassword }

class RegisterRequest {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String companyName;
  final int specialtyId;
  final double latitude;
  final double longitude;
  final String interventionZone;

  const RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.companyName,
    required this.specialtyId,
    required this.latitude,
    required this.longitude,
    required this.interventionZone,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'email': email,
        'role': 'Prestataire',
        'companyName': companyName,
        'specialtyId': specialtyId,
        'latitude': latitude,
        'longitude': longitude,
        'interventionZone': interventionZone,
      };
}

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final bool otpRequired;

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.otpRequired,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        accessToken: json['accessToken'] as String? ?? '',
        refreshToken: json['refreshToken'] as String? ?? '',
        otpRequired: json['otpRequired'] as bool? ?? false,
      );
}
