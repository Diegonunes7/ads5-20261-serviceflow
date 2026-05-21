import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:serviceflow/app/core/base/base.provider.dart';
import 'package:serviceflow/app/core/helpers/app.config.dart';

import '../ordem_servico.model.dart';

class OrdemServicoProvider extends BaseProvider<OrdemServico> {
  OrdemServicoProvider();

  @override
  Future<bool> validateBeforeSync(OrdemServico entity) async {
    return entity.clienteId > 0 && entity.tecnicoId > 0 && entity.ativo == 1;
  }

  @override
  Future<bool> syncEntity(OrdemServico entity) async {
    if (_isPlaceholderApi()) return false;

    final fotoAntesBase64 = await _readFileAsBase64(entity.fotoAntes);
    final fotoDepoisBase64 = await _readFileAsBase64(entity.fotoDepois);

    final ordemPayload = Map<String, dynamic>.from(entity.toMap())
      ..remove('id')
      ..remove('is_sync')
      ..remove('foto_antes')
      ..remove('foto_depois')
      ..remove('assinatura');

    final payload = <String, dynamic>{
      'ordem_servico': ordemPayload,
      'foto_antes_base64': fotoAntesBase64,
      'foto_depois_base64': fotoDepoisBase64,
      'assinatura_base64': entity.assinatura,
    }..removeWhere((_, value) => value == null);

    try {
      await client.dio.post(
        '/ordens-servico',
        data: payload,
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

  Future<String?> _readFileAsBase64(String? filePath) async {
    if (filePath == null || filePath.trim().isEmpty) return null;

    final file = File(filePath);
    if (!await file.exists()) return null;

    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) return null;

    return base64Encode(bytes);
  }
}
