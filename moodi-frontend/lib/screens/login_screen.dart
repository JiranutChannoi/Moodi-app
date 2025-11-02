import 'package:flutter/material.dart';
import 'auth_service.dart'; // ต้องมีไฟล์นี้อยู่แล้ว

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _pwCtl = TextEditingController();

  bool _isLoading = false;
  bool _obscure = true;

  // --- Helpers ---
  void _showSnack(String msg, {Color color = Colors.black87}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  Future<void> _handleLogin() async {
    // ปิดคีย์บอร์ด
    FocusScope.of(context).unfocus();

    // ตรวจฟอร์ม
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailCtl.text.trim();
    final password = _pwCtl.text;

    // ยิง API
    final result = await AuthService.login(email: email, password: password);

    // debug log ช่วยไล่ปัญหา
    // (ดูได้ใน Console ของเบราว์เซอร์/Flutter)
    // ignore: avoid_print
    print('[LOGIN] result: $result');

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['success'] == true) {
      _showSnack(result['message'] ?? 'เข้าสู่ระบบสำเร็จ', color: Colors.green);

      // TODO: ถ้าต้องการเก็บ token ค่อยต่อ SharedPreferences/Secure Storage ตรงนี้
      // final token = result['token'];

      // นำทางไปหน้า Home
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      _showSnack(result['message'] ?? 'ล็อกอินไม่สำเร็จ', color: Colors.red);
    }
  }

  @override
  void dispose() {
    _emailCtl.dispose();
    _pwCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE8F4FD), Color(0xFFF8E8FF), Color(0xFFE8F4FD)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // โลโก้
                        Hero(
                          tag: 'logo',
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                )
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/moodi_logo.png',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF7B68EE), Color(0xFF9B59B6)],
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'M',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        const Text(
                          'Moodi',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7B68EE),
                          ),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          'Welcome back!',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Email
                        _InputWrapper(
                          child: TextFormField(
                            controller: _emailCtl,
                            enabled: !_isLoading,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(
                              hint: 'Email',
                              icon: Icons.email_outlined,
                            ),
                            validator: (v) {
                              final s = v?.trim() ?? '';
                              if (s.isEmpty) return 'กรุณากรอกอีเมล';
                              if (!s.contains('@') || !s.contains('.')) {
                                return 'รูปแบบอีเมลไม่ถูกต้อง';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Password
                        _InputWrapper(
                          child: TextFormField(
                            controller: _pwCtl,
                            enabled: !_isLoading,
                            obscureText: _obscure,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _handleLogin(),
                            decoration: _inputDecoration(
                              hint: 'Password',
                              icon: Icons.lock_outline,
                              suffix: IconButton(
                                onPressed: () => setState(() => _obscure = !_obscure),
                                icon: Icon(
                                  _obscure ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            validator: (v) {
                              if ((v ?? '').isEmpty) return 'กรุณากรอกรหัสผ่าน';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 30),

                        // ปุ่ม Login
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF7B68EE), Color(0xFF9B59B6), Color(0xFFBA55D3)],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF9B7EDE).withOpacity(0.35),
                                  blurRadius: 14,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Text(
                                      'Log in',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ลืมรหัสผ่าน
                        TextButton(
                          onPressed: _isLoading ? null : () => Navigator.pushNamed(context, '/forgot-password'),
                          child: const Text(
                            'Forgot your password?',
                            style: TextStyle(color: Color(0xFF7B68EE), fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // สมัครสมาชิก
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No account yet? ', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                            TextButton(
                              onPressed: _isLoading ? null : () => Navigator.pushNamed(context, '/signup'),
                              child: const Text(
                                'Create one',
                                style: TextStyle(
                                  color: Color(0xFF7B68EE),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        TextButton(
                          onPressed: _isLoading ? null : () => Navigator.pushNamed(context, '/welcome'),
                          child: Text('← Back to Home', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[500]),
      prefixIcon: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: Colors.grey[600], size: 20),
      ),
      suffixIcon: suffix,
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }
}

class _InputWrapper extends StatelessWidget {
  final Widget child;
  const _InputWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}
