import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dog_info.dart';

class DogInfoService {
  static const String baseUrl = 'http://3.39.47.48:8080';

  Future<DogInfo?> registerDogInfo(DogInfo dogInfo) async {
    final url = Uri.parse('$baseUrl/api/dog/info');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dogInfo.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return DogInfo.fromJson(data);
    } else {
      // 에러 처리
      print('등록 실패: ${response.statusCode} ${response.body}');
      return null;
    }
  }
}
