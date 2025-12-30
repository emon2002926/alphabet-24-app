import 'package:get/get.dart';
import 'package:scaffassistant/core/const/string_const/API_endpoint.dart';
import 'package:scaffassistant/core/helper/api_request/get_request.dart';
import 'package:scaffassistant/core/local_storage/user_info.dart';
import '../../../../../core/universal_widgets/s_snackbar.dart';
import '../../../models/live_match_response_model.dart';
import 'dart:async';

import 'dart:convert';
import 'package:http/http.dart' as http;

class FootballLiveMatchController extends GetxController {
  // Reactive lists
  RxList<LiveMatch> liveMatches = <LiveMatch>[].obs;
  RxList<LiveMatch> upcomingMatches = <LiveMatch>[].obs;

  // Grouped matches by league (combines both live and upcoming)
  RxList<LeagueGroup> groupedMatches = <LeagueGroup>[].obs;

  // Loading indicator
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    try {
      isLoading.value = true;

      // Fetch both live and upcoming matches
      await Future.wait([
        fetchLiveMatches(),
        fetchTodayMatches(),
      ]);

      // Group all matches by league
      _groupMatchesByLeague();

    } catch (e) {
      print('❌ Error fetching matches: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLiveMatches() async {
    try {
      GetAPIRequest getAPIRequest = GetAPIRequest(
        url: APIEndpoint.footballLiveMatch,
        headers: {
          'Authorization': 'Bearer ${UserInfo.getAccessToken()}'
        },
      );

      final response = await getAPIRequest.fetchData();

      if (response.isNotEmpty && response['matches'] != null) {
        final liveMatchResponse = LiveMatchResponse.fromJson(response);

        if (liveMatchResponse.matches.isNotEmpty) {
          liveMatches.value = liveMatchResponse.matches;
          print('✅ Live Matches Loaded: ${liveMatches.length}');
        } else {
          liveMatches.clear();
          print('⚠️ No live matches available');
        }
      }
    } catch (e) {
      print('❌ Error fetching live matches: $e');
      liveMatches.clear();
    }
  }

  Future<void> fetchTodayMatches() async {
    try {
      GetAPIRequest getAPIRequest = GetAPIRequest(
        url: '${APIEndpoint.baseURL}sports-data/today-matches/',
        headers: {
          'Authorization': 'Bearer ${UserInfo.getAccessToken()}'
        },
      );

      final response = await getAPIRequest.fetchData();

      if (response.isNotEmpty) {
        if (response['upcoming'] != null &&
            response['upcoming']['matches'] != null) {

          final upcomingList = response['upcoming']['matches'] as List;

          if (upcomingList.isNotEmpty) {
            upcomingMatches.value = upcomingList
                .map((match) => _convertTodayMatchToLiveMatch(match))
                .toList();

            print('✅ Upcoming Matches Loaded: ${upcomingMatches.length}');
          } else {
            upcomingMatches.clear();
          }
        }
      }
    } catch (e) {
      print('❌ Error fetching today matches: $e');
      upcomingMatches.clear();
    }
  }

  LiveMatch _convertTodayMatchToLiveMatch(Map<String, dynamic> json) {
    return LiveMatch(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      startingAt: DateTime.tryParse(json['starting_at'] ?? "") ?? DateTime.now(),
      status: MatchStatus(
        isLive: json['is_live'] ?? false,
        minute: json['minute'],
        state: json['state'] ?? "Not Started",
        stateShort: json['state_short'] ?? "NS",
        stateId: json['state_id'] ?? 1,
      ),
      isFavoriteMatch: false,
      matchReason: [],
      league: League.fromJson(json['league'] ?? {}),
      round: Round.fromJson(json['round'] ?? {}),
      homeTeam: Team(
        id: json['home_team']?['id'] ?? 0,
        name: json['home_team']?['name'] ?? "",
        shortCode: json['home_team']?['short_code'],
        logo: json['home_team']?['logo'] ?? "",
        location: "home",
        score: json['home_team']?['score'] ?? 0,
        isFavorite: false,
        statistics: null,
        events: [],
      ),
      awayTeam: Team(
        id: json['away_team']?['id'] ?? 0,
        name: json['away_team']?['name'] ?? "",
        shortCode: json['away_team']?['short_code'],
        logo: json['away_team']?['logo'] ?? "",
        location: "away",
        score: json['away_team']?['score'] ?? 0,
        isFavorite: false,
        statistics: null,
        events: [],
      ),
      score: MatchScore(
        home: json['home_team']?['score'] ?? 0,
        away: json['away_team']?['score'] ?? 0,
        display: "- : -",
      ),
      periods: [],
      events: [],
      venue: json['venue'] != null ? Venue.fromJson(json['venue']) : null,
      predictions: Predictions.fromJson(json['predictions'] ?? {}),
    );
  }

  void _groupMatchesByLeague() {
    // Combine live and upcoming matches (live matches first)
    final allMatches = <LiveMatch>[
      ...liveMatches,
      ...upcomingMatches,
    ];

    if (allMatches.isEmpty) {
      groupedMatches.clear();
      return;
    }

    final Map<int, LeagueGroup> leagueMap = {};

    for (var match in allMatches) {
      final leagueId = match.league.id;

      if (!leagueMap.containsKey(leagueId)) {
        leagueMap[leagueId] = LeagueGroup(
          leagueId: leagueId,
          leagueName: match.league.name,
          leagueLogo: match.league.logo,
          countryName: match.league.country.name,
          liveCount: 0,
          upcomingCount: 0,
          matches: [],
        );
      }

      leagueMap[leagueId]!.matches.add(match);

      // Count live vs upcoming
      if (match.status.isLive) {
        leagueMap[leagueId]!.liveCount++;
      } else {
        leagueMap[leagueId]!.upcomingCount++;
      }
    }

    // Sort matches within each league: live first, then by start time
    for (var leagueGroup in leagueMap.values) {
      leagueGroup.matches.sort((a, b) {
        // Live matches first
        if (a.status.isLive && !b.status.isLive) return -1;
        if (!a.status.isLive && b.status.isLive) return 1;

        // Then sort by start time
        return a.startingAt.compareTo(b.startingAt);
      });
    }

    // Sort leagues: those with live matches first, then alphabetically
    groupedMatches.value = leagueMap.values.toList()
      ..sort((a, b) {
        // Leagues with live matches first
        if (a.liveCount > 0 && b.liveCount == 0) return -1;
        if (a.liveCount == 0 && b.liveCount > 0) return 1;

        // Then alphabetically
        return a.leagueName.compareTo(b.leagueName);
      });

    print('📊 Grouped into ${groupedMatches.length} leagues (${liveMatches.length} live, ${upcomingMatches.length} upcoming)');
  }

  // Get all matches (for backward compatibility)
  List<LiveMatch> get displayMatches {
    return [...liveMatches, ...upcomingMatches];
  }

  // ===== toggleFavorite for backward compatibility =====
  Future<void> toggleFavorite(int index) async {
    final allMatches = displayMatches;
    if (index >= allMatches.length) return;

    final match = allMatches[index];
    final isLive = match.status.isLive;

    // Find the match in the appropriate list
    final targetList = isLive ? liveMatches : upcomingMatches;
    final targetIndex = targetList.indexWhere((m) => m.id == match.id);

    if (targetIndex == -1) return;

    // Optimistic UI update
    targetList[targetIndex].isFavoriteMatch = !match.isFavoriteMatch;
    targetList.refresh();

    // Also update in grouped matches
    _updateFavoriteInGroups(match.id, targetList[targetIndex].isFavoriteMatch);

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

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          SSnackbar.success(
            targetList[targetIndex].isFavoriteMatch
                ? 'Added to favorites'
                : 'Removed from favorites',
          );
        }
      } else {
        // Revert on failure
        targetList[targetIndex].isFavoriteMatch = !targetList[targetIndex].isFavoriteMatch;
        targetList.refresh();
        _updateFavoriteInGroups(match.id, targetList[targetIndex].isFavoriteMatch);
        SSnackbar.error('Failed to update favorite');
      }
    } catch (e) {
      // Revert on error
      targetList[targetIndex].isFavoriteMatch = !targetList[targetIndex].isFavoriteMatch;
      targetList.refresh();
      _updateFavoriteInGroups(match.id, targetList[targetIndex].isFavoriteMatch);
      print('Error toggling favorite: $e');
      SSnackbar.error('Something went wrong');
    }
  }

  // ===== toggleFavoriteInGroup for grouped view =====
  Future<void> toggleFavoriteInGroup(int leagueIndex, int matchIndex) async {
    if (leagueIndex >= groupedMatches.length) return;
    final leagueGroup = groupedMatches[leagueIndex];

    if (matchIndex >= leagueGroup.matches.length) return;
    final match = leagueGroup.matches[matchIndex];

    // Optimistic UI update
    groupedMatches[leagueIndex].matches[matchIndex].isFavoriteMatch =
    !match.isFavoriteMatch;
    groupedMatches.refresh();

    // Also update in the main lists
    final isLive = match.status.isLive;
    final mainList = isLive ? liveMatches : upcomingMatches;
    final mainIndex = mainList.indexWhere((m) => m.id == match.id);
    if (mainIndex != -1) {
      mainList[mainIndex].isFavoriteMatch =
          groupedMatches[leagueIndex].matches[matchIndex].isFavoriteMatch;
      mainList.refresh();
    }

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

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          SSnackbar.success(
            match.isFavoriteMatch
                ? 'Added to favorites'
                : 'Removed from favorites',
          );
        }
      } else {
        _revertFavoriteInGroup(leagueIndex, matchIndex);
        SSnackbar.error('Failed to update favorite');
      }
    } catch (e) {
      _revertFavoriteInGroup(leagueIndex, matchIndex);
      print('Error toggling favorite: $e');
      SSnackbar.error('Something went wrong');
    }
  }

  void _revertFavoriteInGroup(int leagueIndex, int matchIndex) {
    if (leagueIndex >= groupedMatches.length) return;
    if (matchIndex >= groupedMatches[leagueIndex].matches.length) return;

    final match = groupedMatches[leagueIndex].matches[matchIndex];
    groupedMatches[leagueIndex].matches[matchIndex].isFavoriteMatch =
    !match.isFavoriteMatch;
    groupedMatches.refresh();

    final isLive = match.status.isLive;
    final mainList = isLive ? liveMatches : upcomingMatches;
    final mainIndex = mainList.indexWhere((m) => m.id == match.id);
    if (mainIndex != -1) {
      mainList[mainIndex].isFavoriteMatch =
          groupedMatches[leagueIndex].matches[matchIndex].isFavoriteMatch;
      mainList.refresh();
    }
  }

  // Helper to update favorite status in grouped matches
  void _updateFavoriteInGroups(int matchId, bool isFavorite) {
    for (var leagueGroup in groupedMatches) {
      final matchIndex = leagueGroup.matches.indexWhere((m) => m.id == matchId);
      if (matchIndex != -1) {
        leagueGroup.matches[matchIndex].isFavoriteMatch = isFavorite;
      }
    }
    groupedMatches.refresh();
  }
}

// League Group Model (updated with counts)
class LeagueGroup {
  final int leagueId;
  final String leagueName;
  final String leagueLogo;
  final String countryName;
  int liveCount;
  int upcomingCount;
  final List<LiveMatch> matches;

  LeagueGroup({
    required this.leagueId,
    required this.leagueName,
    required this.leagueLogo,
    required this.countryName,
    required this.liveCount,
    required this.upcomingCount,
    required this.matches,
  });

  int get totalCount => matches.length;
}