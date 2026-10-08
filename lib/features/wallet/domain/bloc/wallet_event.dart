abstract class WalletEvent {
  const WalletEvent();
}

class LoadWalletData extends WalletEvent {
  final int page;
  final int size;
  const LoadWalletData({this.page = 0, this.size = 10});
}

class SubmitWithdrawalEvent extends WalletEvent {
  final int amount;
  final String method;
  final String phoneNumber;

  const SubmitWithdrawalEvent({
    required this.amount,
    required this.method,
    required this.phoneNumber,
  });
}
