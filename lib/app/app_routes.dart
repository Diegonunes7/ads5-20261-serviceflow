import 'package:flutter/material.dart';

import 'modules/clientes/presentation/pages/clientes_page.dart';
import 'modules/configuracoes/presentation/pages/configuracoes_page.dart';
import 'modules/estoque/presentation/pages/estoque_page.dart';
import 'modules/home/presentation/pages/home_page.dart';
import 'modules/laboratorio/presentation/pages/laboratorio_page.dart';
import 'modules/ordens_servico/presentation/pages/ordens_servico_page.dart';
import 'modules/relatorios/presentation/pages/relatorios_page.dart';
import 'modules/sincronizacao/presentation/pages/sync_queue_page.dart';
import 'modules/splash/presentation/pages/splash_page.dart';
import 'modules/auth/presentation/pages/login_page.dart';
import 'modules/tecnicos/presentation/pages/tecnicos_page.dart';
import 'modules/usuarios/presentation/pages/usuarios_page.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/auth/login';
  static const dashboard = '/dashboard';
  static const clientes = '/clientes';
  static const tecnicos = '/tecnicos';
  static const usuarios = '/usuarios';
  static const ordensServico = '/ordens-servico';
  static const relatorios = '/relatorios';
  static const syncQueue = '/sync-queue';
  static const laboratorio = '/laboratorio';
  static const estoque = '/estoque';
  static const configuracoes = '/configuracoes';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashPage(),
        login: (_) => const LoginPage(),
        dashboard: (_) => const HomePage(),
        clientes: (_) => const ClientesPage(),
        tecnicos: (_) => const TecnicosPage(),
        usuarios: (_) => const UsuariosPage(),
        ordensServico: (_) => const OrdensServicoPage(),
        relatorios: (_) => const RelatoriosPage(),
        syncQueue: (_) => const SyncQueuePage(),
        laboratorio: (_) => const LaboratorioPage(),
        estoque: (_) => const EstoquePage(),
        configuracoes: (_) => const ConfiguracoesPage(),
      };
}
