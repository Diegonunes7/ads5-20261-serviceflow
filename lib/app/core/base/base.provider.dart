import '../models/error.model.dart';
import '../http/app_client.dart';
import 'base.model.dart';

abstract class BaseProvider<E extends BaseModel> {
  BaseProvider({AppClient? client}) : client = client ?? AppClient();

  final AppClient client;

  Future<bool> validateBeforeSync(E entity) async => true;

  Future<bool> syncEntity(E entity);

  Exception handleError(String operation, Object error) {
    if (error is ErrorModel) {
      return Exception('${error.titulo} (${error.codeErro}): ${error.mensagem}');
    }
    return Exception('Falha em $operation: $error');
  }
}
