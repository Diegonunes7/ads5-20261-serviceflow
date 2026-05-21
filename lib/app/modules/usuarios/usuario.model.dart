import 'package:serviceflow/app/core/base/base.model.dart';

class Usuario extends BaseModel {
  final String supabaseId;
  final String email;
  final String nomeCompleto;
  final String grupoId;
  final String perfil;
  final DateTime? ultimoLogin;
  final String? avatarLocalPath;
  final String? configuracoes;
  final int ativo;

  const Usuario({
    int? id,
    int isSync = 0,
    DateTime? createdAt,
    required this.supabaseId,
    required this.email,
    required this.nomeCompleto,
    required this.grupoId,
    this.perfil = 'tecnico',
    this.ultimoLogin,
    this.avatarLocalPath,
    this.configuracoes,
    this.ativo = 1,
  }) : super(
          id: id,
          isSync: isSync,
          createdAt: createdAt,
        );

  Usuario.fromMap(Map<String, dynamic> map)
      : supabaseId = map['supabase_id']?.toString() ?? '',
        email = map['email']?.toString() ?? '',
        nomeCompleto = map['nome_completo']?.toString() ?? '',
        grupoId = map['grupo_id']?.toString() ?? '',
        perfil = map['perfil']?.toString() ?? 'tecnico',
        ultimoLogin = _parseDate(map['ultimo_login']),
        avatarLocalPath = map['avatar_local_path']?.toString(),
        configuracoes = map['configuracoes']?.toString(),
        ativo = _parseInt(map['ativo']) ?? 1,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'supabase_id': supabaseId,
      'email': email,
      'nome_completo': nomeCompleto,
      'grupo_id': grupoId,
      'perfil': perfil,
      'ultimo_login': ultimoLogin?.toIso8601String(),
      'avatar_local_path': avatarLocalPath,
      'configuracoes': configuracoes,
      'ativo': ativo,
    };
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
