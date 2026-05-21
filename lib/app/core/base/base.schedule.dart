import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../helpers/app.config.dart';
import 'base.model.dart';
import 'base.provider.dart';
import 'base.repository.dart';

abstract class BaseSchedule<E extends BaseModel, R extends BaseRepository<E>,
    P extends BaseProvider<E>> {
  BaseSchedule({
    required this.repository,
    required this.provider,
    Duration? interval,
    Connectivity? connectivity,
  })  : interval = interval ?? AppConfig.syncInterval,
        _connectivity = connectivity ?? Connectivity();

  final R repository;
  final P provider;
  final Duration interval;
  final Connectivity _connectivity;

  Timer? _timer;

  bool get isRunning => _timer != null;

  void start() {
    if (_timer != null) return;
    _timer = Timer.periodic(interval, (_) => syncNow());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<int> syncNow() async {
    if (!await _hasConnection()) return 0;

    final pending = await repository.findPendingSync();
    var syncedCount = 0;

    for (final entity in pending) {
      final canSync = await provider.validateBeforeSync(entity);
      if (!canSync) continue;

      final synced = await provider.syncEntity(entity);
      if (synced && entity.id != null) {
        await repository.markAsSynced(entity.id!);
        syncedCount++;
      }
    }

    return syncedCount;
  }

  Future<bool> _hasConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
