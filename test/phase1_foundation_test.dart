import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yemen_pay/app.dart';
import 'package:yemen_pay/core/di/service_locator.dart';
import 'package:yemen_pay/core/enums/app_enums.dart';
import 'package:yemen_pay/core/utils/formatters.dart';
import 'package:yemen_pay/domain/models/models.dart';
import 'package:yemen_pay/services/transactions/transaction_service.dart';

void main() {
  group('Phase 1 Formatters & Validation', () {
    test('validates Yemeni +967XXXXXXXXX phone format', () {
      expect(AppFormatters.isValidYemenPhone('+967771234567'), isTrue);
      expect(AppFormatters.isValidYemenPhone('+967711112233'), isTrue);
      expect(AppFormatters.isValidYemenPhone('771234567'), isFalse);
      expect(AppFormatters.isValidYemenPhone('+966501234567'), isFalse);
      expect(AppFormatters.isValidYemenPhone('+96777123'), isFalse);
    });

    test('formats simulated currency amounts cleanly', () {
      expect(AppFormatters.formatAmount(245500, currencyCode: 'YER'), '245,500 ر.ي');
      expect(AppFormatters.formatAmount(120.5, currencyCode: 'USD'), '120.5 دولار');
      expect(AppFormatters.maskBalance('YER'), '•••••• ر.ي');
    });
  });

  group('Phase 1 Models Serialization', () {
    test('User and Wallet JSON round-trip preserves fields', () {
      final User user = User(
        id: 'u1',
        fullName: 'سارة علي',
        phoneNumber: '+967770001122',
        role: UserRole.customer,
        status: AccountStatus.active,
        createdAt: DateTime(2026, 2, 1),
        hasPin: true,
        isDemoUser: true,
      );
      final User restoredUser = User.fromJson(user.toJson());
      expect(restoredUser.id, user.id);
      expect(restoredUser.fullName, user.fullName);
      expect(restoredUser.phoneNumber, user.phoneNumber);
      expect(restoredUser.role, UserRole.customer);

      final Wallet wallet = Wallet(
        walletId: 'YP-YE-0001',
        userId: 'u1',
        primaryCurrency: CurrencyCode.yer,
        balance: 50000,
        availableBalance: 45000,
        pendingBalance: 5000,
        status: WalletStatus.active,
        createdAt: DateTime(2026, 2, 1),
      );
      final Wallet restoredWallet = Wallet.fromJson(wallet.toJson());
      expect(restoredWallet.walletId, wallet.walletId);
      expect(restoredWallet.balance, 50000);
      expect(restoredWallet.pendingBalance, 5000);
    });

    test('SyncQueueItem JSON round-trip preserves conflict metadata', () {
      final SyncQueueItem item = SyncQueueItem(
        transactionId: 'TX-1',
        deviceId: 'DEV-1',
        userId: 'u1',
        operationType: SyncOperationType.transfer,
        amount: 10000,
        currency: CurrencyCode.yer,
        timestamp: DateTime(2026, 3, 1, 10, 0),
        payload: const <String, dynamic>{'receiver': 'YP-YE-0002'},
        status: SyncStatus.conflict,
        retryCount: 2,
        conflictReason: SyncConflictReason.staleWalletState,
      );
      final SyncQueueItem restored = SyncQueueItem.fromJson(item.toJson());
      expect(restored.status, SyncStatus.conflict);
      expect(restored.conflictReason, SyncConflictReason.staleWalletState);
      expect(restored.retryCount, 2);
    });
  });

  group('Phase 1 Service Abstractions (Demo Mode)', () {
    test('DemoAuthService manages OTP session lifecycle', () async {
      final ServiceLocator services = ServiceLocator();
      final OtpSession sent = await services.authService.sendOtp(
        phoneNumber: '+967771234567',
      );
      expect(sent.status, OtpVerificationStatus.sent);
      expect(sent.isDemoMode, isTrue);

      final OtpSession verified = await services.authService.verifyOtp(
        otpSessionId: sent.otpSessionId,
        code: '123456',
      );
      expect(verified.status, OtpVerificationStatus.verified);
    });

    test('DemoTransactionService prevents duplicate idempotency keys', () async {
      final ServiceLocator services = ServiceLocator();
      const TransactionRequest request = TransactionRequest(
        idempotencyKey: 'idem-test-1',
        type: TransactionType.transfer,
        senderWalletId: 'YP-YE-104892',
        receiverWalletId: 'YP-YE-999999',
        amount: 5000,
        currency: CurrencyCode.yer,
        source: TransactionSource.demo,
        deviceId: 'dev-test',
      );
      final Transaction first =
          await services.transactionService.executeTransaction(request);
      final Transaction second =
          await services.transactionService.executeTransaction(request);
      expect(first.transactionId, second.transactionId);
    });

    test('DemoSyncService synchronizes pending items in storage', () async {
      final ServiceLocator services = ServiceLocator();
      await services.syncService.enqueueOperation(
        SyncQueueItem(
          transactionId: 'TX-OFF-1',
          deviceId: 'dev-1',
          userId: 'demo-user-001',
          operationType: SyncOperationType.qrPayment,
          amount: 2500,
          currency: CurrencyCode.yer,
          timestamp: DateTime(2026, 4, 1),
          payload: const <String, dynamic>{},
          status: SyncStatus.pending,
        ),
      );
      final report = await services.syncService.synchronizePendingOperations();
      expect(report.syncedCount, 1);
    });
  });

  group('Phase 1 Widget Flow & RTL Shell', () {
    testWidgets('Splash transitions to Onboarding, skips to RTL Main Shell, and navigates tabs',
        (WidgetTester tester) async {
      final ServiceLocator services = ServiceLocator();
      await tester.pumpWidget(
        YemenPayApp(
          serviceLocator: services,
          splashDelay: Duration.zero,
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('محفظتك الذكية في اليمن'), findsOneWidget);

      // Skip onboarding to enter MainNavigationShell
      await tester.tap(find.text('تخطي'));
      await tester.pumpAndSettle();

      // Verify Arabic RTL navigation destinations
      expect(find.text('الرئيسية'), findsOneWidget);
      expect(find.text('المحفظة'), findsOneWidget);
      expect(find.text('العمليات'), findsOneWidget);
      expect(find.text('الخدمات'), findsOneWidget);
      expect(find.text('الحساب'), findsOneWidget);

      // Verify RTL Directionality
      final Directionality dir = tester.widget<Directionality>(
        find.byType(Directionality).first,
      );
      expect(dir.textDirection, TextDirection.rtl);

      // Switch to Account tab and toggle Dark Mode
      await tester.tap(find.text('الحساب'));
      await tester.pumpAndSettle();
      expect(find.text('الوضع الداكن'), findsOneWidget);
    });
  });
}
