import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // ================= BASE URL =================
  static const String _baseUrl =
      'https://moodi-production.up.railway.app';

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
      };

  // ================= REGISTER =================
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/auth/register');

      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'สมัครสมาชิกสำเร็จ',
          'user': data['user'],
        };
      }

      return {
        'success': false,
        'message': data['error'] ?? 'สมัครสมาชิกไม่สำเร็จ',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'เชื่อมต่อเซิร์ฟเวอร์ไม่ได้',
      };
    }
  }

  // ================= LOGIN =================
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/auth/login');

      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'เข้าสู่ระบบสำเร็จ',
          'user': data['user'],
        };
      }

      return {
        'success': false,
        'message': data['error'] ?? 'อีเมลหรือรหัสผ่านไม่ถูกต้อง',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'เชื่อมต่อเซิร์ฟเวอร์ไม่ได้',
      };
    }
  }

  // ================= FORGOT PASSWORD (โครงสร้างไว้ก่อน) =================
  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    // backend ยังไม่ทำ → คืนค่าไว้ก่อน
    return {
      'success': false,
      'message': 'ระบบลืมรหัสผ่านกำลังพัฒนา',
    };
  }
}
