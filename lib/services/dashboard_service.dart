import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardService {
  static const String baseUrl = 'http://3.39.47.48:8080';

  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/home'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception(
            'Failed to load dashboard data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting dashboard data: $e');
      rethrow;
    }
  }
}
