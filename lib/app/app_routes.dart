import 'package:flutter/material.dart';

import 'modules/configuracoes/presentation/pages/configuracoes_page.dart';
import 'modules/estoque/presentation/pages/estoque_page.dart';
import 'modules/home/presentation/pages/home_page.dart';
import 'modules/laboratorio/presentation/pages/laboratorio_page.dart';
import 'modules/ordens_servico/presentation/pages/ordens_servico_page.dart';
import 'modules/relatorios/presentation/pages/relatorios_page.dart';
import 'modules/splash/presentation/pages/splash_page.dart';
import 'modules/auth/presentation/pages/login_page.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/auth/login';
  static const dashboard = '/dashboard';
  static const ordensServico = '/ordens-servico';
  static const relatorios = '/relatorios';
  static const laboratorio = '/laboratorio';
  static const estoque = '/estoque';
  static const configuracoes = '/configuracoes';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashPage(),
        login: (_) => const LoginPage(),
        dashboard: (_) => const HomePage(),
        ordensServico: (_) => const OrdensServicoPage(),
        relatorios: (_) => const RelatoriosPage(),
        laboratorio: (_) => const LaboratorioPage(),
        estoque: (_) => const EstoquePage(),
        configuracoes: (_) => const ConfiguracoesPage(),
      };
}
