import 'package:dio/dio.dart';
import 'package:serviceflow/app/core/base/base.provider.dart';
import 'package:serviceflow/app/core/helpers/app.config.dart';

import '../cliente.model.dart';

class ClienteProvider extends BaseProvider<Cliente> {
  ClienteProvider();

  @override
  Future<bool> validateBeforeSync(Cliente entity) async {
    return entity.nome.trim().isNotEmpty &&
        entity.email.trim().isNotEmpty &&
        entity.telefone.trim().isNotEmpty;
  }

  @override
  Future<bool> syncEntity(Cliente entity) async {
    if (_isPlaceholderApi()) return false;

    try {
      await client.dio.post(
        '/clientes',
        data: {
          ...entity.toMap(),
          'ativo': 1,
        },
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
