import 'package:serviceflow/app/core/base/base.model.dart';

class OrdemServico extends BaseModel {
  final int clienteId;
  final int tecnicoId;
  final String? observacao;
  final String? pecasAplicadas;
  final double valorPecas;
  final String? fotoAntes;
  final String? fotoDepois;
  final String? assinatura;
  final int ativo;

  const OrdemServico({
    int? id,
    int isSync = 0,
    DateTime? createdAt,
    required this.clienteId,
    required this.tecnicoId,
    this.observacao,
    this.pecasAplicadas,
    this.valorPecas = 0,
    this.fotoAntes,
    this.fotoDepois,
    this.assinatura,
    this.ativo = 1,
  }) : super(
          id: id,
          isSync: isSync,
          createdAt: createdAt,
        );

  OrdemServico.fromMap(Map<String, dynamic> map)
      : clienteId = _toInt(map['cliente_id']) ?? 0,
        tecnicoId = _toInt(map['tecnico_id']) ?? 0,
        observacao = map['observacao']?.toString(),
        pecasAplicadas = map['pecas_aplicadas']?.toString(),
        valorPecas = _toDouble(map['valor_pecas']) ?? 0,
        fotoAntes = map['foto_antes']?.toString(),
        fotoDepois = map['foto_depois']?.toString(),
        assinatura = map['assinatura']?.toString(),
        ativo = _toInt(map['ativo']) ?? 1,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'cliente_id': clienteId,
      'tecnico_id': tecnicoId,
      'observacao': observacao,
      'pecas_aplicadas': pecasAplicadas,
      'valor_pecas': valorPecas,
      'foto_antes': fotoAntes,
      'foto_depois': fotoDepois,
      'assinatura': assinatura,
      'ativo': ativo,
    };
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
