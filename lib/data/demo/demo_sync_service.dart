import '../../core/enums/app_enums.dart';
import '../../domain/models/models.dart';
import '../../services/storage/local_storage_service.dart';
import '../../services/sync/sync_service.dart';

/// Phase 1 simulated implementation of [SyncService].
/// Full automatic background sync & server conflict resolution arrive in Phase 7.
class DemoSyncService implements SyncService {
  DemoSyncService(this._localStorage);

  final LocalStorageService _localStorage;

  @override
  Future<List<SyncQueueItem>> getPendingQueue() async {
    return _localStorage.getSyncQueue();
  }

  @override
  Future<void> enqueueOperation(SyncQueueItem item) async {
    await _localStorage.upsertSyncQueueItem(item);
  }

  @override
  Future<SyncBatchReport> synchronizePendingOperations() async {
    final List<SyncQueueItem> queue = await _localStorage.getSyncQueue();
    int synced = 0;
    for (final SyncQueueItem item in queue) {
      if (item.status == SyncStatus.pending) {
        await _localStorage.upsertSyncQueueItem(
          item.copyWith(
            status: SyncStatus.synced,
            syncTimestamp: DateTime.now(),
          ),
        );
        synced++;
      }
    }
    return SyncBatchReport(
      processedCount: queue.length,
      syncedCount: synced,
      conflictCount: 0,
      failedCount: 0,
      completedAt: DateTime.now(),
    );
  }

  @override
  Future<void> resolveConflict({
    required String transactionId,
    required bool acceptServerState,
  }) async {
    if (acceptServerState) {
      await _localStorage.removeSyncQueueItem(transactionId);
    }
  }
}
