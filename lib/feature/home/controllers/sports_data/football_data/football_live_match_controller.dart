import 'package:get/get.dart';
import 'package:scaffassistant/core/const/string_const/API_endpoint.dart';
import 'package:scaffassistant/core/helper/api_request/get_request.dart';
import 'package:scaffassistant/core/local_storage/user_info.dart';
import '../../../models/live_match_response_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';

class FootballLiveMatchController extends GetxController {
  // Reactive list of live matches
  RxList<LiveMatch> liveMatches = <LiveMatch>[].obs;

  // Loading indicator
  RxBool isLoading = false.obs;

  // Timer for periodic updates
  Timer? _updateTimer;

  // Update interval (10 seconds)
  final Duration updateInterval = const Duration(seconds: 100000);

  @override
  void onInit() {
    super.onInit();
    fetchLiveMatches(); // Initial fetch
    startAutoUpdate(); // Start periodic updates
  }

  @override
  void onClose() {
    stopAutoUpdate(); // Clean up timer when controller is disposed
    super.onClose();
  }

  // Start automatic updates every 10 seconds
  void startAutoUpdate() {
    _updateTimer = Timer.periodic(updateInterval, (timer) {
      fetchLiveMatches();
    });
  }

  // Stop automatic updates
  void stopAutoUpdate() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }

  Future<void> fetchLiveMatches() async {
    try {
      // Only show loading indicator on initial load
      if (liveMatches.isEmpty) {
        isLoading.value = true;
      }

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
      } else {
        print('Failed to fetch live match data');
      }
    } catch (e) {
      print('Error fetching live matches: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Manual refresh method (for pull-to-refresh)
  Future<void> refreshMatches() async {
    await fetchLiveMatches();
  }

  // ===== FAVORITE TOGGLE =====
  void toggleFavorite(int matchId) {
    final index = liveMatches.indexWhere((m) => m.id == matchId);

    if (index != -1) {
      // Toggle favorite status
      liveMatches[index].isFavoriteMatch = !liveMatches[index].isFavoriteMatch;

      // Trigger UI update
      liveMatches.refresh();

      // TODO: Add API call here later
      print('Match $matchId favorite status: ${liveMatches[index].isFavoriteMatch}');
    }
  }
}