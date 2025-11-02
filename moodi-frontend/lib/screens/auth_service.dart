import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class AuthService {
  // ปรับให้ถูกตามแพลตฟอร์ม
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000';       // Flutter Web
    if (Platform.isAndroid) return 'http://10.0.2.2:3000'; // Android Emulator
    return 'http://localhost:3000';                   // iOS simulator / Desktop
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/login');  // <- ต้องเป็น /login (ไม่ใช่ /auth/login)
      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      // debug
      print('[LOGIN] status=${resp.statusCode}');
      print('[LOGIN] body=${resp.body}');

      Map<String, dynamic> data;
      try {
        data = json.decode(resp.body);
      } catch (_) {
        return {'success': false, 'message': 'เซิร์ฟเวอร์ส่งข้อมูลไม่ใช่ JSON'};
      }

      if (resp.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'เข้าสู่ระบบสำเร็จ',
          'user': data['user'],
          'token': data['token'],
        };
      } else {
        return {
          'success': false,
          'message': data['error'] ?? 'ล็อกอินไม่สำเร็จ (${resp.statusCode})',
        };
      }
    } catch (e) {
      print('[LOGIN] error=$e');
      return {'success': false, 'message': 'เชื่อมต่อเซิร์ฟเวอร์ไม่ได้'};
    }
  }
}
