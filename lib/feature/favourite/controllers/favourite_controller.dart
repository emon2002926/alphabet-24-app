import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../core/const/string_const/API_endpoint.dart';
import '../../../core/local_storage/user_info.dart';
import '../../../core/universal_widgets/s_snackbar.dart';
import '../../home/models/live_match_response_model.dart';


class FavouriteController extends GetxController {
  RxList<FavouriteFixture> favouriteFixtures = <FavouriteFixture>[].obs;
  RxList<FavouriteFixture> filteredFixtures = <FavouriteFixture>[].obs;
  RxList<dynamic> favouriteTeams = <dynamic>[].obs;
  RxList<FavouriteLeague> favouriteLeagues = <FavouriteLeague>[].obs;
  RxList<FavouriteLeague> filteredLeagues = <FavouriteLeague>[].obs;
  RxInt totalFavourites = 0.obs;
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
    fetchFavourites();
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

    print('📅 Generated ${dateRange.length} dates for favorites');
  }

  void selectDate(DateTime date) {
    print('📅 Favorite date selected: ${DateFormat('yyyy-MM-dd').format(date)}');

    if (isDateFilterActive.value && _isSameDay(selectedDate.value, date)) {
      // Deactivate filter - show all favorites
      isDateFilterActive.value = false;
      print('🔓 Filter deactivated - showing all favorites');
    } else {
      // Activate filter - filter by date
      selectedDate.value = date;
      isDateFilterActive.value = true;
      print('✅ Date filter activated: ${DateFormat('yyyy-MM-dd').format(date)}');
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
    // Start with all fixtures
    var tempFixtures = favouriteFixtures.toList();

    // Apply date filter if active
    if (isDateFilterActive.value) {
      tempFixtures = tempFixtures.where((fixture) {
        final fixtureDate = DateTime(
          fixture.fixtureDate.year,
          fixture.fixtureDate.month,
          fixture.fixtureDate.day,
        );
        final selected = DateTime(
          selectedDate.value.year,
          selectedDate.value.month,
          selectedDate.value.day,
        );
        return fixtureDate.isAtSameMomentAs(selected);
      }).toList();
    }

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      tempFixtures = tempFixtures.where((fixture) {
        return fixture.homeTeam.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            fixture.awayTeam.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }

    filteredFixtures.value = tempFixtures;

    // Apply search filter to leagues (no date filter for leagues)
    if (searchQuery.value.isNotEmpty) {
      filteredLeagues.value = favouriteLeagues.where((league) {
        return league.leagueName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            league.leagueCountry.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    } else {
      filteredLeagues.value = favouriteLeagues;
    }

    print('📊 Filtered fixtures count: ${filteredFixtures.length}');
  }

  Future<void> fetchFavourites() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(APIEndpoint.userFavorites),
        headers: {
          'Authorization': 'Bearer ${UserInfo.getAccessToken()}',
          'Content-Type': 'application/json',
        },
      );

      print('Favourite API Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          final favouriteResponse = FavouriteResponse.fromJson(data);
          favouriteFixtures.value = favouriteResponse.fixtures;
          favouriteTeams.value = favouriteResponse.teams;
          favouriteLeagues.value = favouriteResponse.leagues;
          totalFavourites.value = favouriteResponse.total;

          // Apply initial filters
          applyFilters();

          print('✅ Favourite Fixtures Loaded: ${favouriteFixtures.length}');
          print('✅ Favourite Leagues Loaded: ${favouriteLeagues.length}');
        }
      } else {
        print('❌ Failed to fetch favourites: ${response.statusCode}');
        SSnackbar.error('Failed to load favourites');
      }
    } catch (e) {
      print('❌ Error fetching favourites: $e');
      SSnackbar.error('Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFixtureFavourite(int fixtureId) async {
    try {
      final response = await http.post(
        Uri.parse(APIEndpoint.userFavorites),
        headers: {
          'Authorization': 'Bearer ${UserInfo.getAccessToken()}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'type': 'FIXTURE',
          'fixture_id': fixtureId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          // Remove from main list
          favouriteFixtures.removeWhere((f) => f.fixtureId == fixtureId);

          // Update total
          totalFavourites.value = favouriteFixtures.length + favouriteLeagues.length;

          // Reapply filters
          applyFilters();

          SSnackbar.success('Match removed from favourites');
        }
      } else {
        SSnackbar.error('Failed to remove favourite');
      }
    } catch (e) {
      print('Error removing favourite: $e');
      SSnackbar.error('Something went wrong');
    }
  }

  Future<void> removeLeagueFavourite(int leagueId) async {
    try {
      final response = await http.post(
        Uri.parse(APIEndpoint.userFavorites),
        headers: {
          'Authorization': 'Bearer ${UserInfo.getAccessToken()}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'type': 'LEAGUE',
          'league_id': leagueId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          // Remove from main list
          favouriteLeagues.removeWhere((l) => l.leagueId == leagueId);

          // Update total
          totalFavourites.value = favouriteFixtures.length + favouriteLeagues.length;

          // Reapply filters
          applyFilters();

          SSnackbar.success('League removed from favourites');
        }
      } else {
        SSnackbar.error('Failed to remove favourite');
      }
    } catch (e) {
      print('Error removing favourite: $e');
      SSnackbar.error('Something went wrong');
    }
  }
}