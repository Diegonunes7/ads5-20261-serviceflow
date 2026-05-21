import 'package:dio/dio.dart';
import 'package:serviceflow/app/core/base/base.provider.dart';
import 'package:serviceflow/app/core/helpers/app.config.dart';

import '../usuario.model.dart';

class UsuarioProvider extends BaseProvider<Usuario> {
  UsuarioProvider();

  @override
  Future<bool> validateBeforeSync(Usuario entity) async {
    return entity.nomeCompleto.trim().isNotEmpty &&
        entity.email.trim().isNotEmpty &&
        entity.grupoId.trim().isNotEmpty;
  }

  @override
  Future<bool> syncEntity(Usuario entity) async {
    if (_isPlaceholderApi()) return false;

    try {
      await client.dio.post(
        '/usuarios',
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
