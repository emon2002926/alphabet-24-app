import 'package:get/get.dart';
import 'package:scaffassistant/core/const/string_const/API_endpoint.dart';
import 'package:scaffassistant/core/helper/api_request/get_request.dart';
import 'package:scaffassistant/core/local_storage/user_info.dart';
import '../models/summary_model.dart';

class SummaryController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<SummaryResponse?> summaryData = Rx<SummaryResponse?>(null);

  Future<void> fetchSummary(String fixtureId) async {
    try {
      isLoading.value = true;

      final token = UserInfo.getAccessToken();

      final response = await GetAPIRequest(
        url: '${APIEndpoint.baseURL}sports-data/fixtures/$fixtureId/summary/',
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).fetchData();

      if (response.isNotEmpty) {
        summaryData.value = SummaryResponse.fromJson(response);
      }

    } catch (e) {
      print("❌ Error loading summary: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
