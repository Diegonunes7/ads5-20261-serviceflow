import 'package:serviceflow/app/core/base/base.validation.dart';

import '../data/ordem_servico.repository.dart';
import '../ordem_servico.model.dart';

class OrdemServicoValidation
    extends BaseValidation<OrdemServico, OrdemServicoRepository> {
  const OrdemServicoValidation(super.repository);

  @override
  Future<void> validateCreate(OrdemServico entity) async {
    _validateFields(entity);
  }

  @override
  Future<void> validateUpdate(OrdemServico entity) async {
    if (entity.id == null) {
      throw Exception('Ordem de servico sem id nao pode ser atualizada.');
    }
    _validateFields(entity);
  }

  void _validateFields(OrdemServico entity) {
    if (entity.clienteId <= 0) {
      throw Exception('Informe um cliente valido.');
    }

    if (entity.tecnicoId <= 0) {
      throw Exception('Informe um tecnico valido.');
    }

    if (entity.valorPecas < 0) {
      throw Exception('Valor de pecas nao pode ser negativo.');
    }
  }
}
