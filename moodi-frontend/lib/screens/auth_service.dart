import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'https://moodi-production.up.railway.app';
  static const Map<String, String> _headers = {'Content-Type': 'application/json'};

  // ================= REGISTER =================
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: _headers,
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 201) {
        return {'success': true, 'message': data['message']};
      }
      return {'success': false, 'message': data['error'] ?? 'สมัครสมาชิกไม่สำเร็จ'};
    } catch (_) {
      return {'success': false, 'message': 'เชื่อมต่อเซิร์ฟเวอร์ไม่ได้'};
    }
  }

  // ================= LOGIN =================
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: _headers,
        body: jsonEncode({'email': email, 'password': password}),
      );
      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        await saveCurrentUser(data['user']);
        return {
          'success': true,
          'user': data['user'],
          'message': data['message'],
        };
      }
      return {'success': false, 'message': data['error'] ?? 'อีเมลหรือรหัสผ่านไม่ถูกต้อง'};
    } catch (_) {
      return {'success': false, 'message': 'เชื่อมต่อเซิร์ฟเวอร์ไม่ได้'};
    }
  }

  // ================= SAVE USER =================
  static Future<void> saveCurrentUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', jsonEncode(user));
  }

  // ================= GET CURRENT USER (local) =================
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');
    if (userJson == null) return null;
    return jsonDecode(userJson) as Map<String, dynamic>;
  }

  // ================= GET USER PROFILE (from API) =================
  static Future<Map<String, dynamic>> getUserProfile(int userId) async {
    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/auth/profile/$userId'),
        headers: _headers,
      );
      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        // อัปเดต cache ใน SharedPreferences ด้วย
        await saveCurrentUser(data['user']);
        return {'success': true, 'user': data['user']};
      }
      return {'success': false, 'message': data['error'] ?? 'ดึงข้อมูลไม่สำเร็จ'};
    } catch (_) {
      return {'success': false, 'message': 'เชื่อมต่อเซิร์ฟเวอร์ไม่ได้'};
    }
  }

  // ================= UPDATE NAME =================
  static Future<Map<String, dynamic>> updateName({
    required int userId,
    required String name,
  }) async {
    try {
      final res = await http.patch(
        Uri.parse('$_baseUrl/auth/profile/$userId/name'),
        headers: _headers,
        body: jsonEncode({'name': name}),
      );
      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        // อัปเดต cache ชื่อใหม่ใน SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final userJson = prefs.getString('current_user');
        if (userJson != null) {
          final user = jsonDecode(userJson) as Map<String, dynamic>;
          user['name'] = name;
          await prefs.setString('current_user', jsonEncode(user));
        }
        return {'success': true, 'message': data['message'] ?? 'อัปเดตชื่อสำเร็จ'};
      }
      return {'success': false, 'message': data['error'] ?? 'อัปเดตชื่อไม่สำเร็จ'};
    } catch (_) {
      return {'success': false, 'message': 'เชื่อมต่อเซิร์ฟเวอร์ไม่ได้'};
    }
  }

  // ================= UPDATE PASSWORD =================
  static Future<Map<String, dynamic>> updatePassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final res = await http.patch(
        Uri.parse('$_baseUrl/auth/profile/$userId/password'),
        headers: _headers,
        body: jsonEncode({
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      );
      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return {'success': true, 'message': data['message'] ?? 'เปลี่ยนรหัสผ่านสำเร็จ'};
      }
      return {'success': false, 'message': data['error'] ?? 'เปลี่ยนรหัสผ่านไม่สำเร็จ'};
    } catch (_) {
      return {'success': false, 'message': 'เชื่อมต่อเซิร์ฟเวอร์ไม่ได้'};
    }
  }

  // ================= LOGOUT =================
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
  }
}