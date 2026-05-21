import 'base.model.dart';
import 'base.repository.dart';
import 'base.validation.dart';

abstract class BaseService<E extends BaseModel, R extends BaseRepository<E>,
    V extends BaseValidation<E, R>> {
  const BaseService({
    required this.repository,
    required this.validation,
  });

  final R repository;
  final V validation;

  Future<int> create(E entity) async {
    await validation.validateCreate(entity);
    return repository.insert(entity);
  }

  Future<int> update(E entity) async {
    await validation.validateUpdate(entity);
    return repository.update(entity);
  }

  Future<int> delete(int id) {
    return repository.delete(id);
  }

  Future<E?> findById(int id) {
    return repository.findById(id);
  }

  Future<List<E>> findAll() {
    return repository.findAll();
  }

  Future<List<E>> findPendingSync() {
    return repository.findPendingSync();
  }
}
