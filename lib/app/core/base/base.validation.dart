import 'base.model.dart';
import 'base.repository.dart';

abstract class BaseValidation<E extends BaseModel, R extends BaseRepository<E>> {
  const BaseValidation(this.repository);

  final R repository;

  Future<void> validateCreate(E entity);

  Future<void> validateUpdate(E entity);
}
