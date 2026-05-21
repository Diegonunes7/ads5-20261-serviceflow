import 'package:serviceflow/app/core/base/base.service.dart';

import '../data/ordem_servico.repository.dart';
import '../ordem_servico.model.dart';
import 'ordem_servico.validation.dart';

class OrdemServicoService extends BaseService<OrdemServico,
    OrdemServicoRepository, OrdemServicoValidation> {
  const OrdemServicoService({
    required super.repository,
    required super.validation,
  });
}
