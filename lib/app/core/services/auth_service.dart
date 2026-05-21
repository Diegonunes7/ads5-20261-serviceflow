import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../helpers/app.config.dart';
import '../http/app_client.dart';

class AuthService {
  AuthService({
    FlutterSecureStorage? storage,
    AppClient? client,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _client = client ?? AppClient();

  final FlutterSecureStorage _storage;
  final AppClient _client;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPassword = password.trim();

    _validateCredentials(normalizedEmail, normalizedPassword);

    final token = await _resolveToken(
      email: normalizedEmail,
      password: normalizedPassword,
    );

    await _storage.write(key: AppConfig.tokenStorageKey, value: token);
    await _storage.write(
      key: AppConfig.userEmailStorageKey,
      value: normalizedEmail,
    );
    return true;
  }

  Future<void> logout() async {
    await _storage.delete(key: AppConfig.tokenStorageKey);
    await _storage.delete(key: AppConfig.userEmailStorageKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: AppConfig.tokenStorageKey);
    return token != null && token.isNotEmpty;
  }

  Future<String?> getStoredEmail() {
    return _storage.read(key: AppConfig.userEmailStorageKey);
  }

  Future<String> _resolveToken({
    required String email,
    required String password,
  }) async {
    if (_isPlaceholderApi()) {
      return 'local_token_${DateTime.now().millisecondsSinceEpoch}';
    }

    try {
      final response = await _client.dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final token = data['token']?.toString();
        if (token != null && token.isNotEmpty) {
          return token;
        }
      }

      throw Exception('Resposta de autenticacao sem token.');
    } on DioException catch (error) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final mensagem = data['mensagem']?.toString();
        if (mensagem != null && mensagem.isNotEmpty) {
          throw Exception(mensagem);
        }
      }
      throw Exception('Falha ao autenticar. Verifique suas credenciais.');
    }
  }

  void _validateCredentials(String email, String password) {
    if (email.isEmpty) {
      throw Exception('Informe seu e-mail.');
    }

    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(email)) {
      throw Exception('Informe um e-mail valido.');
    }

    if (password.isEmpty) {
      throw Exception('Informe sua senha.');
    }

    if (password.length < 4) {
      throw Exception('A senha precisa ter pelo menos 4 caracteres.');
    }
  }

  bool _isPlaceholderApi() {
    return AppConfig.apiBaseUrl.contains('your-supabase-url');
  }
}
