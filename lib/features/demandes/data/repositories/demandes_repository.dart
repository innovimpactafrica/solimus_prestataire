import 'package:solimus_prestataire/features/demandes/data/models/demandes_models.dart';
import '../services/demandes_service.dart';

/// Repository for Demandes feature following Innov & Impact Africa Guidelines.
class DemandesRepository {
  final DemandesService _service;

  DemandesRepository({DemandesService? service})
      : _service = service ?? DemandesService();

  Future<AvailableRequestsPage> getAvailableRequests({
    String? search,
    String? status,
    int page = 0,
    int size = 10,
  }) =>
      _service.getAvailableRequests(
        search: search,
        status: status,
        page: page,
        size: size,
      );

  Future<DemandeRequest> getRequestDetail(int id) =>
      _service.getRequestById(id);

  Future<void> addComment(int requestId, String content) =>
      _service.addComment(requestId, content);

  Future<void> createQuote({
    required int interventionRequestId,
    required int estimatedDelayId,
    String? additionalComments,
    required List<Map<String, dynamic>> items,
    required bool draft,
  }) =>
      _service.createQuote(
        interventionRequestId: interventionRequestId,
        estimatedDelayId: estimatedDelayId,
        additionalComments: additionalComments,
        items: items,
        draft: draft,
      );

  Future<Map<String, int>> getRequestsCount() =>
      _service.getRequestsCount();
}
