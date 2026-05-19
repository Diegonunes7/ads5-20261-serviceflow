import 'package:flutter/material.dart';

import '../../../../shared/pages/em_desenvolvimento_page.dart';

class OrdensServicoPage extends StatelessWidget {
  const OrdensServicoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmDesenvolvimentoPage(
      titulo: 'Ordens de Servico',
      descricao:
          'Este modulo sera implementado com fluxo offline-first e sincronizacao em background.',
    );
  }
}
