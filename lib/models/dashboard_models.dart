class PerformanceHebdo {
  final String jour;
  final double montant;

  const PerformanceHebdo({required this.jour, required this.montant});

  factory PerformanceHebdo.fromJson(Map<String, dynamic> json) =>
      PerformanceHebdo(
        jour: json['jour'] as String? ?? '',
        montant: (json['montant'] as num? ?? 0).toDouble(),
      );
}

class DashboardData {
  final String companyName;
  final String role;
  final String? profilePhotoUrl;
  final int totalRequestsCount;
  final int pendingQuotesCount;
  final int inProgressCount;
  final int validatedCount;
  final double requestsVariation;
  final double pendingQuotesVariation;
  final double inProgressVariation;
  final double validatedVariation;
  final int pendingMissionsCount;
  final double pendingPaymentsAmount;
  final List<PerformanceHebdo> performanceHebdo;
  final double totalRevenu;
  final double moyenneParJour;
  final int totalInterventions;
  final double variationHebdo;

  const DashboardData({
    required this.companyName,
    required this.role,
    this.profilePhotoUrl,
    required this.totalRequestsCount,
    required this.pendingQuotesCount,
    required this.inProgressCount,
    required this.validatedCount,
    required this.requestsVariation,
    required this.pendingQuotesVariation,
    required this.inProgressVariation,
    required this.validatedVariation,
    required this.pendingMissionsCount,
    required this.pendingPaymentsAmount,
    required this.performanceHebdo,
    required this.totalRevenu,
    required this.moyenneParJour,
    required this.totalInterventions,
    required this.variationHebdo,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
        companyName: json['companyName'] as String? ?? '',
        role: json['role'] as String? ?? '',
        profilePhotoUrl: json['profilePhotoUrl'] as String?,
        totalRequestsCount: (json['totalRequestsCount'] as num? ?? 0).toInt(),
        pendingQuotesCount: (json['pendingQuotesCount'] as num? ?? 0).toInt(),
        inProgressCount: (json['inProgressCount'] as num? ?? 0).toInt(),
        validatedCount: (json['validatedCount'] as num? ?? 0).toInt(),
        requestsVariation: (json['requestsVariation'] as num? ?? 0).toDouble(),
        pendingQuotesVariation: (json['pendingQuotesVariation'] as num? ?? 0).toDouble(),
        inProgressVariation: (json['inProgressVariation'] as num? ?? 0).toDouble(),
        validatedVariation: (json['validatedVariation'] as num? ?? 0).toDouble(),
        pendingMissionsCount: (json['pendingMissionsCount'] as num? ?? 0).toInt(),
        pendingPaymentsAmount: (json['pendingPaymentsAmount'] as num? ?? 0).toDouble(),
        performanceHebdo: (json['performanceHebdo'] as List? ?? [])
            .map((e) => PerformanceHebdo.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalRevenu: (json['totalRevenu'] as num? ?? 0).toDouble(),
        moyenneParJour: (json['moyenneParJour'] as num? ?? 0).toDouble(),
        totalInterventions: (json['totalInterventions'] as num? ?? 0).toInt(),
        variationHebdo: (json['variationHebdo'] as num? ?? 0).toDouble(),
      );
}
