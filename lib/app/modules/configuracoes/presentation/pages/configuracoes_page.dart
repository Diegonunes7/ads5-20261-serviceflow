import 'package:flutter/material.dart';

import '../../../../shared/pages/em_desenvolvimento_page.dart';

class ConfiguracoesPage extends StatelessWidget {
  const ConfiguracoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmDesenvolvimentoPage(
      titulo: 'Configuracoes',
      descricao:
          'A pagina de configuracoes reunira preferencias locais e parametros de sincronizacao.',
    );
  }
}
