import 'package:serviceflow/app/core/base/base.schedule.dart';

import '../ordem_servico.model.dart';
import 'ordem_servico.provider.dart';
import 'ordem_servico.repository.dart';

class OrdemServicoSchedule extends BaseSchedule<OrdemServico,
    OrdemServicoRepository, OrdemServicoProvider> {
  OrdemServicoSchedule({
    OrdemServicoRepository? repository,
    OrdemServicoProvider? provider,
  }) : super(
          repository: repository ?? OrdemServicoRepository(),
          provider: provider ?? OrdemServicoProvider(),
        );

  @override
  String get featureName => 'ordens_servico';
}
