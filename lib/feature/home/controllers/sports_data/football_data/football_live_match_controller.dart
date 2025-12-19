import 'package:get/get.dart';
import 'package:scaffassistant/core/const/string_const/API_endpoint.dart';
import 'package:scaffassistant/core/helper/api_request/get_request.dart';
import 'package:scaffassistant/core/local_storage/user_info.dart';
import '../../../../../core/helper/api_request/post_request.dart';
import '../../../../../core/universal_widgets/s_snackbar.dart';
import '../../../models/live_match_response_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:scaffassistant/core/const/string_const/API_endpoint.dart';
import 'package:scaffassistant/core/helper/api_request/get_request.dart';
import 'package:scaffassistant/core/local_storage/user_info.dart';
import '../../../models/live_match_response_model.dart';

class FootballLiveMatchController extends GetxController {
  // Reactive list of live matches
  RxList<LiveMatch> liveMatches = <LiveMatch>[].obs;

  // Loading indicator
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLiveMatches(); // Fetch data when controller initializes
  }

  Future<void> fetchLiveMatches() async {
    try {
      isLoading.value = true;

      GetAPIRequest getAPIRequest = GetAPIRequest(
        url: APIEndpoint.footballLiveMatch,
        headers: {
          'Authorization': 'Bearer ${UserInfo.getAccessToken()}'
        },
      );

      final response = await getAPIRequest.fetchData();

      if (response.isNotEmpty) {
        // Parse JSON into LiveMatch model
        final liveMatchResponse = LiveMatchResponse.fromJson(response);
        liveMatches.value = liveMatchResponse.matches; // update RxList
        print('Live Matches Updated: ${liveMatches.length}');

        isLoading.value = false;
      } else {
        print('Failed to fetch live match data');
        isLoading.value = false;
      }
    } catch (e) {
      print('Error fetching live matches: $e');
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }



  // ===== TOGGLE FAVORITE =====
  Future<void> toggleFavorite(int index) async {
    final match = liveMatches[index];

    // Optimistic UI update
    liveMatches[index].isFavoriteMatch = !match.isFavoriteMatch;
    liveMatches.refresh();

    try {
      final response = await http.post(
        Uri.parse(APIEndpoint.userFavorites),
        headers: {
          'Authorization': 'Bearer ${UserInfo.getAccessToken()}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'type': 'FIXTURE',
          'fixture_id': match.id,
        }),
      );

      print('Favorite API Response: ${response.statusCode}');
      print('Favorite API Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          SSnackbar.success(
            liveMatches[index].isFavoriteMatch
                ? 'Added to favorites'
                : 'Removed from favorites',
          );
        }
      } else {
        // Revert on failure
        liveMatches[index].isFavoriteMatch = !liveMatches[index].isFavoriteMatch;
        liveMatches.refresh();
        SSnackbar.error('Failed to update favorite');
      }
    } catch (e) {
      // Revert on error
      liveMatches[index].isFavoriteMatch = !liveMatches[index].isFavoriteMatch;
      liveMatches.refresh();
      print('Error toggling favorite: $e');
      SSnackbar.error('Something went wrong');
    }
  }
}