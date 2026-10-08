import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/wallet_repository.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

/// BLoC for Wallet feature following Innov & Impact Africa Guidelines.
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository _repository;

  WalletBloc({WalletRepository? repository})
      : _repository = repository ?? WalletRepository(),
        super(const WalletInitial()) {
    on<LoadWalletData>(_onLoadWalletData);
    on<SubmitWithdrawalEvent>(_onSubmitWithdrawal);
  }

  Future<void> _onLoadWalletData(
    LoadWalletData event,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletLoading());
    try {
      final data =
          await _repository.getWallet(page: event.page, size: event.size);
      emit(WalletLoaded(data));
    } catch (e) {
      emit(WalletError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onSubmitWithdrawal(
    SubmitWithdrawalEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletLoading());
    try {
      await _repository.submitWithdrawal(
        amount: event.amount,
        method: event.method,
        phoneNumber: event.phoneNumber,
      );
      emit(const WithdrawalSuccess());
      final updated = await _repository.getWallet();
      emit(WalletLoaded(updated));
    } catch (e) {
      emit(WalletError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
