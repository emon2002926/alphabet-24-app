import 'package:get/get.dart';

import '../../../core/const/string_const/API_endpoint.dart';
import '../../../core/helper/api_request/get_request.dart';
import '../../../core/local_storage/user_info.dart';
import '../models/predictions_odds_response.dart';

class PredictionsOddsController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<PredictionsOddsResponse?> predictionsOddsData = Rx<PredictionsOddsResponse?>(null);

  Future<void> fetchPredictionsOdds(String fixtureId) async {
    try {
      isLoading.value = true;

      final token = UserInfo.getAccessToken();

      final response = await GetAPIRequest(
        url: '${APIEndpoint.baseURL}sports-data/fixtures/$fixtureId/predictions-odds/',
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).fetchData();

      if (response.isNotEmpty) {
        predictionsOddsData.value = PredictionsOddsResponse.fromJson(response);
        print("✅ Predictions & Odds loaded successfully");
      } else {
        print("⚠️ Empty response from predictions-odds API");
      }

    } catch (e) {
      print("❌ Error loading predictions & odds: $e");
      predictionsOddsData.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    predictionsOddsData.value = null;
    super.onClose();
  }
}