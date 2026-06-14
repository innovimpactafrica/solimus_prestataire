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
  final String reference;
  final String plan;
  final double montant;
  final DateTime date;
  final String moyenPaiement;
  final String statut;

  const PaymentHistory({
    required this.reference,
    required this.plan,
    required this.montant,
    required this.date,
    required this.moyenPaiement,
    required this.statut,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) => PaymentHistory(
        reference: json['reference'] as String? ?? '',
        plan: json['plan'] as String? ?? '',
        montant: (json['montant'] as num?)?.toDouble() ?? 0,
        date: _parseProfileDate(json['date'] as String?),
        moyenPaiement: json['moyenPaiement'] as String? ?? '',
        statut: json['statut'] as String? ?? '',
      );
}

class SubscriptionInfo {
  final String plan;
  final String status;
  final bool active;
  final DateTime dateActivation;
  final DateTime dateExpiration;
  final String moyenPaiement;
  final bool renouvellementAuto;
  final List<String> avantages;
  final List<PaymentHistory> historiquePaiements;

  const SubscriptionInfo({
    required this.plan,
    required this.status,
    required this.active,
    required this.dateActivation,
    required this.dateExpiration,
    required this.moyenPaiement,
    required this.renouvellementAuto,
    required this.avantages,
    required this.historiquePaiements,
  });

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) => SubscriptionInfo(
        plan: json['plan'] as String? ?? '',
        status: json['status'] as String? ?? '',
        active: json['active'] as bool? ?? false,
        dateActivation: _parseProfileDate(json['dateActivation'] as String?),
        dateExpiration: _parseProfileDate(json['dateExpiration'] as String?),
        moyenPaiement: json['moyenPaiement'] as String? ?? '',
        renouvellementAuto: json['renouvellementAuto'] as bool? ?? false,
        avantages: (json['avantages'] as List? ?? []).map((e) => e?.toString() ?? '').where((e) => e.isNotEmpty).toList(),
        historiquePaiements: (json['historiquePaiements'] as List? ?? [])
            .map((e) => PaymentHistory.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
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
