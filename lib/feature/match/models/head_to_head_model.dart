class HeadToHeadModel {
  final String status;
  final int fixtureId;
  final String fixtureName;
  final H2HData data;

  HeadToHeadModel({
    required this.status,
    required this.fixtureId,
    required this.fixtureName,
    required this.data,
  });

  factory HeadToHeadModel.fromJson(Map<String, dynamic> json) {
    return HeadToHeadModel(
      status: json["status"] ?? "",
      fixtureId: json["fixture_id"] ?? 0,
      fixtureName: json["fixture_name"] ?? "",
      data: H2HData.fromJson(json["data"] ?? {}),
    );
  }
}

class H2HData {
  final Fixture fixture;
  final League league;
  final H2HTeam homeTeam;
  final H2HTeam awayTeam;
  final Statistics statistics;
  final List<H2HMatch> matches;

  H2HData({
    required this.fixture,
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
    required this.statistics,
    required this.matches,
  });

  factory H2HData.fromJson(Map<String, dynamic> json) {
    return H2HData(
      fixture: Fixture.fromJson(json["fixture"] ?? {}),
      league: League.fromJson(json["league"] ?? {}),
      homeTeam: H2HTeam.fromJson(json["home_team"] ?? {}),
      awayTeam: H2HTeam.fromJson(json["away_team"] ?? {}),
      statistics: Statistics.fromJson(json["statistics"] ?? {}),
      matches: (json["matches"] as List?)
          ?.map((e) => H2HMatch.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class Fixture {
  final int id;
  final String name;
  final String startingAt;

  Fixture({required this.id, required this.name, required this.startingAt});

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

  League({required this.id, required this.name, required this.logo});

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      logo: json["logo"] ?? "",
    );
  }
}

class H2HTeam {
  final int id;
  final String name;
  final String? shortCode;
  final String logo;
  final String location;
  final List<String> recentForm;

  H2HTeam({
    required this.id,
    required this.name,
    this.shortCode,
    required this.logo,
    required this.location,
    required this.recentForm,
  });

  factory H2HTeam.fromJson(Map<String, dynamic> json) {
    return H2HTeam(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      shortCode: json["short_code"],
      logo: json["logo"] ?? "",
      location: json["location"] ?? "",
      recentForm: (json["recent_form"] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }
}

class Statistics {
  final int totalMatches;
  final int homeWins;
  final int awayWins;
  final int draws;
  final double homeWinPercentage;
  final double awayWinPercentage;
  final double drawPercentage;

  Statistics({
    required this.totalMatches,
    required this.homeWins,
    required this.awayWins,
    required this.draws,
    required this.homeWinPercentage,
    required this.awayWinPercentage,
    required this.drawPercentage,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      totalMatches: json["total_matches"] ?? 0,
      homeWins: json["home_wins"] ?? 0,
      awayWins: json["away_wins"] ?? 0,
      draws: json["draws"] ?? 0,
      homeWinPercentage: (json["home_win_percentage"] ?? 0).toDouble(),
      awayWinPercentage: (json["away_win_percentage"] ?? 0).toDouble(),
      drawPercentage: (json["draw_percentage"] ?? 0).toDouble(),
    );
  }
}

class H2HMatch {
  final int id;
  final String date;
  final League league;
  final int homeTeamScore;
  final int awayTeamScore;
  final String scoreDisplay;
  final String winner;
  final bool homeTeamWasHome;

  H2HMatch({
    required this.id,
    required this.date,
    required this.league,
    required this.homeTeamScore,
    required this.awayTeamScore,
    required this.scoreDisplay,
    required this.winner,
    required this.homeTeamWasHome,
  });

  factory H2HMatch.fromJson(Map<String, dynamic> json) {
    return H2HMatch(
      id: json["id"] ?? 0,
      date: json["date"] ?? "",
      league: League.fromJson(json["league"] ?? {}),
      homeTeamScore: json["home_team_score"] ?? 0,
      awayTeamScore: json["away_team_score"] ?? 0,
      scoreDisplay: json["score_display"] ?? "0 - 0",
      winner: json["winner"] ?? "",
      homeTeamWasHome: json["home_team_was_home"] ?? false,
    );
  }
}
