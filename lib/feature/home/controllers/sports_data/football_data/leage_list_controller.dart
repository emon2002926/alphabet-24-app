import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scaffassistant/core/const/string_const/API_endpoint.dart';
import 'package:scaffassistant/core/helper/api_request/get_request.dart';
import 'package:scaffassistant/core/local_storage/user_info.dart';
import '../../../../../core/universal_widgets/s_snackbar.dart';
import '../../../../favourite/controllers/favourite_controller.dart';
import '../../../models/leage_list_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LeagueListController extends GetxController {
  RxList<LeaguePrimary> leagues = <LeaguePrimary>[].obs;
  RxList<LeaguePrimary> filteredLeagues = <LeaguePrimary>[].obs;
  RxBool isLoading = false.obs;
  RxString searchQuery = ''.obs;

  // ✅ NEW: Capture full LeagueByDateResponse
  Rx<LeagueByDateResponse?> leagueByDateResponse = Rx<LeagueByDateResponse?>(null);

  // ===== DATE SELECTION =====
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxList<DateTime> dateRange = <DateTime>[].obs;
  RxBool isDateFilterActive = true.obs;

  @override
  void onInit() {
    super.onInit();
    generateDateRange();
    fetchLeaguesByDate(DateTime.now());
  }

  // Generate 4 months of dates: 2 months before today + 2 months after today
  void generateDateRange() {
    dateRange.clear();
    final today = DateTime.now();

    // Generate 60 days BEFORE today (previous 2 months)
    for (int i = 60; i > 0; i--) {
      dateRange.add(today.subtract(Duration(days: i)));
    }

    // Add today
    dateRange.add(today);

    // Generate 60 days AFTER today (next 2 months)
    for (int i = 1; i <= 60; i++) {
      dateRange.add(today.add(Duration(days: i)));
    }

    print('📅 Generated ${dateRange.length} dates (2 months before + today + 2 months after)');
  }

  void selectDate(DateTime date) {
    print('📅 selectDate called for: ${DateFormat('yyyy-MM-dd').format(date)}');

    selectedDate.value = date;
    isDateFilterActive.value = true;
    fetchLeaguesByDate(date);
    print('✅ Date selected: ${DateFormat('yyyy-MM-dd').format(date)}');
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    applySearchFilter();
  }

  void clearSearch() {
    searchQuery.value = '';
    applySearchFilter();
  }

  void applySearchFilter() {
    if (searchQuery.value.isEmpty) {
      filteredLeagues.value = leagues;
    } else {
      var filtered = leagues.where((league) {
        return league.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            (league.shortCode?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false) ||
            league.country.name.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
      filteredLeagues.value = filtered;
    }
    print('📊 Filtered leagues count: ${filteredLeagues.length}');
  }

  // Fetch all leagues (original endpoint)
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
        final leagueResponse = LeagueByDateResponse.fromJson(response);

        // ✅ Store full response
        leagueByDateResponse.value = leagueResponse;

        // Filter out leagues with no matches
        leagues.value = leagueResponse.leagues
            .where((league) => league.matchCount == null || league.matchCount! > 0)
            .toList();
        applySearchFilter();
        print('✅ All Leagues Loaded: ${leagues.length}');
      } else {
        print('❌ Failed to fetch league data');
      }
    } catch (e) {
      print('❌ Error fetching leagues: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch leagues by date
  Future<void> fetchLeaguesByDate(DateTime date) async {
    try {
      isLoading.value = true;

      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final url = '${APIEndpoint.baseURL}sports-data/leagues/date/$formattedDate/';
      print('📅 Fetching leagues for date: $url');

      GetAPIRequest getAPIRequest = GetAPIRequest(
        url: url,
        headers: {
          'Authorization': 'Bearer ${UserInfo.getAccessToken()}'
        },
      );

      final response = await getAPIRequest.fetchData();

      if (response.isNotEmpty && response['leagues'] != null) {
        // ✅ Parse and store full response
        final fullResponse = LeagueByDateResponse.fromJson(response);
        leagueByDateResponse.value = fullResponse;

        print('✅ LeagueByDateResponse captured:');
        print('   - Status: ${fullResponse.status}');
        print('   - Date: ${fullResponse.date}');
        print('   - Total Leagues: ${fullResponse.totalLeagues}');
        print('   - Total Matches: ${fullResponse.totalMatches}');

        // Filter leagues with matches
        final leaguesList = fullResponse.leagues.where((league) {
          if (league.matches != null && league.matches!.isNotEmpty) {
            return true;
          }
          if (league.matchCount != null && league.matchCount! > 0) {
            return true;
          }
          return false;
        }).toList();

        leagues.value = leaguesList;
        applySearchFilter();

        print('✅ Leagues by Date Loaded: ${leagues.length} leagues with matches');
      } else {
        leagueByDateResponse.value = null;
        leagues.clear();
        filteredLeagues.clear();
        print('⚠️ No leagues available for $formattedDate');
      }
    } catch (e) {
      print('❌ Error fetching leagues by date: $e');
      leagueByDateResponse.value = null;
      leagues.clear();
      filteredLeagues.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ NEW: Getter methods for easy access to response data
  String get responseStatus => leagueByDateResponse.value?.status ?? '';
  String get responseDate => leagueByDateResponse.value?.date ?? '';
  int get totalLeagues => leagueByDateResponse.value?.totalLeagues ?? 0;
  int get totalMatches => leagueByDateResponse.value?.totalMatches ?? 0;

  // ===== TOGGLE FAVORITE LEAGUE =====
// ===== TOGGLE FAVORITE LEAGUE =====
  Future<void> toggleFavoriteLeague(int index, {bool useFiltered = false}) async {
    final targetList = useFiltered ? filteredLeagues : leagues;

    if (index >= targetList.length) return;

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

      print('Favorite League API Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          // ✅ Update FavouriteController to reflect changeschanges
          try {
            final favouriteController = Get.find<FavouriteController>();
            await favouriteController.fetchFavourites();
          } catch (e) {
            print('⚠️ FavouriteController not found or error refreshing: $e');
          }

          SSnackbar.success(
            targetList[index].isFavorite
                ? 'League added to favorites'
                : 'League removed from favorites',
          );
        }
      } else {
        _revertFavorite(index, useFiltered);
        SSnackbar.error('Failed to update favorite');
      }
    } catch (e) {
      _revertFavorite(index, useFiltered);
      print('Error toggling favorite league: $e');
      SSnackbar.error('Something went wrong');
    }
  }


  void _revertFavorite(int index, bool useFiltered) {
    final targetList = useFiltered ? filteredLeagues : leagues;

    if (index >= targetList.length) return;

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

  @override
  void onClose() {
    leagueByDateResponse.value = null;
    super.onClose();
  }
}