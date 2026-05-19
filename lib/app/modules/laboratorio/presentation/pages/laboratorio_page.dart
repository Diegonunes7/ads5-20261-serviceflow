import 'package:flutter/material.dart';

import '../../../../shared/pages/em_desenvolvimento_page.dart';

class LaboratorioPage extends StatelessWidget {
  const LaboratorioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmDesenvolvimentoPage(
      titulo: 'Laboratorio',
      descricao:
          'Aqui vamos validar camera, assinatura e conectividade para os fluxos de campo.',
    );
  }
}
