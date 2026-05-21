import 'package:serviceflow/app/core/base/base.model.dart';

class Cliente extends BaseModel {
  final String nome;
  final String email;
  final String telefone;

  const Cliente({
    int? id,
    int isSync = 0,
    DateTime? createdAt,
    required this.nome,
    required this.email,
    required this.telefone,
  }) : super(
          id: id,
          isSync: isSync,
          createdAt: createdAt,
        );

  Cliente.fromMap(Map<String, dynamic> map)
      : nome = map['nome'] as String,
        email = map['email'] as String,
        telefone = map['telefone'] as String,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'nome': nome,
      'email': email,
      'telefone': telefone,
    };
  }
}
