import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class DiagnosisService {
  static const String baseUrl = 'YOUR_BASE_URL'; // 기본 주소를 여기에 입력하세요

  Future<List<String>> uploadObesityImages({
    required List<File> images,
    required int dogId,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/diagnosis/obesity/upload'),
      );

      // dogId 파라미터 추가
      request.fields['dogId'] = dogId.toString();

      // 이미지 파일들 추가
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

      if (response.statusCode == 200) {
        // 응답을 파싱하여 URL 리스트 반환
        final urls =
            (responseBody as List).map((url) => url.toString()).toList();
        return urls;
      } else {
        throw Exception('Failed to upload images: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading images: $e');
    }
  }
}
