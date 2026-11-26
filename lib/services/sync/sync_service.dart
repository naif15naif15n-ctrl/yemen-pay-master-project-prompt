import '../../domain/models/models.dart';

/// Summary of a sync batch execution.
class SyncBatchReport {
  const SyncBatchReport({
    required this.processedCount,
    required this.syncedCount,
    required this.conflictCount,
    required this.failedCount,
    required this.completedAt,
  });

  final int processedCount;
  final int syncedCount;
  final int conflictCount;
  final int failedCount;
  final DateTime completedAt;
}

/// Synchronization service abstraction for Offline-First operation.
/// Handles queueing, idempotent replay, and explicit conflict reporting.
abstract interface class SyncService {
  Future<List<SyncQueueItem>> getPendingQueue();

  Future<void> enqueueOperation(SyncQueueItem item);

  Future<SyncBatchReport> synchronizePendingOperations();

  Future<void> resolveConflict({
    required String transactionId,
    required bool acceptServerState,
  });
}
