
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../core/const/string_const/API_endpoint.dart';
import '../../../core/local_storage/user_info.dart';
import '../models/match_lineup_model.dart';

class MatchLineupController extends GetxController {
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var lineupData = Rxn<MatchLineup>();

  final Dio _dio = Dio();

  Future<void> fetchLineup(int fixtureId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = UserInfo.getAccessToken();

      print('Fetching lineup for fixture: $fixtureId');

      final response = await _dio.get(
        '${APIEndpoint.baseURL}sports-data/fixtures/$fixtureId/lineups/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['status'] == 'success') {
          lineupData.value = MatchLineup.fromJson(responseData);

          print('✅ Lineup loaded successfully');
          print('Home: ${lineupData.value?.homeTeam.name} (${lineupData.value?.homeTeam.startingXi.length} players)');
          print('Away: ${lineupData.value?.awayTeam.name} (${lineupData.value?.awayTeam.startingXi.length} players)');

          errorMessage.value = '';
        } else {
          errorMessage.value = 'API returned error status';
          print('❌ Error: ${responseData['message'] ?? 'Unknown error'}');
        }
      } else {
        errorMessage.value = 'Failed to load lineup';
        print('❌ HTTP Error: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('❌ Exception: $e');
      print('Stack: $stackTrace');
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}