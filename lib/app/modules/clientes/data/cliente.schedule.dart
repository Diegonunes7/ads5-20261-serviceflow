import 'package:serviceflow/app/core/base/base.schedule.dart';

import '../cliente.model.dart';
import 'cliente.provider.dart';
import 'cliente.repository.dart';

class ClienteSchedule
    extends BaseSchedule<Cliente, ClienteRepository, ClienteProvider> {
  ClienteSchedule({
    ClienteRepository? repository,
    ClienteProvider? provider,
  }) : super(
          repository: repository ?? ClienteRepository(),
          provider: provider ?? ClienteProvider(),
        );

  @override
  String get featureName => 'clientes';
}
