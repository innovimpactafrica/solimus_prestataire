abstract class DemandesEvent {
  const DemandesEvent();
}

class LoadAvailableDemandes extends DemandesEvent {
  final String? search;
  final String? status;
  final int page;
  final int size;
  const LoadAvailableDemandes({
    this.search,
    this.status,
    this.page = 0,
    this.size = 10,
  });
}

class LoadDemandeDetail extends DemandesEvent {
  final int id;
  const LoadDemandeDetail(this.id);
}

class AddCommentEvent extends DemandesEvent {
  final int requestId;
  final String content;
  const AddCommentEvent({required this.requestId, required this.content});
}
