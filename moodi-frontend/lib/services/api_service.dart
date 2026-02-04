import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://moodi-production.up.railway.app';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // ================= AUTH =================
  static Future<http.Response> login(
    String email,
    String password,
  ) {
    return http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
  }

  // ================= MOOD =================

  /// CREATE MOOD
  static Future<bool> createMood({
    required int userId,
    required String mood,
    required String note,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/mood'),
      headers: headers,
      body: jsonEncode({
        'user_id': userId,
        'mood': mood,
        'note': note,
      }),
    );

    return res.statusCode == 200 || res.statusCode == 201;
  }

  /// GET MOOD HISTORY
  static Future<List<dynamic>> getMoodByUser(int userId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/mood/$userId'),
      headers: headers,
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      return [];
    }
  }

  // ================= DIARY =================

 static Future<bool> createDiary(Map<String, dynamic> diaryData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/diary'),
        headers: headers,
        body: jsonEncode(diaryData),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('Create diary error: $e');
      return false;
    }
  }

  static Future<List<dynamic>> getDiaryByUser(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/diary/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print('Get diary error: $e');
      return [];
    }
  }

  // ✅ ฟังก์ชันใหม่: ลบ diary entry
  static Future<bool> deleteDiary(int entryId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/diary/$entryId'),
        headers: headers,
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Delete diary error: $e');
      return false;
    }
  }

  // ================= QUIZ =================
  static Future<bool> createQuiz(
    Map<String, dynamic> data,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/quiz'),
      headers: headers,
      body: jsonEncode(data),
    );

    return res.statusCode == 200 || res.statusCode == 201;
  }

  // ================= CHAT =================
  static Future<bool> createChat(
    Map<String, dynamic> data,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/chat'),
      headers: headers,
      body: jsonEncode(data),
    );

    return res.statusCode == 200 || res.statusCode == 201;
  }

  static Future<List<dynamic>> getChatByUser(int userId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/chat/$userId'),
      headers: headers,
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      return [];
    }
  }

  // ================= RELAX =================
  static Future<List<dynamic>> getRelaxSounds() async {
    final res = await http.get(
      Uri.parse('$baseUrl/relax'),
      headers: headers,
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      return [];
    }
  }
}
