import 'package:flutter/material.dart';

import '../../../../shared/pages/em_desenvolvimento_page.dart';

class RelatoriosPage extends StatelessWidget {
  const RelatoriosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmDesenvolvimentoPage(
      titulo: 'Relatorios',
      descricao:
          'Este modulo exibira metricas e indicadores do ServiceFlow em uma dashboard dedicada.',
    );
  }
}
