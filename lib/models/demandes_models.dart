DateTime _parseDate(String raw) {
  // ISO 8601 : "2026-05-22T09:14:00Z"
  if (raw.contains('T') || raw.contains('-')) {
    return DateTime.parse(raw);
  }
  // Format API : "22/05/2026 09:14"
  final parts = raw.split(' ');
  final dateParts = parts[0].split('/');
  final timeParts = parts.length > 1 ? parts[1].split(':') : ['0', '0'];
  return DateTime(
    int.parse(dateParts[2]),
    int.parse(dateParts[1]),
    int.parse(dateParts[0]),
    int.parse(timeParts[0]),
    int.parse(timeParts[1]),
  );
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
        label: json['label'] as String,
        completed: json['completed'] as bool,
        date: json['date'] != null ? _parseDate(json['date'] as String) : null,
      );
}

class DemandeRequest {
  final int id;
  final String title;
  final String description;
  final String status;
  final String residenceName;
  final String residentPhone;
  final String residentEmail;
  final List<String> photoUrls;
  final List<String> workPhotoUrls;
  final List<DemandeComment> comments;
  final List<DemandeHistory> history;
  final List<WorkflowStep> workflowSteps;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? finishedAt;

  const DemandeRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.residenceName,
    required this.residentPhone,
    required this.residentEmail,
    required this.photoUrls,
    required this.workPhotoUrls,
    required this.comments,
    required this.history,
    required this.workflowSteps,
    required this.createdAt,
    this.startedAt,
    this.finishedAt,
  });

  factory DemandeRequest.fromJson(Map<String, dynamic> json) => DemandeRequest(
        id: (json['id'] as num?)?.toInt() ?? 0,
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        status: json['status'] as String? ?? '',
        residenceName: json['residenceName'] as String? ?? '',
        residentPhone: json['residentPhone'] as String? ?? '',
        residentEmail: json['residentEmail'] as String? ?? '',
        photoUrls: (json['photoUrls'] as List? ?? []).map((e) => e as String).toList(),
        workPhotoUrls: (json['workPhotoUrls'] as List? ?? []).map((e) => e as String).toList(),
        comments: (json['comments'] as List? ?? [])
            .map((e) => DemandeComment.fromJson(e as Map<String, dynamic>))
            .toList(),
        history: (json['history'] as List? ?? [])
            .map((e) => DemandeHistory.fromJson(e as Map<String, dynamic>))
            .toList(),
        workflowSteps: (json['workflowSteps'] as List? ?? [])
            .map((e) => WorkflowStep.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: json['createdAt'] != null ? _parseDate(json['createdAt'] as String) : DateTime.now(),
        startedAt: json['startedAt'] != null ? _parseDate(json['startedAt'] as String) : null,
        finishedAt: json['finishedAt'] != null ? _parseDate(json['finishedAt'] as String) : null,
      );

  String get statusLabel => _statusLabel(status);
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
  final DateTime createdAt;

  const DemandeRequestSummary({
    required this.id,
    required this.title,
    required this.residenceName,
    required this.status,
    required this.createdAt,
  });

  factory DemandeRequestSummary.fromJson(Map<String, dynamic> json) =>
      DemandeRequestSummary(
        id: (json['id'] as num?)?.toInt() ?? 0,
        title: json['title'] as String? ?? '',
        residenceName: json['residenceName'] as String? ?? '',
        status: json['status'] as String? ?? '',
        createdAt: json['createdAt'] != null ? _parseDate(json['createdAt'] as String) : DateTime.now(),
      );

  String get statusLabel => _statusLabel(status);
}
