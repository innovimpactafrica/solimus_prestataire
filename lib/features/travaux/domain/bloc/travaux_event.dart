abstract class TravauxEvent {
  const TravauxEvent();
}

class LoadTravauxList extends TravauxEvent {
  final String? search;
  final String? status;
  final int page;
  final int size;
  const LoadTravauxList({
    this.search,
    this.status,
    this.page = 0,
    this.size = 10,
  });
}

class LoadTravauxDetail extends TravauxEvent {
  final int id;
  const LoadTravauxDetail(this.id);
}

class StartTravauxStep extends TravauxEvent {
  final int id;
  const StartTravauxStep(this.id);
}
