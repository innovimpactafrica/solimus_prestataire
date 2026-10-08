import 'package:image_picker/image_picker.dart';
import 'package:solimus_prestataire/features/demandes/data/services/demandes_service.dart';
import 'package:solimus_prestataire/features/travaux/data/models/travaux_models.dart';

/// Repository for Travaux feature following Innov & Impact Africa Guidelines.
class TravauxRepository {
  final DemandesService _service;

  TravauxRepository({DemandesService? service})
      : _service = service ?? DemandesService();

  Future<TravauxPage_> getMyJobs({
    String? search,
    String? status,
    int page = 0,
    int size = 10,
  }) =>
      _service.getTravaux(
        search: search,
        status: status,
        page: page,
        size: size,
      );

  Future<TravauxDetail> getJobDetail(int id) => _service.getTravauxDetail(id);

  Future<void> startJob(int id) => _service.startTravail(int.parse('$id'));

  Future<void> finishJob(
    int id, {
    String? commentaire,
    List<XFile>? photos,
  }) =>
      _service.finishTravail(id, commentaire: commentaire, photos: photos);
}
