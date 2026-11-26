import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/phone_normalizer.dart';
import '../../../state/app_scope.dart';

/// Reusable, professional OTP verification screen.
/// Features 6 auto-advancing digit boxes, masked phone, cooldown timer,
/// attempt tracking, and Academic Demo indicator.
class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.onVerified,
    this.title = 'تأكيد رقم الهاتف',
    this.description = 'أدخل رمز التحقق المرسل إلى رقم هاتفك',
  });

  final String phoneNumber;
  final VoidCallback onVerified;
  final String title;
  final String description;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _digitControllers =
      List<TextEditingController>.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List<FocusNode>.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _secondsRemaining = AppConstants.otpRetrySeconds;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = AppConstants.otpRetrySeconds;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (_secondsRemaining > 1) {
        setState(() => _secondsRemaining--);
      } else {
        t.cancel();
        setState(() => _canResend = true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final TextEditingController c in _digitControllers) {
      c.dispose();
    }
    for (final FocusNode f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _currentCode =>
      _digitControllers.map((TextEditingController c) => c.text).join();

  Future<void> _verify() async {
    final String code = _currentCode;
    if (code.length != AppConstants.otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال رمز التحقق كاملًا (6 أرقام)')),
      );
      return;
    }

    final authController = AppScope.of(context).authController;
    final bool ok = await authController.verifyOtp(code);
    if (ok && mounted) {
      widget.onVerified();
    }
  }

  Future<void> _resend() async {
    final authController = AppScope.of(context).authController;
    final bool ok = await authController.resendActiveOtp();
    if (ok && mounted) {
      _startCountdown();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال رمز تحقق جديد بنجاح')),
      );
    }
  }

  void _fillTestCode() {
    const String testCode = AppConstants.demoOtpCode;
    for (int i = 0; i < 6; i++) {
      _digitControllers[i].text = testCode[i];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final container = AppScope.of(context);
    final authController = container.authController;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final String masked = PhoneNormalizer.maskPhone(widget.phoneNumber);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: authController,
          builder: (BuildContext context, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.mark_email_read_outlined, size: 36, color: scheme.primary),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      masked,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.emeraldPrimary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Demo test banner with click-to-fill
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.goldSoft,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.goldAccent),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.school_outlined, color: AppColors.navyPrimary, size: 20),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'وضع العرض الأكاديمي: رمز التحقق هو 123456',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navyPrimary,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _fillTestCode,
                          child: const Text('تعبئة سريعة'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 6 Digit Input Boxes
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List<Widget>.generate(6, (int i) {
                        return SizedBox(
                          width: 48,
                          height: 56,
                          child: TextFormField(
                            controller: _digitControllers[i],
                            focusNode: _focusNodes[i],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                            maxLength: 1,
                            decoration: InputDecoration(
                              counterText: '',
                              contentPadding: EdgeInsets.zero,
                              fillColor: scheme.surface,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onChanged: (String val) {
                              if (val.isNotEmpty && i < 5) {
                                _focusNodes[i + 1].requestFocus();
                              } else if (val.isEmpty && i > 0) {
                                _focusNodes[i - 1].requestFocus();
                              }
                              setState(() {});
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (authController.errorMessage != null) ...<Widget>[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.errorSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        authController.errorMessage!,
                        style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Timer & Resend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (!_canResend) ...<Widget>[
                        const Icon(Icons.timer_outlined, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'إعادة إرسال الرمز بعد $_secondsRemaining ثانية',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ] else ...<Widget>[
                        TextButton.icon(
                          onPressed: authController.isLoading ? null : _resend,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('إعادة إرسال الرمز الآن'),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: authController.isLoading ? null : _verify,
                    child: authController.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                          )
                        : const Text('تأكيد ومتابعة'),
                  ),
                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('تغيير رقم الهاتف'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
