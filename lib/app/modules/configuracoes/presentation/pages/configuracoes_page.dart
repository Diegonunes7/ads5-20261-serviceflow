import 'package:flutter/material.dart';
import 'package:serviceflow/app/core/helpers/app.config.dart';
import 'package:serviceflow/app/core/services/auth_service.dart';
import 'package:serviceflow/app/core/services/demo_seed_service.dart';
import 'package:serviceflow/app/core/services/sync_system_initializer.dart';

import '../../../../app_routes.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  final AuthService _authService = AuthService();
  final DemoSeedService _demoSeedService = DemoSeedService();

  bool _isLoadingSession = false;
  bool _isSyncing = false;
  bool _isGeneratingDemo = false;
  bool _isLoggingOut = false;

  String? _loggedUserEmail;
  Map<String, dynamic> _syncStatus = const {
    'registered_count': 0,
    'running_count': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoadingSession = true);
    try {
      final email = await _authService.getStoredEmail();
      if (!mounted) return;
      setState(() {
        _loggedUserEmail = email;
        _syncStatus = SyncSystemInitializer.getStatus();
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingSession = false);
      }
    }
  }

  Future<void> _refreshSyncStatus() async {
    if (!mounted) return;
    setState(() {
      _syncStatus = SyncSystemInitializer.getStatus();
    });
  }

  Future<void> _syncNow() async {
    if (_isSyncing) return;

    setState(() => _isSyncing = true);
    try {
      final result = await SyncSystemInitializer.forceSyncAll();
      final totalSynced = result.values.fold<int>(0, (sum, value) => sum + value);

      if (!mounted) return;
      await _refreshSyncStatus();
      if (!mounted) return;

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
            content: Text('Falha ao executar sincronizacao.'),
            backgroundColor: Colors.red,
          ),
        );
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  Future<void> _generateDemoData() async {
    if (_isGeneratingDemo) return;

    setState(() => _isGeneratingDemo = true);
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
        setState(() => _isGeneratingDemo = false);
      }
    }
  }

  Future<void> _logout() async {
    if (_isLoggingOut) return;

    setState(() => _isLoggingOut = true);
    try {
      await _authService.logout();
      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (_) => false,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Falha ao encerrar sessao.'),
            backgroundColor: Colors.red,
          ),
        );
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  bool _isPlaceholderApi() {
    return AppConfig.apiBaseUrl.contains('your-supabase-url');
  }

  @override
  Widget build(BuildContext context) {
    final registeredCount = _syncStatus['registered_count'] as int? ?? 0;
    final runningCount = _syncStatus['running_count'] as int? ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Configuracoes')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Conta',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Usuario atual: '
                      '${_isLoadingSession ? 'carregando...' : (_loggedUserEmail ?? 'nao identificado')}',
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _isLoggingOut ? null : _logout,
                        icon: _isLoggingOut
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.logout),
                        label: const Text('Encerrar sessao'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
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
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _refreshSyncStatus,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Atualizar status'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isSyncing ? null : _syncNow,
                        icon: _isSyncing
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.sync),
                        label: const Text('Sincronizar agora'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.syncQueue),
                        icon: const Icon(Icons.list_alt_outlined),
                        label: const Text('Abrir fila de sincronizacao'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ambiente e Ferramentas',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Modo de API: ${_isPlaceholderApi() ? 'Demonstracao local' : 'Remoto ativo'}',
                    ),
                    Text('Base URL: ${AppConfig.apiBaseUrl}'),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _isGeneratingDemo ? null : _generateDemoData,
                        icon: _isGeneratingDemo
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.dataset_linked_outlined),
                        label: Text(
                          _isGeneratingDemo
                              ? 'Gerando dados demo...'
                              : 'Gerar dados demo',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
