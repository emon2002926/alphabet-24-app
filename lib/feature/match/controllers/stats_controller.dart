import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../core/const/string_const/API_endpoint.dart';
import '../../../core/local_storage/user_info.dart';
import '../models/stats_model.dart';

class StatsController extends GetxController {
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  var statsData = Rxn<StatsResponse>();

  final Dio _dio = Dio();

  Future<void> loadStats(int fixtureId) async {
    try {
      isLoading(true);
      errorMessage('');

      final token = UserInfo.getAccessToken();

      final res = await _dio.get(
        "${APIEndpoint.baseURL}sports-data/fixtures/$fixtureId/predictions-odds/",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      statsData.value = StatsResponse.fromJson(res.data);
    } catch (e) {
      errorMessage("Failed to load stats: $e");
    } finally {
      isLoading(false);
    }
  }
}
