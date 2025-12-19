import 'package:get/get.dart';
import 'package:scaffassistant/core/const/string_const/API_endpoint.dart';
import 'package:scaffassistant/core/helper/api_request/get_request.dart';
import 'package:scaffassistant/core/local_storage/user_info.dart';
import '../../../../../core/universal_widgets/s_snackbar.dart';
import '../../../models/leage_list_model.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LeagueListController extends GetxController {
  RxList<League> leagues = <League>[].obs;
  RxList<League> filteredLeagues = <League>[].obs;
  RxBool isLoading = false.obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeagues();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredLeagues.value = leagues;
    } else {
      filteredLeagues.value = leagues.where((league) {
        return league.name.toLowerCase().contains(query.toLowerCase()) ||
            league.shortCode.toLowerCase().contains(query.toLowerCase()) ||
            league.country.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    filteredLeagues.value = leagues;
  }

  Future<void> fetchLeagues() async {
    try {
      isLoading.value = true;

      GetAPIRequest getAPIRequest = GetAPIRequest(
        url: APIEndpoint.leagueList,
        headers: {
          'Authorization': 'Bearer ${UserInfo.getAccessToken()}'
        },
      );

      final response = await getAPIRequest.fetchData();

      if (response.isNotEmpty) {
        final leagueResponse = LeagueResponse.fromJson(response);
        leagues.value = leagueResponse.leagues;
        filteredLeagues.value = leagueResponse.leagues;
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

  // ===== TOGGLE FAVORITE LEAGUE =====
  Future<void> toggleFavoriteLeague(int index, {bool useFiltered = false}) async {
    final targetList = useFiltered ? filteredLeagues : leagues;
    final league = targetList[index];

    // Optimistic UI update
    targetList[index].isFavorite = !league.isFavorite;
    targetList.refresh();

    // Also update in main list if using filtered
    if (useFiltered) {
      final mainIndex = leagues.indexWhere((l) => l.id == league.id);
      if (mainIndex != -1) {
        leagues[mainIndex].isFavorite = targetList[index].isFavorite;
        leagues.refresh();
      }
    }

    try {
      final response = await http.post(
        Uri.parse(APIEndpoint.userFavorites),
        headers: {
          'Authorization': 'Bearer ${UserInfo.getAccessToken()}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'type': 'LEAGUE',
          'league_id': league.id,
        }),
      );

      print('Favorite League API Response: ${response.statusCode}');
      print('Favorite League API Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          SSnackbar.success(
            targetList[index].isFavorite
                ? 'League added to favorites'
                : 'League removed from favorites',
          );
        }
      } else {
        // Revert on failure
        _revertFavorite(index, useFiltered);
        SSnackbar.error('Failed to update favorite');
      }
    } catch (e) {
      // Revert on error
      _revertFavorite(index, useFiltered);
      print('Error toggling favorite league: $e');
      SSnackbar.error('Something went wrong');
    }
  }

  void _revertFavorite(int index, bool useFiltered) {
    final targetList = useFiltered ? filteredLeagues : leagues;
    targetList[index].isFavorite = !targetList[index].isFavorite;
    targetList.refresh();

    if (useFiltered) {
      final league = targetList[index];
      final mainIndex = leagues.indexWhere((l) => l.id == league.id);
      if (mainIndex != -1) {
        leagues[mainIndex].isFavorite = targetList[index].isFavorite;
        leagues.refresh();
      }
    }
  }
}