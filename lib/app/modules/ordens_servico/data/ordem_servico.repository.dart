import 'package:serviceflow/app/core/base/base.repository.dart';

import '../ordem_servico.model.dart';

class OrdemServicoRepository extends BaseRepository<OrdemServico> {
  OrdemServicoRepository() : super((map) => OrdemServico.fromMap(map));

  @override
  String get tableName => 'ordens_servico';
}
