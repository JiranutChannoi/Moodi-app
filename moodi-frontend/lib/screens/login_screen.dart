import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart'; 

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

  // ---------- Helper ----------
  void _showSnack(String msg, {Color color = Colors.black87}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ---------- LOGIN ----------
  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    if (_isLoading) return; // ✅ FIX: กันกดรัว
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await AuthService.login(
      email: _emailCtl.text.trim(),
      password: _pwCtl.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    debugPrint('[LOGIN RESULT] $result');

    if (result['success'] == true) {
      final user = result['user'];
     // ⭐⭐ เพิ่มตรงนี้ ⭐⭐
       if (user != null) {
       final prefs = await SharedPreferences.getInstance();
       await prefs.setInt(
      'user_id',
      user['user_id'] is int
          ? user['user_id']
          : int.parse(user['user_id'].toString()),
       );
  }
      _showSnack(
        result['message'] ?? 'เข้าสู่ระบบสำเร็จ',
        color: Colors.green,
      );

      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showSnack(
        result['message'] ?? 'อีเมลหรือรหัสผ่านไม่ถูกต้อง',
        color: Colors.red,
      );
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
              colors: [
                Color(0xFFE8F4FD),
                Color(0xFFF8E8FF),
                Color(0xFFE8F4FD),
              ],
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
                        // ---------- LOGO ----------
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
                                  return const Center(
                                    child: Text(
                                      'M',
                                      style: TextStyle(
                                        fontSize: 48,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
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
                          ),
                        ),
                        const SizedBox(height: 40),

                        // ---------- EMAIL ----------
                        _InputWrapper(
                          child: TextFormField(
                            controller: _emailCtl,
                            enabled: !_isLoading,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _inputDecoration(
                              hint: 'Email',
                              icon: Icons.email_outlined,
                            ),
                            validator: (v) {
                              final s = v?.trim() ?? '';
                              if (s.isEmpty) return 'กรุณากรอกอีเมล';
                              if (!s.contains('@')) return 'อีเมลไม่ถูกต้อง';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ---------- PASSWORD ----------
                        _InputWrapper(
                          child: TextFormField(
                            controller: _pwCtl,
                            enabled: !_isLoading,
                            obscureText: _obscure,
                            onFieldSubmitted: (_) => _handleLogin(),
                            decoration: _inputDecoration(
                              hint: 'Password',
                              icon: Icons.lock_outline,
                              suffix: IconButton(
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                            ),
                            validator: (v) =>
                                (v == null || v.isEmpty)
                                    ? 'กรุณากรอกรหัสผ่าน'
                                    : null,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // ---------- LOGIN BUTTON ----------
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed:
                                _isLoading ? null : _handleLogin,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text('Log in'),
                          ),
                        ),

                        const SizedBox(height: 24),

                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(
                                  context, '/forgot-password'),
                          child: const Text('Forgot your password?'),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('No account yet?'),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(
                                      context, '/signup'),
                              child: const Text('Create one'),
                            ),
                          ],
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

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      border: InputBorder.none,
    );
  }
}

// ---------- INPUT WRAPPER ----------
class _InputWrapper extends StatelessWidget {
  final Widget child;
  const _InputWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black12,
          )
        ],
      ),
      child: child,
    );
  }
}
