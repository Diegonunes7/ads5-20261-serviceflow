import 'package:serviceflow/app/core/base/base.validation.dart';

import '../cliente.model.dart';
import '../data/cliente.repository.dart';

class ClienteValidation extends BaseValidation<Cliente, ClienteRepository> {
  const ClienteValidation(super.repository);

  @override
  Future<void> validateCreate(Cliente entity) async {
    _validateFields(entity);
    await _validateEmailUniqueness(entity);
  }

  @override
  Future<void> validateUpdate(Cliente entity) async {
    if (entity.id == null) {
      throw Exception('Cliente sem id nao pode ser atualizado.');
    }
    _validateFields(entity);
    await _validateEmailUniqueness(entity);
  }

  void _validateFields(Cliente entity) {
    if (entity.nome.trim().isEmpty) {
      throw Exception('Informe o nome do cliente.');
    }

    if (entity.email.trim().isEmpty) {
      throw Exception('Informe o e-mail do cliente.');
    }

    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(entity.email.trim())) {
      throw Exception('Informe um e-mail valido.');
    }

    if (entity.telefone.trim().isEmpty) {
      throw Exception('Informe o telefone do cliente.');
    }
  }

  Future<void> _validateEmailUniqueness(Cliente entity) async {
    final existente = await repository.findByEmail(entity.email);
    if (existente == null) return;
    if (existente.id == entity.id) return;

    throw Exception('Ja existe cliente cadastrado com este e-mail.');
  }
}
