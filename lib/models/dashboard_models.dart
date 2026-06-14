class PerformanceHebdo {
  final String jour;
  final double montant;

  const PerformanceHebdo({required this.jour, required this.montant});

  factory PerformanceHebdo.fromJson(Map<String, dynamic> json) =>
      PerformanceHebdo(
        jour: json['jour'] as String,
        montant: (json['montant'] as num).toDouble(),
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
        totalRequestsCount: (json['totalRequestsCount'] as num).toInt(),
        pendingQuotesCount: (json['pendingQuotesCount'] as num).toInt(),
        inProgressCount: (json['inProgressCount'] as num).toInt(),
        validatedCount: (json['validatedCount'] as num).toInt(),
        requestsVariation: (json['requestsVariation'] as num).toDouble(),
        pendingQuotesVariation:
            (json['pendingQuotesVariation'] as num).toDouble(),
        inProgressVariation: (json['inProgressVariation'] as num).toDouble(),
        validatedVariation: (json['validatedVariation'] as num).toDouble(),
        pendingMissionsCount: (json['pendingMissionsCount'] as num).toInt(),
        pendingPaymentsAmount:
            (json['pendingPaymentsAmount'] as num).toDouble(),
        performanceHebdo: (json['performanceHebdo'] as List)
            .map((e) => PerformanceHebdo.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalRevenu: (json['totalRevenu'] as num).toDouble(),
        moyenneParJour: (json['moyenneParJour'] as num).toDouble(),
        totalInterventions: (json['totalInterventions'] as num).toInt(),
        variationHebdo: (json['variationHebdo'] as num).toDouble(),
      );
}
