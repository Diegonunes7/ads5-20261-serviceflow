import 'package:flutter/foundation.dart';

class MessageState {
  const MessageState({
    required this.text,
    required this.duration,
  });

  final String text;
  final Duration duration;
}

mixin MessagesMixin on ChangeNotifier {
  MessageState? _successMessage;
  MessageState? _warningMessage;
  MessageState? _errorMessage;

  MessageState? get successMessage => _successMessage;
  MessageState? get warningMessage => _warningMessage;
  MessageState? get errorMessage => _errorMessage;

  void showSuccess(String message) {
    _successMessage = MessageState(
      text: message,
      duration: const Duration(seconds: 3),
    );
    notifyListeners();
  }

  void showWarning(String message) {
    _warningMessage = MessageState(
      text: message,
      duration: const Duration(seconds: 4),
    );
    notifyListeners();
  }

  void showError(String message) {
    _errorMessage = MessageState(
      text: message,
      duration: Duration.zero,
    );
    notifyListeners();
  }

  void clearMessages() {
    _successMessage = null;
    _warningMessage = null;
    _errorMessage = null;
    notifyListeners();
  }
}
