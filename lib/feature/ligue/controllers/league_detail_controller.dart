// league_detail_controller.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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

  // Track favorite status for each fixture
  RxMap<int, bool> favoriteFixtures = <int, bool>{}.obs;

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

        // Initialize favorite status (you might want to fetch this from API)
        for (var match in [...liveMatches, ...todayFixtures]) {
          favoriteFixtures[match.id] = false; // Default to false
        }

        print('Live matches: ${liveMatches.length}');
        print('League details: ${leagueResponse.league.name}');
        print('Today fixtures: ${todayFixtures.length}');
      }
    } catch (e) {
      print('Error fetching league details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle favorite status for a fixture
  Future<void> toggleFavorite(int fixtureId) async {
    try {
      final response = await http.post(
        Uri.parse('${APIEndpoint.baseURL}sports-data/user/favorites/'),
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
        // Toggle the favorite status
        favoriteFixtures[fixtureId] = !(favoriteFixtures[fixtureId] ?? false);

        // Show success message
        Get.snackbar(
          favoriteFixtures[fixtureId]! ? 'Added to Favorites' : 'Removed from Favorites',
          favoriteFixtures[fixtureId]!
              ? 'Match added to your favorites'
              : 'Match removed from your favorites',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          backgroundColor: favoriteFixtures[fixtureId]!
              ? Colors.green.withOpacity(0.9)
              : Colors.orange.withOpacity(0.9),
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 8,
        );
      } else {
        throw Exception('Failed to toggle favorite: ${response.statusCode}');
      }

    } catch (e) {
      print('Error toggling favorite: $e');
      Get.snackbar(
        'Error',
        'Failed to update favorite status',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        borderRadius: 8,
      );
    }
  }

  /// Check if a fixture is favorite
  bool isFavorite(int fixtureId) {
    return favoriteFixtures[fixtureId] ?? false;
  }
}