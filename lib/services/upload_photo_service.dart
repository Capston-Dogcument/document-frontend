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
}
