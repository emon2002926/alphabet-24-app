// league_detail_controller.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scaffassistant/core/const/string_const/API_endpoint.dart';
import '../../../core/local_storage/user_info.dart';
import '../../favourite/controllers/favourite_controller.dart';
import '../../home/controllers/sports_data/football_data/football_live_match_controller.dart';
import '../../home/controllers/sports_data/football_data/leage_list_controller.dart';

class LeagueMatchListController extends GetxController {
  final int leagueId;
  LeagueMatchListController({required this.leagueId});

  // Track favorite status for each fixture
  RxMap<int, bool> favoriteFixtures = <int, bool>{}.obs;


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
        try {
          final favouriteController = Get.find<FavouriteController>();
          await favouriteController.fetchFavourites();
        } catch (e) {
          print('⚠️ FavouriteController not found or error refreshing: $e');
        }
        try {
          final favouriteController = Get.find<LeagueListController>();
          await favouriteController.fetchLeaguesByDate(
            favouriteController.selectedDate.value,
          );
        } catch (e) {
          print('⚠️ FavouriteController not found or error refreshing: $e');
        }
        try {
          final footballLiveMatchController = Get.find<FootballLiveMatchController>();
          await footballLiveMatchController.fetchMatches();
        } catch (e) {
          print('⚠️ FavouriteController not found or error refreshing: $e');
        }

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