import 'package:serviceflow/app/core/base/base.controller.dart';

import '../../data/tecnico.repository.dart';
import '../../domain/tecnico.service.dart';
import '../../domain/tecnico.validation.dart';
import '../../tecnico.model.dart';

class TecnicosController extends BaseController<Tecnico, TecnicoRepository,
    TecnicoValidation, TecnicoService> {
  TecnicosController({
    required TecnicoService service,
  }) : super(service);

  final List<Tecnico> _tecnicos = [];

  List<Tecnico> get tecnicos => List.unmodifiable(_tecnicos);

  Future<void> loadTecnicos() async {
    final data = await executeOperation<List<Tecnico>>(
      () => service.findAll(),
      errorMessage: 'Falha ao carregar tecnicos.',
    );

    if (data == null) return;
    _tecnicos
      ..clear()
      ..addAll(data);
    notifyListeners();
  }

  Future<bool> cadastrarTecnico({
    required String nome,
    required String especialidade,
  }) async {
    final novoTecnico = Tecnico(
      nome: nome.trim(),
      especialidade: especialidade.trim().isEmpty ? null : especialidade.trim(),
      isSync: 0,
      ativo: 1,
      createdAt: DateTime.now(),
    );

    final created = await executeOperation<int>(
      () => service.create(novoTecnico),
      successMessage: 'Tecnico salvo localmente.',
      errorMessage: 'Nao foi possivel salvar o tecnico.',
    );

    if (created == null) return false;

    await loadTecnicos();
    return true;
  }

  Future<void> removerTecnico(int id) async {
    await executeCrudOperation(
      () async {
        await service.delete(id);
        await loadTecnicos();
      },
      successMessage: 'Tecnico removido com sucesso.',
      errorMessage: 'Falha ao remover tecnico.',
    );
  }
}
