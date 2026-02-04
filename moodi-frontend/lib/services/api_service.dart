import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://moodi-production.up.railway.app';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // ---------------- AUTH ----------------
  static Future<http.Response> login(
      String email, String password) {
    return http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
  }

  // ---------------- MOOD ----------------
  static Future<http.Response> createMood({
    required int userId,
    required String mood,
    String? note,
  }) {
    return http.post(
      Uri.parse('$baseUrl/mood'),
      headers: headers,
      body: jsonEncode({
        'user_id': userId,
        'mood': mood,
        'note': note,
      }),
    );
  }

  static Future<List<dynamic>> getMoodByUser(int userId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/mood/$userId'),
      headers: headers,
    );
    return jsonDecode(res.body);
  }

  // ---------------- DIARY ----------------
  static Future<http.Response> createDiary(
      Map<String, dynamic> data) {
    return http.post(
      Uri.parse('$baseUrl/diary'),
      headers: headers,
      body: jsonEncode(data),
    );
  }

  // ---------------- QUIZ ----------------
  static Future<http.Response> createQuiz(
      Map<String, dynamic> data) {
    return http.post(
      Uri.parse('$baseUrl/quiz'),
      headers: headers,
      body: jsonEncode(data),
    );
  }

  // ---------------- CHAT ----------------
  static Future<http.Response> createChat(
      Map<String, dynamic> data) {
    return http.post(
      Uri.parse('$baseUrl/chat'),
      headers: headers,
      body: jsonEncode(data),
    );
  }

  static Future<List<dynamic>> getChatByUser(int userId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/chat/$userId'),
      headers: headers,
    );
    return jsonDecode(res.body);
  }

  // ---------------- RELAX ----------------
  static Future<List<dynamic>> getRelaxSounds() async {
    final res = await http.get(
      Uri.parse('$baseUrl/relax'),
      headers: headers,
    );
    return jsonDecode(res.body);
  }
}
