import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../../core/const/string_const/API_endpoint.dart';
import '../../../core/local_storage/user_info.dart';
import '../models/head_to_head_model.dart';

class HeadToHeadController extends GetxController {
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  var h2hData = Rxn<HeadToHeadModel>();

  var expandHome = false.obs;
  var expandAway = false.obs;

  final Dio _dio = Dio();

  /// Load H2H data for a fixture
  Future<void> loadH2H(int fixtureId) async {

    print("Loading H2H data for Fixture ID: $fixtureId");

    try {
      isLoading(true);
      errorMessage('');

      // Fetch access token (await if async)
      final token = UserInfo.getAccessToken();

      // Make API call
      final res = await _dio.get(
        "${APIEndpoint.baseURL}sports-data/fixtures/$fixtureId/h2h/",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print('HeadToHead Response Status: ${res.statusCode} and Data: ${res.data}');

      // Parse response into model
      h2hData.value = HeadToHeadModel.fromJson(res.data);
    } on DioException catch (dioError) {
      // Dio-specific error
      if (dioError.response != null) {
        errorMessage(
            "Error: ${dioError.response?.statusCode} ${dioError.response?.statusMessage}");
      } else {
        errorMessage("Connection error: ${dioError.message}");
      }
    } catch (e) {
      // Other errors
      errorMessage("Unexpected error: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Toggle "See More" for Home team
  void toggleHomeExpand() {
    expandHome.value = !expandHome.value;
  }

  /// Toggle "See More" for Away team
  void toggleAwayExpand() {
    expandAway.value = !expandAway.value;
  }
}
