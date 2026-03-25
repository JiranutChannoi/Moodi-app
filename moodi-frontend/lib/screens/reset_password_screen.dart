import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String code;

  const ResetPasswordScreen({Key? key, required this.email, required this.code})
    : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;

  Future<void> resetPassword() async {
    if (_passwordController.text.length < 6) {
      _show("รหัสผ่านต้องอย่างน้อย 6 ตัว");
      return;
    }

    if (_passwordController.text != _confirmController.text) {
      _show("รหัสผ่านไม่ตรงกัน");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(
          'https://moodi-production.up.railway.app/auth/reset-password-otp',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'code': widget.code,
          'newPassword': _passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _show("เปลี่ยนรหัสผ่านสำเร็จ", success: true);

        // 🔥 กลับไปหน้า login
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        _show(data['error'] ?? 'เกิดข้อผิดพลาด');
      }
    } catch (e) {
      _show("เชื่อมต่อเซิร์ฟเวอร์ไม่ได้");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _show(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ตั้งรหัสผ่านใหม่")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("สำหรับ: ${widget.email}"),
            const SizedBox(height: 20),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "รหัสผ่านใหม่",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "ยืนยันรหัสผ่าน",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isLoading ? null : resetPassword,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text("บันทึกรหัสผ่าน"),
            ),
          ],
        ),
      ),
    );
  }
}
