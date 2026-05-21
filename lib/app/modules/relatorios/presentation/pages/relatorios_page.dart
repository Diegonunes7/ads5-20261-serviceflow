import 'package:flutter/material.dart';

import '../../../../app_routes.dart';
import '../../../../core/services/reporting_service.dart';

class RelatoriosPage extends StatefulWidget {
  const RelatoriosPage({super.key});

  @override
  State<RelatoriosPage> createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {
  final ReportingService _reportingService = ReportingService();
  bool _isLoading = false;
  ReportingSnapshot? _snapshot;

  @override
  void initState() {
    super.initState();
    _loadSnapshot();
  }

  Future<void> _loadSnapshot() async {
    setState(() => _isLoading = true);
    try {
      final snapshot = await _reportingService.loadSnapshot();
      if (!mounted) return;
      setState(() => _snapshot = snapshot);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Falha ao carregar relatorios locais.'),
            backgroundColor: Colors.red,
          ),
        );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatTime(DateTime? value) {
    if (value == null) return '--';

    final hh = value.hour.toString().padLeft(2, '0');
    final mm = value.minute.toString().padLeft(2, '0');
    final ss = value.second.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }

  Widget _buildKpiTile({
    required String title,
    required int value,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              child: Icon(icon),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title),
            ),
            Text(
              value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _labelFromModuleKey(String key) {
    switch (key) {
      case 'clientes':
        return 'Clientes';
      case 'tecnicos':
        return 'Tecnicos';
      case 'usuarios':
        return 'Usuarios';
      case 'ordens_servico':
        return 'Ordens de Servico';
      case 'os_itens':
        return 'Itens da O.S.';
      case 'servicos':
        return 'Servicos';
      case 'system_logs':
        return 'Logs do Sistema';
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = _snapshot;

    return Scaffold(
      appBar: AppBar(title: const Text('Relatorios')),
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
                        'Resumo Operacional Local',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text('Ultima atualizacao: ${_formatTime(snapshot?.generatedAt)}'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isLoading ? null : _loadSnapshot,
                              icon: _isLoading
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.refresh),
                              label: const Text('Atualizar'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                AppRoutes.syncQueue,
                              ),
                              icon: const Icon(Icons.list_alt_outlined),
                              label: const Text('Fila de sync'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: snapshot == null
                  ? const Center(
                      child: Text('Nenhum dado carregado ainda.'),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        _buildKpiTile(
                          title: 'Clientes cadastrados',
                          value: snapshot.totalClientes,
                          icon: Icons.people_alt_outlined,
                        ),
                        _buildKpiTile(
                          title: 'Tecnicos cadastrados',
                          value: snapshot.totalTecnicos,
                          icon: Icons.engineering_outlined,
                        ),
                        _buildKpiTile(
                          title: 'Usuarios cadastrados',
                          value: snapshot.totalUsuarios,
                          icon: Icons.badge_outlined,
                        ),
                        _buildKpiTile(
                          title: 'Ordens de servico',
                          value: snapshot.totalOrdensServico,
                          icon: Icons.assignment_turned_in_outlined,
                        ),
                        _buildKpiTile(
                          title: 'Pendencias de sincronizacao',
                          value: snapshot.totalPendencias,
                          icon: Icons.sync_problem_outlined,
                        ),
                        const SizedBox(height: 8),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pendencias por modulo',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                ...snapshot.pendingByModule.entries.map(
                                  (entry) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _labelFromModuleKey(entry.key),
                                          ),
                                        ),
                                        Text(
                                          entry.value.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
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
          ],
        ),
      ),
    );
  }
}
