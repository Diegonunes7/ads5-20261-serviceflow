import 'package:flutter/material.dart';
import 'package:serviceflow/app/core/services/auth_service.dart';
import 'package:serviceflow/app/core/services/demo_seed_service.dart';
import 'package:serviceflow/app/core/services/sync_system_initializer.dart';

import '../../../../app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final DemoSeedService _demoSeedService = DemoSeedService();
  bool _isSyncing = false;
  bool _isSeeding = false;
  String _syncSummary = 'Nenhuma sincronizacao manual executada.';
  String? _loggedUserEmail;

  @override
  void initState() {
    super.initState();
    _loadSessionInfo();
  }

  Future<void> _loadSessionInfo() async {
    final email = await _authService.getStoredEmail();
    if (!mounted) return;
    setState(() => _loggedUserEmail = email);
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (_) => false,
    );
  }

  Future<void> _syncNow() async {
    if (_isSyncing) return;

    setState(() => _isSyncing = true);
    try {
      final result = await SyncSystemInitializer.forceSyncAll();
      final totalSynced = result.values.fold<int>(0, (sum, value) => sum + value);
      final summary = result.entries.map((e) => '${e.key}: ${e.value}').join(' | ');

      if (!mounted) return;
      setState(() {
        _syncSummary = summary.isEmpty ? 'Nenhuma feature registrada.' : summary;
      });

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text('Sincronizacao concluida. Itens enviados: $totalSynced'),
          ),
        );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Falha ao executar sincronizacao manual.'),
            backgroundColor: Colors.red,
          ),
        );
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  Future<void> _seedDemoData() async {
    if (_isSeeding) return;

    setState(() => _isSeeding = true);
    try {
      final result = await _demoSeedService.seedBasicData();
      if (!mounted) return;

      final summary = 'clientes: ${result.clientesCriados}, '
          'tecnicos: ${result.tecnicosCriados}, '
          'ordens: ${result.ordensCriadas}';

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text('Dados demo gerados ($summary).'),
          ),
        );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Falha ao gerar dados de demonstracao.'),
            backgroundColor: Colors.red,
          ),
        );
    } finally {
      if (mounted) {
        setState(() => _isSeeding = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = SyncSystemInitializer.getStatus();
    final registeredCount = status['registered_count'] as int? ?? 0;
    final runningCount = status['running_count'] as int? ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ServiceFlow - Dashboard'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sincronizacao',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text('Features registradas: $registeredCount'),
                      Text('Schedules ativos: $runningCount'),
                      if (_loggedUserEmail != null && _loggedUserEmail!.isNotEmpty)
                        Text('Usuario: $_loggedUserEmail'),
                      const SizedBox(height: 8),
                      Text(
                        _syncSummary,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isSyncing ? null : _syncNow,
                          icon: _isSyncing
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.sync),
                          label: Text(
                            _isSyncing ? 'Sincronizando...' : 'Sincronizar agora',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.syncQueue),
                          icon: const Icon(Icons.list_alt_outlined),
                          label: const Text('Ver fila de sincronizacao'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _isSeeding ? null : _seedDemoData,
                          icon: _isSeeding
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.dataset_linked_outlined),
                          label: Text(
                            _isSeeding
                                ? 'Gerando dados demo...'
                                : 'Gerar dados demo',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.all(16),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: const [
                  _MenuCard(
                    titulo: 'Clientes',
                    icone: Icons.people_alt_outlined,
                    rota: AppRoutes.clientes,
                  ),
                  _MenuCard(
                    titulo: 'Tecnicos',
                    icone: Icons.engineering_outlined,
                    rota: AppRoutes.tecnicos,
                  ),
                  _MenuCard(
                    titulo: 'Usuarios',
                    icone: Icons.badge_outlined,
                    rota: AppRoutes.usuarios,
                  ),
                  _MenuCard(
                    titulo: 'Ordem de Servico',
                    icone: Icons.assignment_turned_in_outlined,
                    rota: AppRoutes.ordensServico,
                  ),
                  _MenuCard(
                    titulo: 'Relatorios',
                    icone: Icons.bar_chart_rounded,
                    rota: AppRoutes.relatorios,
                  ),
                  _MenuCard(
                    titulo: 'Laboratorio',
                    icone: Icons.science_rounded,
                    rota: AppRoutes.laboratorio,
                  ),
                  _MenuCard(
                    titulo: 'Estoque',
                    icone: Icons.inventory_2_outlined,
                    rota: AppRoutes.estoque,
                  ),
                  _MenuCard(
                    titulo: 'Configuracoes',
                    icone: Icons.settings_outlined,
                    rota: AppRoutes.configuracoes,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final String rota;

  const _MenuCard({
    required this.titulo,
    required this.icone,
    required this.rota,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(context, rota),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icone, size: 38),
              const SizedBox(height: 10),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
