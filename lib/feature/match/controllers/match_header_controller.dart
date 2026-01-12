import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../core/const/string_const/API_endpoint.dart';
import '../../../core/local_storage/user_info.dart';

class MatchHeaderController extends GetxController {
  // Track favorite status
  RxBool isFavorite = false.obs;

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
        isFavorite.value = !isFavorite.value;

        // Show success message
        Get.snackbar(
          isFavorite.value ? 'Added to Favorites' : 'Removed from Favorites',
          isFavorite.value
              ? 'Match added to your favorites'
              : 'Match removed from your favorites',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          backgroundColor: isFavorite.value
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

  /// Check favorite status (optional - if you have an API to fetch this)
  Future<void> checkFavoriteStatus(int fixtureId) async {
    // Implement this if you have an API endpoint to check favorite status
    // For now, it defaults to false
    isFavorite.value = false;
  }
}