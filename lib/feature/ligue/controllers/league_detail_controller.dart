// league_detail_controller.dart
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/string_const/API_endpoint.dart';
import '../../../core/helper/api_request/get_request.dart';
import '../../../core/local_storage/user_info.dart';
import '../models/league_detail_response.dart';

class LeagueDetailController extends GetxController {
  final int leagueId;
  LeagueDetailController({required this.leagueId});

  RxBool isLoading = false.obs;
  RxList<LeagueMatch> liveMatches = <LeagueMatch>[].obs;
  RxList<LeagueMatch> todayFixtures = <LeagueMatch>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeagueDetails();
  }

  Future<void> fetchLeagueDetails() async {
    try {
      isLoading.value = true;

      final response = await GetAPIRequest(
        url: '${APIEndpoint.leagueDetail}/$leagueId',
        headers: {'Authorization': 'Bearer ${UserInfo.getAccessToken()}'},
      ).fetchData();

      if (response.isNotEmpty) {
        final leagueResponse = LeagueDetailResponse.fromJson(response);
        liveMatches.value = leagueResponse.liveMatches.matches;
        todayFixtures.value = leagueResponse.todayFixtures.matches;


        print('Live matches: ${liveMatches.length}');
        print('lig ditels : ${leagueResponse.league.name}');
        print('Today fixtures: ${todayFixtures.length}');
      }
    } catch (e) {
      print('Error fetching league details: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
