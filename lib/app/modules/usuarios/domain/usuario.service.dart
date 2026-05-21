import 'package:serviceflow/app/core/base/base.service.dart';

import '../data/usuario.repository.dart';
import '../usuario.model.dart';
import 'usuario.validation.dart';

class UsuarioService
    extends BaseService<Usuario, UsuarioRepository, UsuarioValidation> {
  const UsuarioService({
    required super.repository,
    required super.validation,
  });
}
