import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class UploadPhotoService {
  static const String baseUrl = 'http://3.39.47.48:8080';

  Future<List<String>> uploadObesityImages({
    required List<File> images,
    required int dogId,
  }) async {
    try {
      print('Uploading images for dogId: $dogId');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/diagnosis/obesity/upload'),
      );

      request.fields['dogId'] = dogId.toString();
      print('Request fields: ${request.fields}');

      for (var i = 0; i < images.length; i++) {
        var file = images[i];
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();

        var multipartFile = http.MultipartFile(
          'images',
          stream,
          length,
          filename: file.path.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        );

        request.files.add(multipartFile);
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(responseBody);
        final List<dynamic> urls = jsonResponse['urls'];
        return urls.map((url) => url.toString()).toList();
      } else {
        throw Exception('Failed to upload images: ${response.statusCode}');
      }
    } catch (e) {
      print('Error details: $e');
      throw Exception('Error uploading images: $e');
    }
  }

  Future<Map<String, dynamic>> analyzeObesity(int dogId) async {
    final url = Uri.parse('$baseUrl/api/diagnosis/obesity/$dogId');
    print('Analyzing obesity for dogId: $dogId');

    try {
      final response = await http.post(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'obesityScore': data['obesityScore'] ?? '알 수 없음',
        };
      } else {
        throw Exception('Error analyzing obesity: ${response.body}');
      }
    } catch (e) {
      print('Error in analyzeObesity: $e');
      throw Exception('Error analyzing obesity: $e');
    }
  }

  Future<List<String>> uploadSkinImage({
    required File image,
    required int dogId,
  }) async {
    try {
      print('Uploading skin image for dogId: $dogId');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/diagnosis/skin/upload'),
      );

      request.fields['dogId'] = dogId.toString();
      print('Request fields: ${request.fields}');

      var stream = http.ByteStream(image.openRead());
      var length = await image.length();

      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: image.path.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );

      request.files.add(multipartFile);

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(responseBody);
        if (jsonResponse['url'] == null) {
          return []; // url이 null인 경우 빈 리스트 반환
        }
        return [jsonResponse['url'].toString()];
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error details: $e');
      throw Exception('Error uploading image: $e');
    }
  }

  Future<Map<String, dynamic>> analyzeSkin(int dogId) async {
    final url = Uri.parse('$baseUrl/api/diagnosis/skin/$dogId');
    print('Analyzing skin for dogId: $dogId');

    try {
      final response = await http.post(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'skinDiseases': data['skinDiseases'] ?? [],
        };
      } else {
        throw Exception('Error analyzing skin: ${response.body}');
      }
    } catch (e) {
      print('Error in analyzeSkin: $e');
      throw Exception('Error analyzing skin: $e');
    }
  }
}
