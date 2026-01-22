import 'package:dio/dio.dart';
import 'package:scaffassistant/core/universal_widgets/custom_snackbar.dart';

class PostAPIRequest {
  final String url;
  final Map<String, String>? headers;
  final Map<String, dynamic> body;

  PostAPIRequest({
    required this.url,
    this.headers,
    required this.body,
  });

  Future<Map<String, dynamic>> sendData() async {
    print('==>> Sending POST Request to $url with body $body');

    try {
      final response = await Dio().post(
        url,
        data: body,
        options: Options(
          headers: headers,
          sendTimeout: Duration(milliseconds: 5000), // increase timeout
        ),
      );

      print('POST status code: ${response.statusCode}');

      // Always return both statusCode and data
      return {
        'statusCode': response.statusCode ?? 0,
        'data': response.data,
      };
    } on DioException catch (e) {
      // If server returns 401, 400 etc, Dio throws a DioException
      final response = e.response;
      if (response != null && response.data != null) {
        return {
          'statusCode': response.statusCode ?? 0,
          'data': response.data,
        };
      }

      // Network / other error
      return {
        'statusCode': 0,
        'data': {'error': 'Network or server error. Please try again.'},
      };
    } catch (e) {
      return {
        'statusCode': 0,
        'data': {'error': 'Unexpected error occurred.'},
      };
    }
  }
}
