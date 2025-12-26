import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

  // ===== DATE SELECTION =====
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxList<DateTime> dateRange = <DateTime>[].obs;
  RxBool isDateFilterActive = false.obs;

  @override
  void onInit() {
    super.onInit();
    generateDateRange();
    fetchLeagues();
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

    if (isDateFilterActive.value && _isSameDay(selectedDate.value, date)) {
      isDateFilterActive.value = false;
      print('🔓 Filter deactivated - showing all leagues');
    } else {
      selectedDate.value = date;
      isDateFilterActive.value = true;
      print('✅ Date selected: ${DateFormat('yyyy-MM-dd').format(date)}');
    }

    applyFilters();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void clearSearch() {
    searchQuery.value = '';
    applyFilters();
  }

  void applyFilters() {
    var filtered = leagues.where((league) {
      bool dateMatches = true;
      if (isDateFilterActive.value) {
        final leagueDate = DateTime(
          league.lastPlayedAt.year,
          league.lastPlayedAt.month,
          league.lastPlayedAt.day,
        );
        final selected = DateTime(
          selectedDate.value.year,
          selectedDate.value.month,
          selectedDate.value.day,
        );
        dateMatches = leagueDate.isAtSameMomentAs(selected);
      }

      bool searchMatches = true;
      if (searchQuery.value.isNotEmpty) {
        searchMatches = league.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            league.shortCode.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            league.country.name.toLowerCase().contains(searchQuery.value.toLowerCase());
      }

      return dateMatches && searchMatches;
    }).toList();

    filteredLeagues.value = filtered;
    print('📊 Filtered leagues count: ${filteredLeagues.length}');
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
        applyFilters();
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

    targetList[index].isFavorite = !league.isFavorite;
    targetList.refresh();

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