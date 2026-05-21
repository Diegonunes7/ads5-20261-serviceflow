import 'package:serviceflow/app/core/base/base.schedule.dart';

import '../tecnico.model.dart';
import 'tecnico.provider.dart';
import 'tecnico.repository.dart';

class TecnicoSchedule
    extends BaseSchedule<Tecnico, TecnicoRepository, TecnicoProvider> {
  TecnicoSchedule({
    TecnicoRepository? repository,
    TecnicoProvider? provider,
  }) : super(
          repository: repository ?? TecnicoRepository(),
          provider: provider ?? TecnicoProvider(),
        );

  @override
  String get featureName => 'tecnicos';
}
