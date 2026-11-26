import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/phone_normalizer.dart';
import '../../../state/app_scope.dart';
import 'otp_verification_screen.dart';

/// Forgot PIN Flow: Phone -> Send OTP -> Verify OTP -> Enter new 6-digit PIN.
class ForgotPinScreen extends StatefulWidget {
  const ForgotPinScreen({super.key});

  @override
  State<ForgotPinScreen> createState() => _ForgotPinScreenState();
}

class _ForgotPinScreenState extends State<ForgotPinScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '771234567');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authController = AppScope.of(context).authController;
    final String raw = '+967${_phoneController.text.trim()}';

    final bool sent = await authController.sendPinResetOtp(raw);
    if (sent && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => OtpVerificationScreen(
            phoneNumber: raw,
            title: 'استعادة الرقم السري (PIN)',
            description: 'أدخل رمز التحقق لإعادة تعيين الرقم السري',
            onVerified: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => const _NewPinScreen(),
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
    final authController = AppScope.of(context).authController;

    return Scaffold(
      appBar: AppBar(
        title: const Text('استعادة الرقم السري'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'استعادة الرقم السري (PIN)',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  'أدخل رقم هاتفك لتأكيد هويتك وتعيين رقم سري جديد من 6 أرقام.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),

                Directionality(
                  textDirection: TextDirection.ltr,
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'رقم الهاتف اليمني',
                      prefixIcon: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.center,
                        width: 86,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('🇾🇪', style: TextStyle(fontSize: 16)),
                            SizedBox(width: 4),
                            Text('+967', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.emeraldPrimary)),
                          ],
                        ),
                      ),
                    ),
                    validator: (String? val) {
                      if (val == null || val.trim().isEmpty) return 'رقم الهاتف مطلوب';
                      return PhoneNormalizer.validateInput('+967$val');
                    },
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: authController.isLoading ? null : _submit,
                  child: authController.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                        )
                      : const Text('إرسال رمز التحقق'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NewPinScreen extends StatefulWidget {
  const _NewPinScreen();

  @override
  State<_NewPinScreen> createState() => _NewPinScreenState();
}

class _NewPinScreenState extends State<_NewPinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _pinController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final authController = AppScope.of(context).authController;
    final bool ok = await authController.resetPin(_pinController.text.trim());
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.emeraldPrimary,
          content: Text('تم تعيين الرقم السري (PIN) الجديد بنجاح!'),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = AppScope.of(context).authController;

    return Scaffold(
      appBar: AppBar(title: const Text('الرقم السري الجديد')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'تعيين رقم سري جديد (PIN)',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  maxLength: AppConstants.pinLength,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'الرقم السري الجديد (6 أرقام)',
                    counterText: '',
                  ),
                  validator: (String? val) {
                    if (val == null || val.length != AppConstants.pinLength) {
                      return 'يجب أن يتكون من ${AppConstants.pinLength} أرقام';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _confirmController,
                  keyboardType: TextInputType.number,
                  maxLength: AppConstants.pinLength,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'تأكيد الرقم السري الجديد',
                    counterText: '',
                  ),
                  validator: (String? val) {
                    if (val != _pinController.text) return 'الرقم السري غير متطابق';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: authController.isLoading ? null : _save,
                  child: const Text('حفظ الرقم السري'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
