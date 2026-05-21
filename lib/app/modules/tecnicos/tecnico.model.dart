import 'package:serviceflow/app/core/base/base.model.dart';

class Tecnico extends BaseModel {
  final String nome;
  final String? especialidade;
  final int ativo;

  const Tecnico({
    int? id,
    int isSync = 0,
    DateTime? createdAt,
    required this.nome,
    this.especialidade,
    this.ativo = 1,
  }) : super(
          id: id,
          isSync: isSync,
          createdAt: createdAt,
        );

  Tecnico.fromMap(Map<String, dynamic> map)
      : nome = map['nome'] as String,
        especialidade = map['especialidade']?.toString(),
        ativo = _toInt(map['ativo']) ?? 1,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'nome': nome,
      'especialidade': especialidade,
      'ativo': ativo,
    };
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
