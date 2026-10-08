import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/demandes_repository.dart';
import 'demandes_event.dart';
import 'demandes_state.dart';

/// BLoC for Demandes feature following Innov & Impact Africa Guidelines.
class DemandesBloc extends Bloc<DemandesEvent, DemandesState> {
  final DemandesRepository _repository;

  DemandesBloc({DemandesRepository? repository})
      : _repository = repository ?? DemandesRepository(),
        super(const DemandesInitial()) {
    on<LoadAvailableDemandes>(_onLoadAvailableDemandes);
    on<LoadDemandeDetail>(_onLoadDemandeDetail);
    on<AddCommentEvent>(_onAddComment);
  }

  Future<void> _onLoadAvailableDemandes(
    LoadAvailableDemandes event,
    Emitter<DemandesState> emit,
  ) async {
    emit(const DemandesLoading());
    try {
      final page = await _repository.getAvailableRequests(
        search: event.search,
        status: event.status,
        page: event.page,
        size: event.size,
      );
      emit(DemandesLoaded(page));
    } catch (e) {
      emit(DemandesError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoadDemandeDetail(
    LoadDemandeDetail event,
    Emitter<DemandesState> emit,
  ) async {
    emit(const DemandesLoading());
    try {
      final detail = await _repository.getRequestDetail(event.id);
      emit(DemandeDetailLoaded(detail));
    } catch (e) {
      emit(DemandesError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onAddComment(
    AddCommentEvent event,
    Emitter<DemandesState> emit,
  ) async {
    try {
      await _repository.addComment(event.requestId, event.content);
      final updated = await _repository.getRequestDetail(event.requestId);
      emit(DemandeDetailLoaded(updated));
    } catch (e) {
      emit(DemandesError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
