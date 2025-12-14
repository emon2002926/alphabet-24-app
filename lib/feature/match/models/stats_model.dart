import 'dart:convert';

StatsResponse statsResponseFromJson(String str) =>
    StatsResponse.fromJson(json.decode(str));

class StatsResponse {
  final String status;
  final int fixtureId;
  final FixtureData fixture;
  final Predictions predictions;
  final ValueBets valueBets;
  final Odds odds;

  StatsResponse({
    required this.status,
    required this.fixtureId,
    required this.fixture,
    required this.predictions,
    required this.valueBets,
    required this.odds,
  });

  factory StatsResponse.fromJson(Map<String, dynamic> json) {
    return StatsResponse(
      status: json["status"],
      fixtureId: json["fixture_id"],
      fixture: FixtureData.fromJson(json["fixture"]),
      predictions: Predictions.fromJson(json["predictions"]),
      valueBets: ValueBets.fromJson(json["value_bets"]),
      odds: Odds.fromJson(json["odds"]),
    );
  }
}

class FixtureData {
  final int id;
  final String name;
  final String startingAt;
  final StateInfo state;
  final League league;
  final Team homeTeam;
  final Team awayTeam;

  FixtureData({
    required this.id,
    required this.name,
    required this.startingAt,
    required this.state,
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
  });

  factory FixtureData.fromJson(Map<String, dynamic> json) {
    return FixtureData(
      id: json["id"],
      name: json["name"],
      startingAt: json["starting_at"],
      state: StateInfo.fromJson(json["state"]),
      league: League.fromJson(json["league"]),
      homeTeam: Team.fromJson(json["home_team"]),
      awayTeam: Team.fromJson(json["away_team"]),
    );
  }
}

class StateInfo {
  final int id;
  final String name;
  final String shortName;
  final bool isLive;

  StateInfo({
    required this.id,
    required this.name,
    required this.shortName,
    required this.isLive,
  });

  factory StateInfo.fromJson(Map<String, dynamic> json) {
    return StateInfo(
      id: json["id"],
      name: json["name"],
      shortName: json["short_name"],
      isLive: json["is_live"],
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
      id: json["id"],
      name: json["name"],
      logo: json["logo"],
    );
  }
}

class Team {
  final int id;
  final String name;
  final String? shortCode;
  final String logo;
  final int score;

  Team({
    required this.id,
    required this.name,
    this.shortCode,
    required this.logo,
    required this.score,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json["id"],
      name: json["name"],
      shortCode: json["short_code"],
      logo: json["logo"],
      score: json["score"] ?? 0,
    );
  }
}

// ---------------- Predictions ----------------

class Predictions {
  final FullTimeResult fulltimeResult;
  final Map<String, double> bothTeamsToScore;
  final Map<String, double> overUnder25;
  final Map<String, double> doubleChance;
  final CorrectScores correctScores;

  Predictions({
    required this.fulltimeResult,
    required this.bothTeamsToScore,
    required this.overUnder25,
    required this.doubleChance,
    required this.correctScores,
  });

  factory Predictions.fromJson(Map<String, dynamic> json) {
    return Predictions(
      fulltimeResult: FullTimeResult.fromJson(json["fulltime_result"]),
      bothTeamsToScore: Map<String, double>.from(json["both_teams_to_score"]),
      overUnder25: Map<String, double>.from(json["over_under_2_5"]),
      doubleChance: Map<String, double>.from(json["double_chance"]),
      correctScores: CorrectScores.fromJson(json["correct_scores"]),
    );
  }
}

class FullTimeResult {
  final double homeWin;
  final double draw;
  final double awayWin;

  FullTimeResult({
    required this.homeWin,
    required this.draw,
    required this.awayWin,
  });

  factory FullTimeResult.fromJson(Map<String, dynamic> json) {
    return FullTimeResult(
      homeWin: (json["home_win"] as num).toDouble(),
      draw: (json["draw"] as num).toDouble(),
      awayWin: (json["away_win"] as num).toDouble(),
    );
  }
}

class CorrectScores {
  final List<TopScore> top10;

  CorrectScores({required this.top10});

  factory CorrectScores.fromJson(Map<String, dynamic> json) {
    return CorrectScores(
      top10: (json["top_10"] as List)
          .map((e) => TopScore.fromJson(e))
          .toList(),
    );
  }
}

class TopScore {
  final String score;
  final double probability;

  TopScore({required this.score, required this.probability});

  factory TopScore.fromJson(Map<String, dynamic> json) {
    return TopScore(
      score: json["score"],
      probability: (json["probability"] as num).toDouble(),
    );
  }
}

// ---------------- Value Bets ----------------

class ValueBets {
  final bool available;
  final int count;
  final List<ValueBet> bets;

  ValueBets({
    required this.available,
    required this.count,
    required this.bets,
  });

  factory ValueBets.fromJson(Map<String, dynamic> json) {
    return ValueBets(
      available: json["available"],
      count: json["count"],
      bets: (json["bets"] as List)
          .map((e) => ValueBet.fromJson(e))
          .toList(),
    );
  }
}

class ValueBet {
  final int id;
  final int fixtureId;

  ValueBet({required this.id, required this.fixtureId});

  factory ValueBet.fromJson(Map<String, dynamic> json) {
    return ValueBet(
      id: json["id"],
      fixtureId: json["fixture_id"],
    );
  }
}

// ---------------- Odds ----------------

class Odds {
  final PreMatch preMatch;

  Odds({required this.preMatch});

  factory Odds.fromJson(Map<String, dynamic> json) {
    return Odds(
      preMatch: PreMatch.fromJson(json["pre_match"]),
    );
  }
}

class PreMatch {
  final bool available;
  final int bookmakerId;
  final String bookmakerName;
  final int totalMarkets;

  PreMatch({
    required this.available,
    required this.bookmakerId,
    required this.bookmakerName,
    required this.totalMarkets,
  });

  factory PreMatch.fromJson(Map<String, dynamic> json) {
    return PreMatch(
      available: json["available"],
      bookmakerId: json["bookmaker_id"],
      bookmakerName: json["bookmaker_name"],
      totalMarkets: json["total_markets"],
    );
  }
}
