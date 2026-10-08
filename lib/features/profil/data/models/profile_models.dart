DateTime _parseProfileDate(String? raw) {
  if (raw == null || raw.isEmpty) return DateTime.now();
  if (raw.contains('T')) return DateTime.parse(raw);
  final parts = raw.split('/');
  if (parts.length == 3) {
    return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
  }
  return DateTime.parse(raw);
}

class PaymentInitResponse {
  final bool success;
  final String transactionReference;
  final int amountToPay;
  final String paymentUrl;

  const PaymentInitResponse({
    required this.success,
    required this.transactionReference,
    required this.amountToPay,
    required this.paymentUrl,
  });

  factory PaymentInitResponse.fromJson(Map<String, dynamic> json) => PaymentInitResponse(
        success: json['success'] as bool? ?? false,
        transactionReference: json['transactionReference'] as String? ?? '',
        amountToPay: (json['amountToPay'] as num?)?.toInt() ?? 0,
        paymentUrl: json['paymentUrl'] as String? ?? '',
      );
}

class PaymentHistory {
  final String planName;
  final String status;
  final String reference;
  final double amount;
  final String paymentMethod;
  final DateTime date;

  const PaymentHistory({
    required this.planName,
    required this.status,
    required this.reference,
    required this.amount,
    required this.paymentMethod,
    required this.date,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) => PaymentHistory(
        planName: json['planName'] as String? ?? '',
        status: json['status'] as String? ?? '',
        reference: json['reference'] as String? ?? '',
        amount: (json['amount'] as num?)?.toDouble() ?? 0,
        paymentMethod: json['paymentMethod'] as String? ?? '',
        date: _parseProfileDate(json['date'] as String?),
      );
}

class SubscriptionInfo {
  final String planName;
  final bool active;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final String paymentMethod;
  final List<PaymentHistory> paymentHistory;
  final int totalHistoryPages;
  final int totalHistoryElements;

  const SubscriptionInfo({
    required this.planName,
    required this.active,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.paymentMethod,
    required this.paymentHistory,
    required this.totalHistoryPages,
    required this.totalHistoryElements,
  });

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    final history = (json['paymentHistory'] as Map<String, dynamic>?) ?? {};
    return SubscriptionInfo(
      planName: json['planName'] as String? ?? '',
      active: json['active'] as bool? ?? false,
      status: json['status'] as String? ?? '',
      startDate: _parseProfileDate(json['startDate'] as String?),
      endDate: _parseProfileDate(json['endDate'] as String?),
      paymentMethod: json['paymentMethod'] as String? ?? '',
      totalHistoryPages: (history['totalPages'] as num?)?.toInt() ?? 0,
      totalHistoryElements: (history['totalElements'] as num?)?.toInt() ?? 0,
      paymentHistory: (history['content'] as List? ?? [])
          .map((e) => PaymentHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProviderProfile {
  final String companyName;
  final String specialtyName;
  final bool available;
  final String email;
  final String phone;
  final String language;
  final DateTime memberSince;
  final String? profilePhotoUrl;

  const ProviderProfile({
    required this.companyName,
    required this.specialtyName,
    required this.available,
    required this.email,
    required this.phone,
    required this.language,
    required this.memberSince,
    this.profilePhotoUrl,
  });

  String get memberSinceLabel {
    const months = ['', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];
    return 'Membre depuis ${months[memberSince.month]} ${memberSince.year}';
  }

  static String _extractString(dynamic v) {
    if (v == null) return '';
    if (v is String) return v;
    if (v is Map) return (v['name'] ?? v['label'] ?? v['value'] ?? '').toString();
    return v.toString();
  }

  factory ProviderProfile.fromJson(Map<String, dynamic> json) => ProviderProfile(
        companyName: _extractString(json['companyName']),
        specialtyName: _extractString(json['specialtyName'] ?? json['specialty']),
        available: json['available'] as bool? ?? json['isAvailable'] as bool? ?? true,
        email: _extractString(json['email']),
        phone: _extractString(json['phone'] ?? json['phoneNumber']),
        language: _extractString(json['language'] ?? json['languages']),
        memberSince: _parseProfileDate((json['memberSince'] ?? json['createdAt'] ?? json['member_since']) as String?),
        profilePhotoUrl: json['profilePhotoUrl'] as String? ?? json['photoUrl'] as String? ?? json['avatar'] as String?,
      );
}

class ProfileInfo {
  final String companyName;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String specialtyName;
  final String interventionZone;
  final double? latitude;
  final double? longitude;
  final String? profilePhotoUrl;

  const ProfileInfo({
    required this.companyName,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.specialtyName,
    required this.interventionZone,
    this.latitude,
    this.longitude,
    this.profilePhotoUrl,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory ProfileInfo.fromJson(Map<String, dynamic> json) => ProfileInfo(
        companyName: json['companyName'] as String? ?? '',
        firstName: json['firstName'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        email: json['email'] as String? ?? '',
        specialtyName: json['specialtyName'] as String? ?? '',
        interventionZone: json['interventionZone'] as String? ??
            json['intervention_zone'] as String? ??
            json['zone'] as String? ?? '',
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        profilePhotoUrl: json['profilePhotoUrl'] as String?,
      );
}
