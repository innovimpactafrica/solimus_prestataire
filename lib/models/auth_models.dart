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
  final String email;
  final String role;
  final int id;
  final String firstName;
  final String lastName;
  final String status;
  final bool otpRequired;

  const LoginResponse({
    required this.accessToken,
    required this.email,
    required this.role,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.status,
    required this.otpRequired,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        accessToken: json['accessToken'] as String,
        email: json['email'] as String,
        role: json['role'] as String,
        id: json['id'] as int,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        status: json['status'] as String,
        otpRequired: json['otpRequired'] as bool,
      );
}
