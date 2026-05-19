import 'package:flutter/material.dart';

import '../../../../shared/pages/em_desenvolvimento_page.dart';

class EstoquePage extends StatelessWidget {
  const EstoquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmDesenvolvimentoPage(
      titulo: 'Estoque',
      descricao:
          'O modulo de estoque controlara materiais e pecas com suporte a operacao offline.',
    );
  }
}
