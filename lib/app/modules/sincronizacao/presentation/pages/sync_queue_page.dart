import 'package:flutter/material.dart';

import '../../../../core/services/sync_queue_service.dart';
import '../../../../core/services/sync_system_initializer.dart';

class SyncQueuePage extends StatefulWidget {
  const SyncQueuePage({super.key});

  @override
  State<SyncQueuePage> createState() => _SyncQueuePageState();
}

class _SyncQueuePageState extends State<SyncQueuePage> {
  final SyncQueueService _queueService = SyncQueueService();
  bool _isLoading = false;
  bool _isSyncing = false;
  List<SyncQueueItem> _queue = const [];
  int _totalPending = 0;
  DateTime? _lastRefresh;

  @override
  void initState() {
    super.initState();
    _loadQueue();
  }

  Future<void> _loadQueue() async {
    setState(() => _isLoading = true);
    try {
      final queue = await _queueService.getPendingQueue();
      final total = queue.fold<int>(0, (sum, item) => sum + item.pendingCount);

      if (!mounted) return;
      setState(() {
        _queue = queue;
        _totalPending = total;
        _lastRefresh = DateTime.now();
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Falha ao carregar fila de sincronizacao.'),
            backgroundColor: Colors.red,
          ),
        );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _syncNow() async {
    if (_isSyncing) return;

    setState(() => _isSyncing = true);
    try {
      final syncedByFeature = await SyncSystemInitializer.forceSyncAll();
      final totalSynced =
          syncedByFeature.values.fold<int>(0, (sum, value) => sum + value);

      if (!mounted) return;
      await _loadQueue();
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
            content: Text('Falha ao sincronizar agora.'),
            backgroundColor: Colors.red,
          ),
        );
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  String _formatLastRefresh() {
    final value = _lastRefresh;
    if (value == null) return '--';

    final hh = value.hour.toString().padLeft(2, '0');
    final mm = value.minute.toString().padLeft(2, '0');
    final ss = value.second.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }

  Color _statusColor(int count) {
    if (count == 0) return Colors.green.shade700;
    if (count <= 5) return Colors.orange.shade700;
    return Colors.red.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fila de Sincronizacao')),
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
                        'Pendencias Offline',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text('Total pendente: $_totalPending'),
                      Text('Ultima atualizacao: ${_formatLastRefresh()}'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isLoading ? null : _loadQueue,
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: _queue.isEmpty
                  ? const Center(
                      child: Text('Nenhuma tabela monitorada.'),
                    )
                  : ListView.builder(
                      itemCount: _queue.length,
                      itemBuilder: (context, index) {
                        final item = _queue[index];
                        final color = _statusColor(item.pendingCount);
                        final statusText =
                            item.pendingCount == 0 ? 'Em dia' : 'Pendente';

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: color.withOpacity(0.15),
                            child: Icon(
                              item.pendingCount == 0
                                  ? Icons.check
                                  : Icons.schedule,
                              color: color,
                            ),
                          ),
                          title: Text(item.label),
                          subtitle: Text(
                            'Tabela: ${item.tableName}\nStatus: $statusText',
                          ),
                          trailing: Text(
                            item.pendingCount.toString(),
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          isThreeLine: true,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
