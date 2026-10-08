import '../../data/models/demandes_models.dart';
import '../../data/services/demandes_service.dart';

abstract class DemandesState {
  const DemandesState();
}

class DemandesInitial extends DemandesState {
  const DemandesInitial();
}

class DemandesLoading extends DemandesState {
  const DemandesLoading();
}

class DemandesLoaded extends DemandesState {
  final AvailableRequestsPage page;
  const DemandesLoaded(this.page);
}

class DemandeDetailLoaded extends DemandesState {
  final DemandeRequest detail;
  const DemandeDetailLoaded(this.detail);
}

class DemandesError extends DemandesState {
  final String message;
  const DemandesError(this.message);
}
