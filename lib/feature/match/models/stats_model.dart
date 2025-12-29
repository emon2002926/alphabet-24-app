import 'dart:convert';

StatsResponse statsResponseFromJson(String str) =>
    StatsResponse.fromJson(json.decode(str));

class StatsResponse {
  final String status;
  final int fixtureId;
  final String fixtureName;
  final StatsData data;
  final String timestamp;

  StatsResponse({
    required this.status,
    required this.fixtureId,
    required this.fixtureName,
    required this.data,
    required this.timestamp,
  });

  factory StatsResponse.fromJson(Map<String, dynamic> json) {
    return StatsResponse(
      status: json["status"] ?? "",
      fixtureId: json["fixture_id"] ?? 0,
      fixtureName: json["fixture_name"] ?? "",
      data: StatsData.fromJson(json["data"] ?? {}),
      timestamp: json["timestamp"] ?? "",
    );
  }
}

class StatsData {
  final Fixture fixture;
  final League league;
  final StateInfo state;
  final TeamStats homeTeam;
  final TeamStats awayTeam;
  final Map<String, ComparisonItem> comparison;

  StatsData({
    required this.fixture,
    required this.league,
    required this.state,
    required this.homeTeam,
    required this.awayTeam,
    required this.comparison,
  });

  factory StatsData.fromJson(Map<String, dynamic> json) {
    // Parse comparison data
    Map<String, ComparisonItem> comparisonMap = {};
    if (json["comparison"] != null) {
      (json["comparison"] as Map<String, dynamic>).forEach((key, value) {
        comparisonMap[key] = ComparisonItem.fromJson(value);
      });
    }

    return StatsData(
      fixture: Fixture.fromJson(json["fixture"] ?? {}),
      league: League.fromJson(json["league"] ?? {}),
      state: StateInfo.fromJson(json["state"] ?? {}),
      homeTeam: TeamStats.fromJson(json["home_team"] ?? {}),
      awayTeam: TeamStats.fromJson(json["away_team"] ?? {}),
      comparison: comparisonMap,
    );
  }
}

class Fixture {
  final int id;
  final String name;
  final String startingAt;

  Fixture({
    required this.id,
    required this.name,
    required this.startingAt,
  });

  factory Fixture.fromJson(Map<String, dynamic> json) {
    return Fixture(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      startingAt: json["starting_at"] ?? "",
    );
  }
}

class League {
  final int id;
  final String name;
  final String logo;

  League({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      logo: json["logo"] ?? "",
    );
  }
}

class StateInfo {
  final int id;
  final String name;
  final String shortName;

  StateInfo({
    required this.id,
    required this.name,
    required this.shortName,
  });

  factory StateInfo.fromJson(Map<String, dynamic> json) {
    return StateInfo(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      shortName: json["short_name"] ?? "",
    );
  }
}

class TeamStats {
  final int id;
  final String name;
  final String? shortCode;
  final String logo;
  final String location;
  final Map<String, StatItem> statistics;

  TeamStats({
    required this.id,
    required this.name,
    this.shortCode,
    required this.logo,
    required this.location,
    required this.statistics,
  });

  factory TeamStats.fromJson(Map<String, dynamic> json) {
    Map<String, StatItem> statsMap = {};
    if (json["statistics"] != null) {
      (json["statistics"] as Map<String, dynamic>).forEach((key, value) {
        statsMap[key] = StatItem.fromJson(value);
      });
    }

    return TeamStats(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      shortCode: json["short_code"],
      logo: json["logo"] ?? "",
      location: json["location"] ?? "",
      statistics: statsMap,
    );
  }
}

class StatItem {
  final dynamic value;
  final String name;
  final String code;

  StatItem({
    required this.value,
    required this.name,
    required this.code,
  });

  factory StatItem.fromJson(Map<String, dynamic> json) {
    return StatItem(
      value: json["value"],
      name: json["name"] ?? "",
      code: json["code"] ?? "",
    );
  }
}

class ComparisonItem {
  final double homeValue;
  final double awayValue;
  final double homePercentage;
  final double awayPercentage;
  final String name;

  ComparisonItem({
    required this.homeValue,
    required this.awayValue,
    required this.homePercentage,
    required this.awayPercentage,
    required this.name,
  });

  factory ComparisonItem.fromJson(Map<String, dynamic> json) {
    return ComparisonItem(
      homeValue: (json["home_value"] ?? 0).toDouble(),
      awayValue: (json["away_value"] ?? 0).toDouble(),
      homePercentage: (json["home_percentage"] ?? 0).toDouble(),
      awayPercentage: (json["away_percentage"] ?? 0).toDouble(),
      name: json["name"] ?? "",
    );
  }
}