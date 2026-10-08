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
  final int id;
  final String label;
  final String reference;
  final DateTime transactionDate;
  final double amount;
  final String mode;
  final String category;

  const WalletTransaction({
    required this.id,
    required this.label,
    required this.reference,
    required this.transactionDate,
    required this.amount,
    required this.mode,
    required this.category,
  });

  bool get isEntree => category.toUpperCase() != 'CHARGES';

  factory WalletTransaction.fromJson(Map<String, dynamic> json) => WalletTransaction(
        id: (json['id'] as num?)?.toInt() ?? 0,
        label: json['label'] as String? ?? '',
        reference: json['reference'] as String? ?? '',
        transactionDate: _parseWalletDate(json['transactionDate'] as String?),
        amount: (json['amount'] as num?)?.toDouble() ?? 0,
        mode: json['mode'] as String? ?? '',
        category: json['category'] as String? ?? '',
      );
}

class WalletData {
  final double availableBalance;
  final double pendingBalance;
  final double totalThisMonth;
  final List<WalletTransaction> transactions;
  final int totalPages;
  final int totalElements;

  const WalletData({
    required this.availableBalance,
    required this.pendingBalance,
    required this.totalThisMonth,
    required this.transactions,
    required this.totalPages,
    required this.totalElements,
  });

  double get soldeDisponible => availableBalance;
  double get enAttente => pendingBalance;
  double get ceMois => totalThisMonth;

  factory WalletData.fromJson(Map<String, dynamic> json) {
    final tx = (json['transactions'] as Map<String, dynamic>?) ?? {};
    return WalletData(
      availableBalance: (json['availableBalance'] as num?)?.toDouble() ?? 0,
      pendingBalance: (json['pendingBalance'] as num?)?.toDouble() ?? 0,
      totalThisMonth: (json['totalThisMonth'] as num?)?.toDouble() ?? 0,
      totalPages: (tx['totalPages'] as num?)?.toInt() ?? 0,
      totalElements: (tx['totalElements'] as num?)?.toInt() ?? 0,
      transactions: (tx['content'] as List? ?? [])
          .map((e) => WalletTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
