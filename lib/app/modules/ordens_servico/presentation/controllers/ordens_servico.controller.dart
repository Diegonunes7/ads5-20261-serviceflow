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
  final List<ClienteOption> _clientesDisponiveis = [];
  final List<TecnicoOption> _tecnicosDisponiveis = [];

  List<OrdemServico> get ordens => List.unmodifiable(_ordens);
  List<ClienteOption> get clientesDisponiveis =>
      List.unmodifiable(_clientesDisponiveis);
  List<TecnicoOption> get tecnicosDisponiveis =>
      List.unmodifiable(_tecnicosDisponiveis);

  Future<void> loadDadosTela() async {
    final loaded = await executeOperation<bool>(
      () async {
        final ordensData = await service.findAll();
        final clientesData = await service.repository.findClientesAtivos();
        final tecnicosData = await service.repository.findTecnicosAtivos();

        _ordens
          ..clear()
          ..addAll(ordensData);
        _clientesDisponiveis
          ..clear()
          ..addAll(clientesData);
        _tecnicosDisponiveis
          ..clear()
          ..addAll(tecnicosData);

        return true;
      },
      errorMessage: 'Falha ao carregar ordens de servico.',
    );

    if (loaded == null) return;

    if (_clientesDisponiveis.isEmpty) {
      showWarning('Nenhum cliente ativo encontrado para vincular na O.S.');
    } else if (_tecnicosDisponiveis.isEmpty) {
      showWarning('Nenhum tecnico ativo encontrado para vincular na O.S.');
    }

    notifyListeners();
  }

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
    required int? clienteId,
    required int? tecnicoId,
    required String observacao,
    required String valorPecasText,
    String? fotoAntesPath,
    String? fotoDepoisPath,
  }) async {
    final created = await executeOperation<int>(
      () async {
        final clienteIdValue = _validateSelectedId(
          clienteId,
          'Selecione um cliente.',
        );
        final tecnicoIdValue = _validateSelectedId(
          tecnicoId,
          'Selecione um tecnico.',
        );

        final valorPecas = _parseNonNegativeDouble(
          valorPecasText,
          'Informe um valor de pecas valido.',
        );

        final ordem = OrdemServico(
          clienteId: clienteIdValue,
          tecnicoId: tecnicoIdValue,
          observacao: observacao.trim().isEmpty ? null : observacao.trim(),
          valorPecas: valorPecas,
          fotoAntes: fotoAntesPath,
          fotoDepois: fotoDepoisPath,
          isSync: 0,
          createdAt: DateTime.now(),
        );

        return await service.create(ordem);
      },
      successMessage: 'O.S. salva localmente.',
      errorMessage: 'Nao foi possivel salvar a O.S. Verifique os campos.',
    );

    if (created == null) return false;

    await loadDadosTela();
    return true;
  }

  Future<void> removerOrdem(int id) async {
    await executeCrudOperation(
      () async {
        await service.delete(id);
        await loadDadosTela();
      },
      successMessage: 'O.S. removida com sucesso.',
      errorMessage: 'Falha ao remover O.S.',
    );
  }

  int _validateSelectedId(int? value, String errorMessage) {
    if (value == null || value <= 0) {
      throw Exception(errorMessage);
    }
    return value;
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
