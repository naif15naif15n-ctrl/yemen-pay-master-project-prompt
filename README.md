# Yemen Pay — يمن باي

> **محفظتك الذكية، حتى بدون إنترنت**

Yemen Pay is an academic university graduation project prototype demonstrating a modern, offline-first Yemeni electronic wallet built with **Flutter & Dart** targeting **Android**.

> ⚠️ **تنبيه أكاديمي / Academic Disclaimer**:  
> جميع العمليات المالية داخل هذا التطبيق **محاكاة تعليمية بالكامل** (أرصدة، تحويلات، إيداع، سحب، شحن، فواتير، ذهب، أصول رقمية، صرافة). لا يتصل التطبيق بأي بنوك أو شبكات دفع أو مزودي اتصالات أو خدمات حقيقية.

---

## Current Status: Phase 1 — Project Foundation

Phase 1 establishes:
- Clean modular Flutter architecture (`core`, `domain`, `services`, `data`, `state`, `presentation`)
- Arabic-first **RTL** layout with English localization readiness
- Light & Dark fintech themes (Deep Emerald Green, Dark Navy, Soft Neutral Grays)
- Custom Yemen Pay branding (`YemenPayLogo`), `SplashScreen`, and `OnboardingScreen`
- 5-tab `MainNavigationShell` (`الرئيسية`, `المحفظة`, `العمليات`, `الخدمات`, `الحساب`) + Global Notifications placeholder
- Complete domain model foundation (all 29 planned entities)
- Clean service abstractions & Demo implementations:
  - `LocalStorageService` / `InMemoryLocalStorageService`
  - `AuthService` / `DemoAuthService`
  - `TransactionService` / `DemoTransactionService`
  - `SyncService` / `DemoSyncService`
  - `ConnectionMonitorService` / `DemoConnectionMonitorService`
  - `LocalServerClient` / `DemoLocalServerClient`
- Clearly labeled **Demo Mode (`وضع تجريبي`)** & simulated connectivity switcher

---

## Running & Testing (on a Flutter-equipped machine)

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

If Android platform build files (such as `gradlew` / wrapper jar) are not yet initialized on your workstation, run once in the project root (without overwriting `lib/`):

```bash
flutter create --platforms=android --org com.yemenpay.app .
```
