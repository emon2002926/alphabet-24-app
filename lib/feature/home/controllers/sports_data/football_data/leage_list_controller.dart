import 'package:get/get.dart';
import 'package:scaffassistant/core/const/string_const/API_endpoint.dart';
import 'package:scaffassistant/core/helper/api_request/get_request.dart';
import 'package:scaffassistant/core/local_storage/user_info.dart';
import '../../../models/leage_list_model.dart';
class LeagueListController extends GetxController {
  // Reactive list of leagues
  RxList<League> leagues = <League>[].obs;

  // Loading indicator
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeagues(); // Fetch data when controller initializes
  }

  Future<void> fetchLeagues() async {
    try {
      isLoading.value = true;

      GetAPIRequest getAPIRequest = GetAPIRequest(
        url: APIEndpoint.leagueList, // Make sure this is your leagues endpoint
        headers: {
          'Authorization': 'Bearer ${UserInfo.getAccessToken()}'
        },
      );

      final response = await getAPIRequest.fetchData();

      if (response.isNotEmpty) {
        // Parse JSON into League model
        final leagueResponse = LeagueResponse.fromJson(response);
        leagues.value = leagueResponse.leagues; // update RxList
        print('Leagues Updated: ${leagues.length}');
      } else {
        print('Failed to fetch league data');
      }
    } catch (e) {
      print('Error fetching leagues: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
