import 'dart:convert';
import 'package:dio/dio.dart';

class GetAPIRequest {
  final String url;
  final Map<String, String>? headers;

  GetAPIRequest({required this.url, this.headers});

  Future<Map<String, dynamic>> fetchData() async {

    try {
      final dio = Dio();

      final response = await dio.get(
        url,
        options: Options(headers: headers),
      );

      print('GET Request to $url received status code: ${response.statusCode}');

      if (response.data is Map<String, dynamic>) {
        return response.data;
      }

      if (response.data is String) {
        return jsonDecode(response.data);
      }

      if (response.data is List) {
        return {"data": response.data};
      }

      return {};

    } catch (e) {
      print("❌ Dio Error: $e");
      return {};
    }
  }
}
