import 'package:serviceflow/app/core/base/base.validation.dart';

import '../data/usuario.repository.dart';
import '../usuario.model.dart';

class UsuarioValidation extends BaseValidation<Usuario, UsuarioRepository> {
  const UsuarioValidation(super.repository);

  @override
  Future<void> validateCreate(Usuario entity) async {
    _validateFields(entity);
    await _validateEmailUniqueness(entity);
  }

  @override
  Future<void> validateUpdate(Usuario entity) async {
    if (entity.id == null) {
      throw Exception('Usuario sem id nao pode ser atualizado.');
    }
    _validateFields(entity);
    await _validateEmailUniqueness(entity);
  }

  void _validateFields(Usuario entity) {
    if (entity.nomeCompleto.trim().isEmpty) {
      throw Exception('Informe o nome completo do usuario.');
    }
    if (entity.email.trim().isEmpty) {
      throw Exception('Informe o e-mail do usuario.');
    }
    if (entity.grupoId.trim().isEmpty) {
      throw Exception('Informe o grupo do usuario.');
    }

    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(entity.email.trim())) {
      throw Exception('Informe um e-mail valido.');
    }
  }

  Future<void> _validateEmailUniqueness(Usuario entity) async {
    final existente = await repository.findByEmail(entity.email);
    if (existente == null) return;
    if (existente.id == entity.id) return;
    throw Exception('Ja existe usuario cadastrado com este e-mail.');
  }
}
