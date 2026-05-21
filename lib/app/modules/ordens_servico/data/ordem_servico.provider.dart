import 'package:dio/dio.dart';
import 'package:serviceflow/app/core/base/base.provider.dart';
import 'package:serviceflow/app/core/helpers/app.config.dart';

import '../ordem_servico.model.dart';

class OrdemServicoProvider extends BaseProvider<OrdemServico> {
  OrdemServicoProvider();

  @override
  Future<bool> validateBeforeSync(OrdemServico entity) async {
    return entity.clienteId > 0 && entity.tecnicoId > 0 && entity.ativo == 1;
  }

  @override
  Future<bool> syncEntity(OrdemServico entity) async {
    if (_isPlaceholderApi()) return false;

    final payload = Map<String, dynamic>.from(entity.toMap())
      ..remove('id')
      ..remove('is_sync');

    try {
      await client.dio.post(
        '/ordens-servico',
        data: payload,
      );
      return true;
    } on DioException catch (error) {
      handleError('syncEntity', error);
      return false;
    } catch (error) {
      handleError('syncEntity', error);
      return false;
    }
  }

  bool _isPlaceholderApi() {
    return AppConfig.apiBaseUrl.contains('your-supabase-url');
  }
}
