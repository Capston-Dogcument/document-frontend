import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dog_info.dart';

class DogInfoService {
  static const String baseUrl = 'http://3.39.47.48:8080';

  Future<DogInfo?> registerDogInfo(DogInfo dogInfo) async {
    final url = Uri.parse('$baseUrl/api/dog/info');

    // 임시로 나이 정보 추가
    final Map<String, dynamic> dogInfoWithAge = dogInfo.toJson();
    dogInfoWithAge['age'] = 1; // 임시로 1살로 설정

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dogInfoWithAge),
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

  Future<DogInfo?> getDogInfo(int dogId) async {
    final url = Uri.parse('$baseUrl/api/dog/info/$dogId');

    try {
      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return DogInfo.fromJson(data);
      } else {
        print('강아지 정보 조회 실패: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting dog info: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> saveDogAge(int dogId, int age) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/dog/age/save/$dogId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'age': age}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to save dog age: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving dog age: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> predictDogAge(
    int dogId, {
    required bool hasDeciduousTeeth,
    required int toothWearLevel,
    required bool hasTartar,
    required bool hasToothDamage,
    required String eyeColor,
    required int grayHairLevelAroundNose,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/dog/age/predict/$dogId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'hasDeciduousTeeth': hasDeciduousTeeth,
          'toothWearLevel': toothWearLevel,
          'hasTartar': hasTartar,
          'hasToothDamage': hasToothDamage,
          'eyeColor': eyeColor,
          'grayHairLevelAroundNose': grayHairLevelAroundNose,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to predict dog age: ${response.statusCode}');
      }
    } catch (e) {
      print('Error predicting dog age: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> saveDogDetail(
    int dogId, {
    required String vaccination,
    required bool isNeutered,
    required String diseaseInfo,
    required bool takesSupplements,
    required List<Map<String, dynamic>> supplement,
    required bool takesMedication,
    required List<Map<String, dynamic>> medication,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/dog/$dogId/detail'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'vaccination': vaccination,
          'isNeutered': isNeutered,
          'diseaseInfo': diseaseInfo,
          'takesSupplements': takesSupplements,
          'supplement': supplement,
          'takesMedication': takesMedication,
          'medication': medication,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to save dog detail: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving dog detail: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getDogDetail(int dogId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/dog/$dogId/detail'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else if (response.statusCode == 404) {
        // 404인 경우 빈 데이터 반환
        return {
          'dogName': '정보 없음',
          'isVaccinated': false,
          'isNeutered': false,
          'disease': [],
          'dryFoodAmount': 0,
          'wetFoodAmount': 0,
          'medication': [],
          'obesityLevel': '정보 없음',
          'weight': 0,
          'age': 0,
          'avgAge': 0,
        };
      } else {
        throw Exception('Failed to load dog detail: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting dog detail: $e');
      rethrow;
    }
  }

  Future<bool> deleteDogInfo(int dogId) async {
    final url = Uri.parse('http://3.39.47.48:8080/api/dog/info/$dogId');
    final response = await http.delete(url);
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete dog info: \\${response.statusCode}');
    }
  }
}
