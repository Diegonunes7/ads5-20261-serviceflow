import 'package:flutter/foundation.dart';

import '../mixins/loader.mixin.dart';
import '../mixins/messages.mixin.dart';
import 'base.model.dart';
import 'base.repository.dart';
import 'base.service.dart';
import 'base.validation.dart';

abstract class BaseController<E extends BaseModel, R extends BaseRepository<E>,
        V extends BaseValidation<E, R>, S extends BaseService<E, R, V>>
    extends ChangeNotifier with LoaderMixin, MessagesMixin {
  BaseController(this.service);

  final S service;
  String? _lastError;

  String? get lastError => _lastError;

  Future<T?> executeOperation<T>(
    Future<T> Function() action, {
    String? successMessage,
    String? errorMessage,
  }) async {
    startLoading();
    clearMessages();
    _lastError = null;

    try {
      final result = await action();
      if (successMessage != null && successMessage.isNotEmpty) {
        showSuccess(successMessage);
      }
      return result;
    } catch (error) {
      _lastError = error.toString();
      showError(errorMessage ?? _lastError!);
      return null;
    } finally {
      stopLoading();
    }
  }

  Future<void> executeCrudOperation(
    Future<void> Function() action, {
    String? successMessage,
    String? errorMessage,
  }) async {
    await executeOperation<void>(
      action,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}
