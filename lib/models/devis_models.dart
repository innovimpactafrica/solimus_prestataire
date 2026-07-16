DateTime _parseDevisDate(String? raw) {
  if (raw == null || raw.isEmpty) return DateTime.now();
  try {
    if (raw.contains('T') || RegExp(r'^\d{4}-').hasMatch(raw)) return DateTime.parse(raw);
    final parts = raw.split(' ');
    final d = parts[0].split('/');
    if (d.length == 3) {
      final t = parts.length > 1 ? parts[1].split(':') : ['0', '0'];
      return DateTime(int.parse(d[2]), int.parse(d[1]), int.parse(d[0]), int.parse(t[0]), int.parse(t[1]));
    }
    return DateTime.parse(raw);
  } catch (_) {
    return DateTime.now();
  }
}

class DevisItem {
  final int id;
  final String description;
  final int quantity;
  final int unitPrice;
  final String type;

  const DevisItem({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.type,
  });

  int get total => quantity * unitPrice;

  factory DevisItem.fromJson(Map<String, dynamic> json) => DevisItem(
        id: (json['id'] as num?)?.toInt() ?? 0,
        description: json['description'] as String? ?? '',
        quantity: (json['quantity'] as num?)?.toInt() ?? 0,
        unitPrice: (json['unitPrice'] as num?)?.toInt() ?? 0,
        type: json['type'] as String? ?? 'MATERIAL',
      );
}

class DevisSummary {
  final int id;
  final String reference;
  final String status;
  final double totalAmount;
  final String requestTitle;
  final DateTime createdAt;
  final DateTime? sentAt;

  const DevisSummary({
    required this.id,
    required this.reference,
    required this.status,
    required this.totalAmount,
    required this.requestTitle,
    required this.createdAt,
    this.sentAt,
  });

  factory DevisSummary.fromJson(Map<String, dynamic> json) {
    return DevisSummary(
      id: (json['id'] as num?)?.toInt() ?? 0,
      reference: json['reference'] as String? ?? '',
      status: json['statut'] as String? ?? json['status'] as String? ?? '',
      totalAmount: (json['montant'] as num?)?.toDouble() ?? (json['totalAmount'] as num?)?.toDouble() ?? 0,
      requestTitle: json['titre'] as String? ?? json['requestTitle'] as String? ?? '',
      createdAt: _parseDevisDate(json['date'] as String? ?? json['createdAt'] as String?),
      sentAt: json['sentAt'] != null ? _parseDevisDate(json['sentAt'] as String) : null,
    );
  }

  String get statusLabel {
    switch (status) {
      case 'DRAFT':    return 'Brouillon';
      case 'SENT':     return 'Envoyé';
      case 'ACCEPTED': return 'Accepté';
      case 'REJECTED': return 'Refusé';
      default:         return status;
    }
  }
}

class DevisLineItem {
  final String description;
  final int quantity;
  final int unitPrice;
  final int subtotal;

  const DevisLineItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory DevisLineItem.fromJson(Map<String, dynamic> json) => DevisLineItem(
        description: json['description'] as String? ?? '',
        quantity: (json['quantity'] as num?)?.toInt() ?? 0,
        unitPrice: (json['unitPrice'] as num?)?.toInt() ?? 0,
        subtotal: (json['subtotal'] as num?)?.toInt() ?? 0,
      );
}

class DevisDetail {
  final String reference;
  final String titre;
  final String statut;
  final double montantTotal;
  final DateTime? dateEnvoi;
  final DateTime? dateValidation;
  final String clientNom;
  final String clientTelephone;
  final String clientEmail;
  final String clientAdresse;
  final List<DevisLineItem> materiaux;
  final double sousTotalMateriaux;
  final List<DevisLineItem> mainOeuvre;
  final double sousTotalMainOeuvre;
  final double totalTTC;
  final String? notes;
  final String? estimatedDelayLabel;

  const DevisDetail({
    required this.reference,
    required this.titre,
    required this.statut,
    required this.montantTotal,
    this.dateEnvoi,
    this.dateValidation,
    required this.clientNom,
    required this.clientTelephone,
    required this.clientEmail,
    required this.clientAdresse,
    required this.materiaux,
    required this.sousTotalMateriaux,
    required this.mainOeuvre,
    required this.sousTotalMainOeuvre,
    required this.totalTTC,
    this.notes,
    this.estimatedDelayLabel,
  });

  factory DevisDetail.fromJson(Map<String, dynamic> json) => DevisDetail(
        reference: json['reference'] as String? ?? '',
        titre: json['titre'] as String? ?? '',
        statut: json['statut'] as String? ?? '',
        montantTotal: (json['montantTotal'] as num?)?.toDouble() ?? 0,
        dateEnvoi: json['dateEnvoi'] != null ? _parseDevisDate(json['dateEnvoi'] as String) : null,
        dateValidation: json['dateValidation'] != null ? _parseDevisDate(json['dateValidation'] as String) : null,
        clientNom: json['clientNom'] as String? ?? '',
        clientTelephone: json['clientTelephone'] as String? ?? '',
        clientEmail: json['clientEmail'] as String? ?? '',
        clientAdresse: json['clientAdresse'] as String? ?? '',
        materiaux: (json['materiaux'] as List? ?? [])
            .map((e) => DevisLineItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        sousTotalMateriaux: (json['sousTotalMateriaux'] as num?)?.toDouble() ?? 0,
        mainOeuvre: (json['mainOeuvre'] as List? ?? [])
            .map((e) => DevisLineItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        sousTotalMainOeuvre: (json['sousTotalMainOeuvre'] as num?)?.toDouble() ?? 0,
        totalTTC: (json['totalTTC'] as num?)?.toDouble() ?? (json['montantTotal'] as num?)?.toDouble() ?? 0,
        notes: json['notes'] as String?,
        estimatedDelayLabel: json['estimatedDelayLabel'] as String?,
      );

  String get statLabel {
    switch (statut) {
      case 'DRAFT':    return 'Brouillon';
      case 'SENT':     return 'Envoyé';
      case 'ACCEPTED': return 'Validé';
      case 'REJECTED': return 'Refusé';
      default:         return statut;
    }
  }
}

class DevisListResponse {
  final double totalMontantValide;
  final int totalElements;
  final int totalPages;
  final List<DevisSummary> content;

  const DevisListResponse({
    required this.totalMontantValide,
    required this.totalElements,
    required this.totalPages,
    required this.content,
  });

  factory DevisListResponse.fromJson(Map<String, dynamic> json) {
    final devis = (json['devis'] as Map<String, dynamic>?) ?? {};
    return DevisListResponse(
      totalMontantValide: (json['totalValidAmount'] as num?)?.toDouble() ??
          (json['totalMontantValide'] as num?)?.toDouble() ?? 0,
      totalElements: (devis['totalElements'] as num?)?.toInt() ?? 0,
      totalPages: (devis['totalPages'] as num?)?.toInt() ?? 0,
      content: (devis['content'] as List? ?? [])
          .map((e) => DevisSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
