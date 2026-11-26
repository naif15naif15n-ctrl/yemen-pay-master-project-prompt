import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/phone_normalizer.dart';
import '../../../state/app_scope.dart';
import 'complete_registration_screen.dart';
import 'otp_verification_screen.dart';

/// Registration Step 1: Input and validation of Yemeni mobile phone number.
class RegisterPhoneScreen extends StatefulWidget {
  const RegisterPhoneScreen({
    super.key,
    required this.onRegistrationSuccess,
  });

  final VoidCallback onRegistrationSuccess;

  @override
  State<RegisterPhoneScreen> createState() => _RegisterPhoneScreenState();
}

class _RegisterPhoneScreenState extends State<RegisterPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '778901234');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _requestOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final authController = AppScope.of(context).authController;
    final String raw = '+967${_phoneController.text.trim()}';

    final bool sent = await authController.sendRegistrationOtp(raw);
    if (sent && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => OtpVerificationScreen(
            phoneNumber: raw,
            title: 'تأكيد رقم الهاتف',
            onVerified: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => CompleteRegistrationScreen(
                    onRegistrationComplete: widget.onRegistrationSuccess,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final container = AppScope.of(context);
    final authController = container.authController;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب جديد'),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: authController,
          builder: (BuildContext context, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'الخطوة 1 من 3: رقم الهاتف',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.emeraldPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'أدخل رقم هاتفك اليمني',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'سنرسل رمز تحقق مكون من ${AppConstants.otpLength} أرقام لتأكيد ملكية الرقم.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),

                    // Phone input
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1),
                        decoration: InputDecoration(
                          labelText: 'رقم الهاتف اليمني',
                          hintText: '77XXXXXXX',
                          prefixIcon: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            width: 86,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text('🇾🇪', style: TextStyle(fontSize: 16)),
                                SizedBox(width: 4),
                                Text(
                                  '+967',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.emeraldPrimary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        validator: (String? val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'رقم الهاتف مطلوب';
                          }
                          return PhoneNormalizer.validateInput('+967$val');
                        },
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'يدعم شبكات: يمن موبايل (77)، يو (73)، سبأفون (71)، واي (70)',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 11),
                    ),

                    if (authController.errorMessage != null) ...<Widget>[
                      const SizedBox(height: 12),
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
                    ],

                    const SizedBox(height: 28),
                    ElevatedButton(
                      onPressed: authController.isLoading ? null : _requestOtp,
                      child: authController.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                            )
                          : const Text('إرسال رمز التحقق'),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: scheme.outline),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.goldAccent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'في وضع العرض الأكاديمي، رمز التحقق الافتراضي هو 123456.',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
