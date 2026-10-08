import 'package:solimus_prestataire/features/demandes/data/services/demandes_service.dart';
import 'package:solimus_prestataire/features/wallet/data/models/wallet_models.dart';

/// Repository for Wallet feature following Innov & Impact Africa Guidelines.
class WalletRepository {
  final DemandesService _service;

  WalletRepository({DemandesService? service})
      : _service = service ?? DemandesService();

  Future<WalletData> getWallet({int page = 0, int size = 10}) =>
      _service.getWallet(page: page, size: size);

  Future<void> submitWithdrawal({
    required int amount,
    required String method,
    required String phoneNumber,
  }) =>
      _service.withdraw(
        amount: amount,
        method: method,
        phoneNumber: phoneNumber,
      );
}
