import '../../data/models/wallet_models.dart';

abstract class WalletState {
  const WalletState();
}

class WalletInitial extends WalletState {
  const WalletInitial();
}

class WalletLoading extends WalletState {
  const WalletLoading();
}

class WalletLoaded extends WalletState {
  final WalletData data;
  const WalletLoaded(this.data);
}

class WithdrawalSuccess extends WalletState {
  const WithdrawalSuccess();
}

class WalletError extends WalletState {
  final String message;
  const WalletError(this.message);
}
