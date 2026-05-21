import 'package:serviceflow/app/core/base/base.service.dart';

import '../cliente.model.dart';
import '../data/cliente.repository.dart';
import 'cliente.validation.dart';

class ClienteService
    extends BaseService<Cliente, ClienteRepository, ClienteValidation> {
  const ClienteService({
    required super.repository,
    required super.validation,
  });
}
