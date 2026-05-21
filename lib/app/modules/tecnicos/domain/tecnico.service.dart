import 'package:serviceflow/app/core/base/base.service.dart';

import '../data/tecnico.repository.dart';
import '../tecnico.model.dart';
import 'tecnico.validation.dart';

class TecnicoService
    extends BaseService<Tecnico, TecnicoRepository, TecnicoValidation> {
  const TecnicoService({
    required super.repository,
    required super.validation,
  });
}
