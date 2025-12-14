import 'package:dio/dio.dart';
import 'package:scaffassistant/core/universal_widgets/s_snackbar.dart';

class PostAPIRequest {
  final String url;
  final Map<String, String>? headers;
  final Map<String, dynamic> body;

  PostAPIRequest(
        {
          required this.url,
          this.headers,
          required this.body
        }
      );

  Future<Map<String, dynamic>> sendData() async {
    print('==>> Sending POST Request to $url with body $body');
    try {
      final response = await Dio().post(
        url,
        data: body,
        options: Options(
          sendTimeout: Duration(milliseconds: 1000),
        ),
      );

      print('POST status code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        SSnackbar.error(response.data['error'] ?? 'An error occurred');
        return {};
      }

    } catch (e) {
      print('Error during POST request: $e');
      SSnackbar.error('Server error occurred. Please try again later.');
      return {};
    }
  }

}