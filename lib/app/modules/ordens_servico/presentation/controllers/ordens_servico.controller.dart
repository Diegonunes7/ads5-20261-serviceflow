import 'package:serviceflow/app/core/base/base.controller.dart';

import '../../data/ordem_servico.repository.dart';
import '../../domain/ordem_servico.service.dart';
import '../../domain/ordem_servico.validation.dart';
import '../../ordem_servico.model.dart';

class OrdensServicoController extends BaseController<
    OrdemServico,
    OrdemServicoRepository,
    OrdemServicoValidation,
    OrdemServicoService> {
  OrdensServicoController({
    required OrdemServicoService service,
  }) : super(service);

  final List<OrdemServico> _ordens = [];

  List<OrdemServico> get ordens => List.unmodifiable(_ordens);

  Future<void> loadOrdens() async {
    final data = await executeOperation<List<OrdemServico>>(
      () => service.findAll(),
      errorMessage: 'Falha ao carregar ordens de servico.',
    );

    if (data == null) return;
    _ordens
      ..clear()
      ..addAll(data);
    notifyListeners();
  }

  Future<bool> cadastrarOrdem({
    required String clienteIdText,
    required String tecnicoIdText,
    required String observacao,
    required String valorPecasText,
  }) async {
    final created = await executeOperation<int>(
      () {
        final clienteId = _parsePositiveInt(
          clienteIdText,
          'Informe um id de cliente valido.',
        );
        final tecnicoId = _parsePositiveInt(
          tecnicoIdText,
          'Informe um id de tecnico valido.',
        );
        final valorPecas = _parseNonNegativeDouble(
          valorPecasText,
          'Informe um valor de pecas valido.',
        );

        final ordem = OrdemServico(
          clienteId: clienteId,
          tecnicoId: tecnicoId,
          observacao: observacao.trim().isEmpty ? null : observacao.trim(),
          valorPecas: valorPecas,
          isSync: 0,
          createdAt: DateTime.now(),
        );

        return service.create(ordem);
      },
      successMessage: 'O.S. salva localmente.',
      errorMessage: 'Nao foi possivel salvar a O.S. Verifique os campos.',
    );

    if (created == null) return false;

    await loadOrdens();
    return true;
  }

  Future<void> removerOrdem(int id) async {
    await executeCrudOperation(
      () async {
        await service.delete(id);
        await loadOrdens();
      },
      successMessage: 'O.S. removida com sucesso.',
      errorMessage: 'Falha ao remover O.S.',
    );
  }

  int _parsePositiveInt(String rawValue, String errorMessage) {
    final parsed = int.tryParse(rawValue.trim());
    if (parsed == null || parsed <= 0) {
      throw Exception(errorMessage);
    }
    return parsed;
  }

  double _parseNonNegativeDouble(String rawValue, String errorMessage) {
    final normalized = rawValue.trim().replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    if (parsed == null || parsed < 0) {
      throw Exception(errorMessage);
    }
    return parsed;
  }
}
