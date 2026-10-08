import '../../data/models/travaux_models.dart';

abstract class TravauxState {
  const TravauxState();
}

class TravauxInitial extends TravauxState {
  const TravauxInitial();
}

class TravauxLoading extends TravauxState {
  const TravauxLoading();
}

class TravauxListLoaded extends TravauxState {
  final TravauxPage_ page;
  const TravauxListLoaded(this.page);
}

class TravauxDetailLoaded extends TravauxState {
  final TravauxDetail detail;
  const TravauxDetailLoaded(this.detail);
}

class TravauxError extends TravauxState {
  final String message;
  const TravauxError(this.message);
}
