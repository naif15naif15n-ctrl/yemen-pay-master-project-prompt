import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/phone_normalizer.dart';
import '../../../state/app_scope.dart';
import '../../widgets/demo_mode_banner.dart';
import '../../widgets/yemen_pay_logo.dart';
import 'forgot_password_screen.dart';
import 'forgot_pin_screen.dart';
import 'register_phone_screen.dart';

/// Professional Arabic RTL Login screen supporting password login,
/// 6-digit PIN login, and pre-seeded academic test account buttons.
class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onLoginSuccess,
  });

  final VoidCallback onLoginSuccess;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '771234567');
  final TextEditingController _credentialController = TextEditingController(text: 'YemenPay@2026');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPinMode = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _credentialController.dispose();
    super.dispose();
  }

  void _fillDemoUser({
    required String phone,
    required String password,
    bool isPin = false,
  }) {
    setState(() {
      _phoneController.text = phone.replaceFirst('+967', '');
      _credentialController.text = password;
      _isPinMode = isPin;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authController = AppScope.of(context).authController;
    final String rawPhone = '+967${_phoneController.text.trim()}';
    final String credential = _credentialController.text.trim();

    final bool success = _isPinMode
        ? await authController.loginWithPin(phoneNumber: rawPhone, pin: credential)
        : await authController.login(phoneNumber: rawPhone, password: credential);

    if (success && mounted) {
      widget.onLoginSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    final container = AppScope.of(context);
    final authController = container.authController;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: authController,
          builder: (BuildContext context, _) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Center(
                        child: YemenPayLogo(size: 64, showText: true),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppConstants.taglineAr,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 18),

                      if (authController.isDemoMode) ...<Widget>[
                        const DemoModeBanner(),
                        const SizedBox(height: 14),
                      ],

                      Text(
                        'تسجيل الدخول',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'أدخل رقم هاتفك اليمني وكلمة المرور للمتابعة',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 18),

                      // Yemeni Phone Number Input
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
                      const SizedBox(height: 14),

                      // Password / PIN Field
                      TextFormField(
                        controller: _credentialController,
                        obscureText: _obscureText,
                        keyboardType: _isPinMode ? TextInputType.number : TextInputType.text,
                        maxLength: _isPinMode ? 6 : null,
                        decoration: InputDecoration(
                          labelText: _isPinMode ? 'الرقم السري (PIN)' : 'كلمة المرور',
                          hintText: _isPinMode ? '6 أرقام' : '••••••••',
                          prefixIcon: Icon(
                            _isPinMode ? Icons.pin_outlined : Icons.lock_outline_rounded,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            ),
                            onPressed: () => setState(() => _obscureText = !_obscureText),
                          ),
                        ),
                        validator: (String? val) {
                          if (val == null || val.trim().isEmpty) {
                            return _isPinMode ? 'الرقم السري مطلوب' : 'كلمة المرور مطلوبة';
                          }
                          if (_isPinMode && val.trim().length != 6) {
                            return 'الرقم السري يجب أن يكون 6 أرقام';
                          }
                          return null;
                        },
                      ),

                      // Switch between Password / PIN login mode & Forgot links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isPinMode = !_isPinMode;
                                _credentialController.text = _isPinMode ? '123456' : 'YemenPay@2026';
                              });
                            },
                            child: Text(
                              _isPinMode ? 'الدخول بكلمة المرور' : 'الدخول بالرقم السري (PIN)',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text('نسيت كلمة المرور؟'),
                          ),
                        ],
                      ),

                      if (authController.errorMessage != null) ...<Widget>[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.errorSoft,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.error.withAlpha(80)),
                          ),
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authController.errorMessage!,
                                  style: const TextStyle(
                                    color: AppColors.error,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Login Button
                      ElevatedButton(
                        onPressed: authController.isLoading ? null : _submit,
                        child: authController.isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                              )
                            : const Text('تسجيل الدخول'),
                      ),
                      const SizedBox(height: 14),

                      // Register link
                      OutlinedButton(
                        onPressed: () {
                          authController.clearError();
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => RegisterPhoneScreen(
                                onRegistrationSuccess: widget.onLoginSuccess,
                              ),
                            ),
                          );
                        },
                        child: const Text('إنشاء حساب جديد'),
                      ),
                      const SizedBox(height: 10),

                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const ForgotPinScreen(),
                              ),
                            );
                          },
                          child: const Text('نسيت الرقم السري (PIN)؟'),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Academic test accounts quick helper
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: scheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: scheme.outline),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const Icon(Icons.school_outlined, size: 16, color: AppColors.goldAccent),
                                const SizedBox(width: 6),
                                Text(
                                  'وضع العرض الأكاديمي — حسابات سريعة للاختبار:',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: <Widget>[
                                ActionChip(
                                  label: const Text('أحمد (نشط)', style: TextStyle(fontSize: 11)),
                                  onPressed: () => _fillDemoUser(phone: '771234567', password: 'YemenPay@2026'),
                                ),
                                ActionChip(
                                  label: const Text('أحمد بالـ PIN', style: TextStyle(fontSize: 11)),
                                  onPressed: () => _fillDemoUser(phone: '771234567', password: '123456', isPin: true),
                                ),
                                ActionChip(
                                  label: const Text('حساب موقوف', style: TextStyle(fontSize: 11)),
                                  onPressed: () => _fillDemoUser(phone: '731112233', password: 'YemenPay@2026'),
                                ),
                                ActionChip(
                                  label: const Text('حساب مقفل', style: TextStyle(fontSize: 11)),
                                  onPressed: () => _fillDemoUser(phone: '714445566', password: 'YemenPay@2026'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
