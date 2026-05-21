import 'package:flutter_test/flutter_test.dart';
import 'package:serviceflow/app/app_routes.dart';

void main() {
  test('deve registrar rotas principais da aplicacao', () {
    final routes = AppRoutes.routes;

    expect(routes.containsKey(AppRoutes.splash), isTrue);
    expect(routes.containsKey(AppRoutes.login), isTrue);
    expect(routes.containsKey(AppRoutes.dashboard), isTrue);
    expect(routes.containsKey(AppRoutes.clientes), isTrue);
    expect(routes.containsKey(AppRoutes.tecnicos), isTrue);
    expect(routes.containsKey(AppRoutes.usuarios), isTrue);
    expect(routes.containsKey(AppRoutes.ordensServico), isTrue);
    expect(routes.containsKey(AppRoutes.syncQueue), isTrue);
  });
}
