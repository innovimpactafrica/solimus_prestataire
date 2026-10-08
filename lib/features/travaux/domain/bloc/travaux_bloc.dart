import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/travaux_repository.dart';
import 'travaux_event.dart';
import 'travaux_state.dart';

/// BLoC for Travaux feature following Innov & Impact Africa Guidelines.
class TravauxBloc extends Bloc<TravauxEvent, TravauxState> {
  final TravauxRepository _repository;

  TravauxBloc({TravauxRepository? repository})
      : _repository = repository ?? TravauxRepository(),
        super(const TravauxInitial()) {
    on<LoadTravauxList>(_onLoadTravauxList);
    on<LoadTravauxDetail>(_onLoadTravauxDetail);
    on<StartTravauxStep>(_onStartTravauxStep);
  }

  Future<void> _onLoadTravauxList(
    LoadTravauxList event,
    Emitter<TravauxState> emit,
  ) async {
    emit(const TravauxLoading());
    try {
      final page = await _repository.getMyJobs(
        search: event.search,
        status: event.status,
        page: event.page,
        size: event.size,
      );
      emit(TravauxListLoaded(page));
    } catch (e) {
      emit(TravauxError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoadTravauxDetail(
    LoadTravauxDetail event,
    Emitter<TravauxState> emit,
  ) async {
    emit(const TravauxLoading());
    try {
      final detail = await _repository.getJobDetail(event.id);
      emit(TravauxDetailLoaded(detail));
    } catch (e) {
      emit(TravauxError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onStartTravauxStep(
    StartTravauxStep event,
    Emitter<TravauxState> emit,
  ) async {
    try {
      await _repository.startJob(event.id);
      final updated = await _repository.getJobDetail(event.id);
      emit(TravauxDetailLoaded(updated));
    } catch (e) {
      emit(TravauxError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
