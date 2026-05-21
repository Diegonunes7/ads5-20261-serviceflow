import 'package:serviceflow/app/core/base/base.validation.dart';

import '../data/tecnico.repository.dart';
import '../tecnico.model.dart';

class TecnicoValidation extends BaseValidation<Tecnico, TecnicoRepository> {
  const TecnicoValidation(super.repository);

  @override
  Future<void> validateCreate(Tecnico entity) async {
    _validateFields(entity);
    await _validateNomeUniqueness(entity);
  }

  @override
  Future<void> validateUpdate(Tecnico entity) async {
    if (entity.id == null) {
      throw Exception('Tecnico sem id nao pode ser atualizado.');
    }
    _validateFields(entity);
    await _validateNomeUniqueness(entity);
  }

  void _validateFields(Tecnico entity) {
    if (entity.nome.trim().isEmpty) {
      throw Exception('Informe o nome do tecnico.');
    }
  }

  Future<void> _validateNomeUniqueness(Tecnico entity) async {
    final existente = await repository.findByNome(entity.nome);
    if (existente == null) return;
    if (existente.id == entity.id) return;

    throw Exception('Ja existe tecnico cadastrado com este nome.');
  }
}
