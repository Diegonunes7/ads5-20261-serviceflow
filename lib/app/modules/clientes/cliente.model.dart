import 'package:serviceflow/app/core/models/base.model.dart';

class Cliente extends BaseModel {
  final String nome;
  final String email;
  final String telefone;

  Cliente({
    String? id,
    DateTime? createdAt,
    required this.nome,
    required this.email,
    required this.telefone,
  }) : super(id: id, createdAt: createdAt);

  // Construtor nomeado para criar um Cliente a partir de um Map
  Cliente.fromMap(Map<String, dynamic> map)
      : nome = map['nome'] as String,
        email = map['email'] as String,
        telefone = map['telefone'] as String,
        super.fromMap(map); // Chama o construtor da base para id e createdAt

  // Método para converter os atributos do Cliente para Map
  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap(); // Obtém o Map da base
    return {
      ...baseMap, // Inclui os campos da base
      'nome': nome,
      'email': email,
      'telefone': telefone,
    };
  }
}
