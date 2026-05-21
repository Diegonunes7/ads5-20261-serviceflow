import 'package:flutter/foundation.dart';

mixin LoaderMixin on ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void startLoading() {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    if (!_isLoading) return;
    _isLoading = false;
    notifyListeners();
  }
}
