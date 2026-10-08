import 'package:solimus_prestataire/core/utils/base_url.dart';
import 'package:solimus_prestataire/features/demandes/data/models/demandes_models.dart'
    show WorkflowStep;
export 'package:solimus_prestataire/features/demandes/data/models/demandes_models.dart'
    show WorkflowStep;

class TravauxDetail {
  final int id;
  final String title;
  final String residenceName;
  final String status;
  final String statusLabel;
  final String description;
  final DateTime createdAt;
  final List<String> photoUrls;
  final String contactPhone;
  final String contactEmail;
  final List<WorkflowStep> workflowSteps;

  const TravauxDetail({
    required this.id,
    required this.title,
    required this.residenceName,
    required this.status,
    required this.statusLabel,
    required this.description,
    required this.createdAt,
    required this.photoUrls,
    required this.contactPhone,
    required this.contactEmail,
    required this.workflowSteps,
  });

  factory TravauxDetail.fromJson(Map<String, dynamic> json) => TravauxDetail(
        id: (json['id'] as num?)?.toInt() ?? 0,
        title: json['title'] as String? ?? '',
        residenceName: json['residenceName'] as String? ?? '',
        status: json['status'] as String? ?? '',
        statusLabel: json['statusLabel'] as String? ?? '',
        description: json['description'] as String? ?? '',
        createdAt: _parseTravauxDate(json['createdAt'] as String?),
        photoUrls: (json['photoUrls'] as List? ?? []).map((e) {
          final url = e as String;
          return BaseUrl.fileUrl(url);
        }).toList(),
        contactPhone: json['contactPhone'] as String? ?? '',
        contactEmail: json['contactEmail'] as String? ?? '',
        workflowSteps: (json['workflowSteps'] as List? ?? [])
            .map((e) => WorkflowStep.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

DateTime _parseTravauxDate(String? raw) {
  if (raw == null || raw.isEmpty) return DateTime.now();
  try {
    return DateTime.parse(raw);
  } catch (_) {
    return DateTime.now();
  }
}

class TravauxSummary {
  final int id;
  final String title;
  final String residenceName;
  final String status;
  final String statusLabel;
  final DateTime createdAt;

  const TravauxSummary({
    required this.id,
    required this.title,
    required this.residenceName,
    required this.status,
    required this.statusLabel,
    required this.createdAt,
  });

  factory TravauxSummary.fromJson(Map<String, dynamic> json) => TravauxSummary(
        id: (json['id'] as num?)?.toInt() ?? 0,
        title: json['title'] as String? ?? '',
        residenceName: json['residenceName'] as String? ?? '',
        status: json['status'] as String? ?? '',
        statusLabel: json['statusLabel'] as String? ?? '',
        createdAt: _parseTravauxDate(json['createdAt'] as String?),
      );
}

class TravauxPageData {
  final int pendingCount;
  final int totalPages;
  final int totalElements;
  final List<TravauxSummary> content;

  const TravauxPageData({
    required this.pendingCount,
    required this.totalPages,
    required this.totalElements,
    required this.content,
  });

  factory TravauxPageData.fromJson(Map<String, dynamic> json) {
    final works = (json['works'] as Map<String, dynamic>?) ?? {};
    final contentRaw = (works['content'] as List?) ?? [];
    return TravauxPageData(
      pendingCount: (json['pendingCount'] as num?)?.toInt() ?? 0,
      totalPages: (works['totalPages'] as num?)?.toInt() ?? 1,
      totalElements: (works['totalElements'] as num?)?.toInt() ?? 0,
      content: contentRaw
          .map((e) => TravauxSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// Backward compatibility alias
// ignore: camel_case_types
typedef TravauxPage_ = TravauxPageData;
