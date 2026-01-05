// league_detail_response.dart
import '../../home/models/leage_list_model.dart';

class LeagueDetailResponse {
  final String status;
  final LeaguePrimary league;
  final LeagueMatchList liveMatches;
  final LeagueMatchList todayFixtures;

  LeagueDetailResponse({
    required this.status,
    required this.league,
    required this.liveMatches,
    required this.todayFixtures,
  });

  factory LeagueDetailResponse.fromJson(Map<String, dynamic> json) {
    return LeagueDetailResponse(
      status: json['status'] ?? '',
      league: LeaguePrimary.fromJson(json['league'] ?? {}),
      liveMatches: LeagueMatchList.fromJson(json['live_matches'] ?? {}),
      todayFixtures: LeagueMatchList.fromJson(json['today_fixtures'] ?? {}),
    );
  }
}

// class League {
//   final int id;
//   final String name;
//   final String shortCode;
//   final String logo;
//
//   League({
//     required this.id,
//     required this.name,
//     required this.shortCode,
//     required this.logo,
//   });
//
//   factory League.fromJson(Map<String, dynamic> json) {
//     return League(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? '',
//       shortCode: json['short_code'] ?? '',
//       logo: json['logo'] ?? '',
//     );
//   }
// }

class LeagueMatchList {
  final int count;
  final List<LeagueMatch> matches;

  LeagueMatchList({
    required this.count,
    required this.matches,
  });

  factory LeagueMatchList.fromJson(Map<String, dynamic> json) {
    var matchesJson = json['matches'] as List? ?? [];
    List<LeagueMatch> matchesList =
    matchesJson.map((e) => LeagueMatch.fromJson(e)).toList();
    return LeagueMatchList(
      count: json['count'] ?? 0,
      matches: matchesList,
    );
  }
}

class LeagueMatch {
  final int id;
  final String name;
  final String startingAt;
  final String state;
  final Team homeTeam;
  final Team awayTeam;

  LeagueMatch({
    required this.id,
    required this.name,
    required this.startingAt,
    required this.state,
    required this.homeTeam,
    required this.awayTeam,
  });

  factory LeagueMatch.fromJson(Map<String, dynamic> json) {
    return LeagueMatch(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      startingAt: json['starting_at'] ?? '',
      state: json['state'] ?? '',
      homeTeam: Team.fromJson(json['home_team'] ?? {}),
      awayTeam: Team.fromJson(json['away_team'] ?? {}),
    );
  }
}

class Team {
  final int id;
  final String name;
  final String logo;
  final int? score; // Nullable because upcoming matches have null

  Team({
    required this.id,
    required this.name,
    required this.logo,
    this.score,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      score: json['score'] != null ? json['score'] as int : null,
    );
  }
}
