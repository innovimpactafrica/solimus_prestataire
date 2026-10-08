import 'package:solimus_prestataire/core/utils/base_url.dart';

DateTime _parseDate(String raw) {
  if (raw.isEmpty) return DateTime.now();
  try {
    if (raw.contains('T') || raw.contains('-')) {
      return DateTime.parse(raw);
    }
    // Format API : "22/05/2026 09:14"
    final parts = raw.split(' ');
    final dateParts = parts[0].split('/');
    if (dateParts.length < 3) return DateTime.now();
    final timeParts = parts.length > 1 ? parts[1].split(':') : ['0', '0'];
    return DateTime(
      int.parse(dateParts[2]),
      int.parse(dateParts[1]),
      int.parse(dateParts[0]),
      int.parse(timeParts[0]),
      timeParts.length > 1 ? int.parse(timeParts[1]) : 0,
    );
  } catch (_) {
    return DateTime.now();
  }
}

class DemandeComment {
  final int id;
  final String content;
  final int authorId;
  final String authorName;
  final DateTime createdAt;

  const DemandeComment({
    required this.id,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
  });

  factory DemandeComment.fromJson(Map<String, dynamic> json) => DemandeComment(
        id: (json['id'] as num?)?.toInt() ?? 0,
        content: json['content'] as String? ?? '',
        authorId: (json['authorId'] as num?)?.toInt() ?? 0,
        authorName: json['authorName'] as String? ?? '',
        createdAt: json['createdAt'] != null ? _parseDate(json['createdAt'] as String) : DateTime.now(),
      );
}

class DemandeHistory {
  final int id;
  final String status;
  final DateTime createdAt;

  const DemandeHistory({
    required this.id,
    required this.status,
    required this.createdAt,
  });

  factory DemandeHistory.fromJson(Map<String, dynamic> json) => DemandeHistory(
        id: (json['id'] as num?)?.toInt() ?? 0,
        status: json['status'] as String? ?? '',
        createdAt: json['createdAt'] != null ? _parseDate(json['createdAt'] as String) : DateTime.now(),
      );
}

class WorkflowStep {
  final String label;
  final bool completed;
  final DateTime? date;

  const WorkflowStep({
    required this.label,
    required this.completed,
    this.date,
  });

  factory WorkflowStep.fromJson(Map<String, dynamic> json) => WorkflowStep(
        label: json['label'] as String? ?? '',
        completed: json['completed'] as bool? ?? false,
        date: json['date'] != null ? _parseDate(json['date'] as String) : null,
      );
}

class DemandeRequest {
  final int id;
  final String title;
  final String description;
  final String status;
  final String statusLabel;
  final String residenceName;
  final String contactPhone;
  final String contactEmail;
  final List<String> photoUrls;
  final List<WorkflowStep> workflowSteps;
  final DateTime createdAt;

  const DemandeRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.statusLabel,
    required this.residenceName,
    required this.contactPhone,
    required this.contactEmail,
    required this.photoUrls,
    required this.workflowSteps,
    required this.createdAt,
  });

  factory DemandeRequest.fromJson(Map<String, dynamic> json) => DemandeRequest(
        id: (json['id'] as num?)?.toInt() ?? 0,
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        status: json['status'] as String? ?? '',
        statusLabel: json['statusLabel'] as String? ?? _statusLabel(json['status'] as String? ?? ''),
        residenceName: json['residenceName'] as String? ?? '',
        contactPhone: json['contactPhone'] as String? ?? '',
        contactEmail: json['contactEmail'] as String? ?? '',
        photoUrls: (json['photoUrls'] as List? ?? []).map((e) {
          final url = e as String;
          return BaseUrl.fileUrl(url);
        }).toList(),
        workflowSteps: (json['workflowSteps'] as List? ?? [])
            .map((e) => WorkflowStep.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: json['createdAt'] != null ? _parseDate(json['createdAt'] as String) : DateTime.now(),
      );
}

String _statusLabel(String status) {
  switch (status) {
    case 'PENDING':           return 'Signalé';
    case 'SYNDIC_ASSIGNED':   return 'Signalé';
    case 'QUOTE_SENT':        return 'Devis';
    case 'SYNDIC_VALIDATED':  return 'En cours';
    case 'STARTED':           return 'Démarré';
    case 'FINISHED':          return 'Terminé';
    case 'FINAL_VALIDATION':  return 'Validé';
    case 'CANCELLED':         return 'Annulé';
    default:                  return status;
  }
}

class DemandeRequestSummary {
  final int id;
  final String title;
  final String residenceName;
  final String status;
  final String statusLabel;
  final DateTime createdAt;
  final List<String> photoUrls;

  const DemandeRequestSummary({
    required this.id,
    required this.title,
    required this.residenceName,
    required this.status,
    required this.statusLabel,
    required this.createdAt,
    required this.photoUrls,
  });

  factory DemandeRequestSummary.fromJson(Map<String, dynamic> json) =>
      DemandeRequestSummary(
        id: (json['id'] as num?)?.toInt() ?? 0,
        title: json['title'] as String? ?? '',
        residenceName: json['residenceName'] as String? ?? '',
        status: json['status'] as String? ?? '',
        statusLabel: json['statusLabel'] as String? ?? _statusLabel(json['status'] as String? ?? ''),
        createdAt: json['createdAt'] != null ? _parseDate(json['createdAt'] as String) : DateTime.now(),
        photoUrls: (json['photoUrls'] as List? ?? []).map((e) {
          final url = e as String;
          return BaseUrl.fileUrl(url);
        }).toList(),
      );

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} mois';
    if (diff.inDays > 0) return 'Il y a ${diff.inDays} j';
    if (diff.inHours > 0) return 'Il y a ${diff.inHours} h';
    if (diff.inMinutes > 0) return 'Il y a ${diff.inMinutes} min';
    return "À l'instant";
  }
}

