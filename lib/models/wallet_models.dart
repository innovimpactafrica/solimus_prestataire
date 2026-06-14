DateTime _parseWalletDate(String? raw) {
  if (raw == null || raw.isEmpty) return DateTime.now();
  try {
    if (raw.contains('-') && !raw.startsWith(RegExp(r'\d{2}-'))) return DateTime.parse(raw);
    final parts = raw.split('/');
    if (parts.length == 3) {
      return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    }
    return DateTime.parse(raw);
  } catch (_) {
    return DateTime.now();
  }
}

class WalletTransaction {
  final String label;
  final double montant;
  final String type;
  final String statut;
  final DateTime date;

  const WalletTransaction({
    required this.label,
    required this.montant,
    required this.type,
    required this.statut,
    required this.date,
  });

  bool get isPending => statut.toUpperCase().contains('PENDING') || statut.toUpperCase().contains('ATTENTE');
  bool get isEntree => type.toUpperCase() == 'ENTREE';

  factory WalletTransaction.fromJson(Map<String, dynamic> json) => WalletTransaction(
        label: json['label'] as String? ?? '',
        montant: (json['montant'] as num?)?.toDouble() ?? 0,
        type: json['type'] as String? ?? 'ENTREE',
        statut: json['statut'] as String? ?? '',
        date: _parseWalletDate(json['date'] as String?),
      );
}

class WalletData {
  final double soldeDisponible;
  final double soldeEnAttente;
  final double totalCeMois;
  final List<WalletTransaction> transactions;

  const WalletData({
    required this.soldeDisponible,
    required this.soldeEnAttente,
    required this.totalCeMois,
    required this.transactions,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    final raw = json['transactions'];
    List<dynamic> txList;
    if (raw is List) {
      txList = raw;
    } else if (raw is Map) {
      txList = (raw['content'] as List?) ?? (raw['data'] as List?) ?? [];
    } else {
      txList = [];
    }
    return WalletData(
      soldeDisponible: (json['soldeDisponible'] as num?)?.toDouble() ?? 0,
      soldeEnAttente: (json['soldeEnAttente'] as num?)?.toDouble() ?? 0,
      totalCeMois: (json['totalCeMois'] as num?)?.toDouble() ?? 0,
      transactions: txList
          .map((e) => WalletTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
