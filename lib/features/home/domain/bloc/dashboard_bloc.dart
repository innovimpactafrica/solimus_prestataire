import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../data/services/dashboard_service.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

/// BLoC for Dashboard feature following Innov & Impact Africa Guidelines.
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository;

  DashboardBloc({DashboardRepository? repository})
      : _repository = repository ?? DashboardRepository(),
        super(const DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    try {
      final data = await _repository.getDashboard();
      emit(DashboardLoaded(data));
    } on AbonnementInactifException {
      emit(const DashboardSubscriptionInactive());
    } catch (e) {
      emit(DashboardError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
