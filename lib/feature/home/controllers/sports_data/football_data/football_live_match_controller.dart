import 'package:get/get.dart';
import 'package:scaffassistant/core/const/string_const/API_endpoint.dart';
import 'package:scaffassistant/core/helper/api_request/get_request.dart';
import 'package:scaffassistant/core/local_storage/user_info.dart';
import '../../../models/live_match_response_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class FootballLiveMatchController extends GetxController {
  RxList<LiveMatch> liveMatches = <LiveMatch>[].obs;
  RxBool isLoading = false.obs;
  Timer? _updateTimer;
  final Duration updateInterval = const Duration(seconds: 100000);

  @override
  void onInit() {
    super.onInit();
    fetchLiveMatches();
    startAutoUpdate();
  }

  @override
  void onClose() {
    stopAutoUpdate();
    super.onClose();
  }

  void startAutoUpdate() {
    _updateTimer = Timer.periodic(updateInterval, (timer) {
      fetchLiveMatches();
    });
  }

  void stopAutoUpdate() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }

  Future<void> fetchLiveMatches() async {
    try {
      if (liveMatches.isEmpty) isLoading.value = true;

      GetAPIRequest getAPIRequest = GetAPIRequest(
        url: APIEndpoint.footballLiveMatch,
        headers: {'Authorization': 'Bearer ${UserInfo.getAccessToken()}'},
      );

      final response = await getAPIRequest.fetchData();

      if (response.isNotEmpty) {
        final liveMatchResponse = LiveMatchResponse.fromJson(response);
        liveMatches.value = liveMatchResponse.matches;
        print('Live Matches Updated: ${liveMatches.length}');
      }
    } catch (e) {
      print('Error fetching live matches: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshMatches() async {
    await fetchLiveMatches();
  }

  // ===== TOGGLE FAVORITE =====
  Future<void> toggleFavorite(int matchId) async {
    final index = liveMatches.indexWhere((m) => m.id == matchId);
    if (index == -1) return;

    final previousState = liveMatches[index].isFavoriteMatch;
    liveMatches[index].isFavoriteMatch = !previousState;
    liveMatches.refresh();

    try {
      final teamId = liveMatches[index].homeTeam.id;

      final response = await http.post(
        Uri.parse('${APIEndpoint.addToFavorite}'),
        headers: {
          'Authorization': 'Bearer ${UserInfo.getAccessToken()}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'type': 'TEAM', 'team_id': teamId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _showSuccessMessage(data['message'], liveMatches[index].isFavoriteMatch);
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      liveMatches[index].isFavoriteMatch = previousState;
      liveMatches.refresh();
      _showErrorMessage();
    }
  }

  void _showSuccessMessage(String? message, bool isFavorite) {
    Get.snackbar(
      '',
      '',
      titleText: SizedBox.shrink(),
      messageText: Row(
        children: [
          Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
            size: 20,
          ),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              message ?? (isFavorite ? 'Added to favorites' : 'Removed from favorites'),
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
      backgroundColor: isFavorite ? Colors.red : Colors.grey[700],
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(8),
      snackPosition: SnackPosition.TOP,
    );
  }

  void _showErrorMessage() {
    Get.snackbar(
      'Error',
      'Failed to update favorite',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(8),
      snackPosition: SnackPosition.TOP,
    );
  }

  List<LiveMatch> getFavoriteMatches() {
    return liveMatches.where((match) => match.isFavoriteMatch).toList();
  }

  bool isFavorite(int matchId) {
    final match = liveMatches.firstWhereOrNull((m) => m.id == matchId);
    return match?.isFavoriteMatch ?? false;
  }
}