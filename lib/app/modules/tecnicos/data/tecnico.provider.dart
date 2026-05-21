import 'package:dio/dio.dart';
import 'package:serviceflow/app/core/base/base.provider.dart';
import 'package:serviceflow/app/core/helpers/app.config.dart';

import '../tecnico.model.dart';

class TecnicoProvider extends BaseProvider<Tecnico> {
  TecnicoProvider();

  @override
  Future<bool> validateBeforeSync(Tecnico entity) async {
    return entity.nome.trim().isNotEmpty && entity.ativo == 1;
  }

  @override
  Future<bool> syncEntity(Tecnico entity) async {
    if (_isPlaceholderApi()) return false;

    try {
      await client.dio.post(
        '/tecnicos',
        data: entity.toMap(),
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
