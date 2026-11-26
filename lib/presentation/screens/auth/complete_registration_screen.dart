import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../state/app_scope.dart';
import '../../widgets/password_strength_bar.dart';

/// Registration Step 3: Full Name, Password + Confirm, 6-digit PIN + Confirm.
class CompleteRegistrationScreen extends StatefulWidget {
  const CompleteRegistrationScreen({
    super.key,
    required this.onRegistrationComplete,
  });

  final VoidCallback onRegistrationComplete;

  @override
  State<CompleteRegistrationScreen> createState() =>
      _CompleteRegistrationScreenState();
}

class _CompleteRegistrationScreenState
    extends State<CompleteRegistrationScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: 'محمد علي الحبيشي');
  final TextEditingController _emailController =
      TextEditingController(text: 'mohammed@yemenpay.local');
  final TextEditingController _passwordController =
      TextEditingController(text: 'YemenPay@2026');
  final TextEditingController _confirmPasswordController =
      TextEditingController(text: 'YemenPay@2026');
  final TextEditingController _pinController =
      TextEditingController(text: '654321');
  final TextEditingController _confirmPinController =
      TextEditingController(text: '654321');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _obscurePin = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authController = AppScope.of(context).authController;
    final bool ok = await authController.completeRegistration(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      pin: _pinController.text.trim(),
    );

    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.emeraldPrimary,
          content: Text('تم إنشاء الحساب والمحفظة التجريبية بنجاح! أهلًا بك في يمن باي.'),
        ),
      );
      widget.onRegistrationComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final container = AppScope.of(context);
    final authController = container.authController;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إكمال بيانات الحساب'),
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
                      'الخطوة 3 من 3: البيانات الشخصية والأمان',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.emeraldPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'أدخل بياناتك وكلمة المرور',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 20),

                    // Full Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'الاسم الكامل الثلاثي أو الرباعي',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                      validator: (String? val) {
                        if (val == null || val.trim().length < 3) {
                          return 'يرجى إدخال اسم صحيح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Email (optional)
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني (اختياري)',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور (8 خانات على الأقل)',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (String? val) {
                        if (val == null || val.length < AppConstants.minPasswordLength) {
                          return 'كلمة المرور يجب أن لا تقل عن 8 خانات';
                        }
                        return null;
                      },
                    ),
                    PasswordStrengthBar(password: _passwordController.text),
                    const SizedBox(height: 14),

                    // Confirm Password
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'تأكيد كلمة المرور',
                        prefixIcon: const Icon(Icons.lock_reset_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                      ),
                      validator: (String? val) {
                        if (val != _passwordController.text) {
                          return 'كلمة المرور غير متطابقة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    // 6-digit PIN
                    Text(
                      'الرقم السري للعمليات (PIN)',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'يستخدم لتأكيد التحويلات والمدفوعات الحساسة (يتكون من 6 أرقام).',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),

                    TextFormField(
                      controller: _pinController,
                      keyboardType: TextInputType.number,
                      maxLength: AppConstants.pinLength,
                      obscureText: _obscurePin,
                      decoration: InputDecoration(
                        labelText: 'الرقم السري (6 أرقام)',
                        counterText: '',
                        prefixIcon: const Icon(Icons.pin_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePin ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => setState(() => _obscurePin = !_obscurePin),
                        ),
                      ),
                      validator: (String? val) {
                        if (val == null || val.trim().length != AppConstants.pinLength) {
                          return 'الرقم السري يجب أن يتكون من 6 أرقام';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _confirmPinController,
                      keyboardType: TextInputType.number,
                      maxLength: AppConstants.pinLength,
                      obscureText: _obscurePin,
                      decoration: const InputDecoration(
                        labelText: 'تأكيد الرقم السري (6 أرقام)',
                        counterText: '',
                        prefixIcon: Icon(Icons.pin_outlined),
                      ),
                      validator: (String? val) {
                        if (val != _pinController.text) {
                          return 'الرقم السري غير متطابق';
                        }
                        return null;
                      },
                    ),

                    if (authController.errorMessage != null) ...<Widget>[
                      const SizedBox(height: 14),
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

                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: authController.isLoading ? null : _submit,
                      child: authController.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                            )
                          : const Text('إتمام إنشاء الحساب ومحفظتي'),
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
