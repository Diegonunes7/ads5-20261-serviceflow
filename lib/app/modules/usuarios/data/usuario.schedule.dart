import 'package:serviceflow/app/core/base/base.schedule.dart';

import '../usuario.model.dart';
import 'usuario.provider.dart';
import 'usuario.repository.dart';

class UsuarioSchedule
    extends BaseSchedule<Usuario, UsuarioRepository, UsuarioProvider> {
  UsuarioSchedule({
    UsuarioRepository? repository,
    UsuarioProvider? provider,
  }) : super(
          repository: repository ?? UsuarioRepository(),
          provider: provider ?? UsuarioProvider(),
        );

  @override
  String get featureName => 'usuarios';
}
