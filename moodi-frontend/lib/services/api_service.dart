import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://moodi-production.up.railway.app';

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

  /// CREATE DIARY
  static Future<bool> createDiary(Map<String, dynamic> diaryData) async {
    try {
      print('📝 ========== CREATE DIARY ==========');
      print('🔗 URL: $baseUrl/diary');
      print('📦 Data: $diaryData');

      final response = await http.post(
        Uri.parse('$baseUrl/diary'),
        headers: headers,
        body: jsonEncode(diaryData),
      );

      print('📊 Status: ${response.statusCode}');
      print('📦 Response: ${response.body}');
      print('====================================');

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('❌ Create diary error: $e');
      return false;
    }
  }

  /// GET DIARY BY USER - ✅ แก้ไขแล้ว
  static Future<List<dynamic>> getDiaryByUser(int userId) async {
    try {
      final url = '$baseUrl/diary/$userId';
      
      print('📡 ========== GET DIARY ==========');
      print('🔗 URL: $url');
      print('👤 User ID: $userId');

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('📊 Status Code: ${response.statusCode}');
      print('📦 Raw Response: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);
        print('📋 Response Type: ${jsonResponse.runtimeType}');

        // ✅ กรณีที่ 1: Response มี wrapper object พร้อม key 'data'
        // เช่น: { "success": true, "data": [...] }
        if (jsonResponse is Map<String, dynamic>) {
          print('📂 Response is Map');
          
          // ตรวจสอบทุก key ที่เป็นไปได้
          if (jsonResponse.containsKey('data')) {
            final data = jsonResponse['data'];
            if (data is List) {
              print('✅ Found ${data.length} entries from "data" key');
              print('📄 First entry sample: ${data.isNotEmpty ? data[0] : "empty"}');
              return data;
            }
          }

          if (jsonResponse.containsKey('diary')) {
            final diary = jsonResponse['diary'];
            if (diary is List) {
              print('✅ Found ${diary.length} entries from "diary" key');
              return diary;
            }
          }

          if (jsonResponse.containsKey('diaries')) {
            final diaries = jsonResponse['diaries'];
            if (diaries is List) {
              print('✅ Found ${diaries.length} entries from "diaries" key');
              return diaries;
            }
          }

          if (jsonResponse.containsKey('entries')) {
            final entries = jsonResponse['entries'];
            if (entries is List) {
              print('✅ Found ${entries.length} entries from "entries" key');
              return entries;
            }
          }

          // แสดง keys ทั้งหมดที่มี
          print('⚠️ Available keys in response: ${jsonResponse.keys.toList()}');
        }

        // ✅ กรณีที่ 2: Response เป็น Array โดยตรง
        // เช่น: [{ entry_id: 1, ... }, ...]
        if (jsonResponse is List) {
          print('✅ Found ${jsonResponse.length} entries (direct array)');
          if (jsonResponse.isNotEmpty) {
            print('📄 First entry sample: ${jsonResponse[0]}');
          }
          return jsonResponse;
        }

        print('⚠️ WARNING: Unknown response format');
        return [];

      } else if (response.statusCode == 404) {
        print('⚠️ No diary entries found (404)');
        return [];
      } else {
        print('❌ Error Status: ${response.statusCode}');
        print('Response: ${response.body}');
        return [];
      }

    } catch (e, stackTrace) {
      print('❌ CRITICAL ERROR in getDiaryByUser:');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      return [];
    } finally {
      print('===================================');
    }
  }

  /// DELETE DIARY - ✅ แก้ไขแล้ว
  static Future<bool> deleteDiary(int entryId) async {
    try {
      print('🗑️ ========== DELETE DIARY ==========');
      print('🔗 URL: $baseUrl/diary/$entryId');
      print('🆔 Entry ID: $entryId');

      final response = await http.delete(
        Uri.parse('$baseUrl/diary/$entryId'),
        headers: headers,
      );

      print('📊 Status: ${response.statusCode}');
      print('📦 Response: ${response.body}');
      print('====================================');

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('❌ Delete diary error: $e');
      return false;
    }
  }

 // ================= QUIZ RESULT =================
static Future<bool> saveQuizResult({
  required int userId,
  required String quizType, // "PHQ9" | "ST5"
  required int totalScore,
  required String level,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/quiz/result'),
      headers: headers,
      body: jsonEncode({
        'user_id': userId,
        'quiz_type': quizType,
        'total_score': totalScore,
        'level': level,
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  } catch (e) {
    print('❌ Save quiz result error: $e');
    return false;
  }
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