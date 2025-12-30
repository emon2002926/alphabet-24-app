import 'dart:convert';

PredictionsOddsResponse predictionsOddsResponseFromJson(String str) =>
    PredictionsOddsResponse.fromJson(json.decode(str));

class PredictionsOddsResponse {
  final String status;
  final int fixtureId;
  final FixtureInfo fixture;
  final PredictionsData predictions;
  final dynamic valueBets;
  final OddsData odds;
  final String timestamp;

  PredictionsOddsResponse({
    required this.status,
    required this.fixtureId,
    required this.fixture,
    required this.predictions,
    this.valueBets,
    required this.odds,
    required this.timestamp,
  });

  factory PredictionsOddsResponse.fromJson(Map<String, dynamic> json) {
    return PredictionsOddsResponse(
      status: json["status"] ?? "",
      fixtureId: json["fixture_id"] ?? 0,
      fixture: FixtureInfo.fromJson(json["fixture"] ?? {}),
      predictions: PredictionsData.fromJson(json["predictions"] ?? {}),
      valueBets: json["value_bets"],
      odds: OddsData.fromJson(json["odds"] ?? {}),
      timestamp: json["timestamp"] ?? "",
    );
  }
}

class FixtureInfo {
  final int id;
  final String name;
  final String startingAt;
  final int startingAtTimestamp;
  final StateInfo state;
  final League league;
  final TeamBasic homeTeam;
  final TeamBasic awayTeam;

  FixtureInfo({
    required this.id,
    required this.name,
    required this.startingAt,
    required this.startingAtTimestamp,
    required this.state,
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
  });

  factory FixtureInfo.fromJson(Map<String, dynamic> json) {
    return FixtureInfo(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      startingAt: json["starting_at"] ?? "",
      startingAtTimestamp: json["starting_at_timestamp"] ?? 0,
      state: StateInfo.fromJson(json["state"] ?? {}),
      league: League.fromJson(json["league"] ?? {}),
      homeTeam: TeamBasic.fromJson(json["home_team"] ?? {}),
      awayTeam: TeamBasic.fromJson(json["away_team"] ?? {}),
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
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      shortName: json["short_name"] ?? "",
      isLive: json["is_live"] ?? false,
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

class TeamBasic {
  final int id;
  final String name;
  final String? shortCode;
  final String logo;
  final int score;

  TeamBasic({
    required this.id,
    required this.name,
    this.shortCode,
    required this.logo,
    required this.score,
  });

  factory TeamBasic.fromJson(Map<String, dynamic> json) {
    return TeamBasic(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      shortCode: json["short_code"],
      logo: json["logo"] ?? "",
      score: json["score"] ?? 0,
    );
  }
}

class PredictionsData {
  final FullTimeResult fulltimeResult;
  final BothTeamsToScore bothTeamsToScore;
  final OverUnder25 overUnder25;
  final DoubleChance doubleChance;
  final CorrectScores correctScores;

  PredictionsData({
    required this.fulltimeResult,
    required this.bothTeamsToScore,
    required this.overUnder25,
    required this.doubleChance,
    required this.correctScores,
  });

  factory PredictionsData.fromJson(Map<String, dynamic> json) {
    return PredictionsData(
      fulltimeResult: FullTimeResult.fromJson(json["fulltime_result"] ?? {}),
      bothTeamsToScore: BothTeamsToScore.fromJson(json["both_teams_to_score"] ?? {}),
      overUnder25: OverUnder25.fromJson(json["over_under_2_5"] ?? {}),
      doubleChance: DoubleChance.fromJson(json["double_chance"] ?? {}),
      correctScores: CorrectScores.fromJson(json["correct_scores"] ?? {}),
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
      homeWin: (json["home_win"] ?? 0).toDouble(),
      draw: (json["draw"] ?? 0).toDouble(),
      awayWin: (json["away_win"] ?? 0).toDouble(),
    );
  }
}

class BothTeamsToScore {
  final double yes;
  final double no;

  BothTeamsToScore({
    required this.yes,
    required this.no,
  });

  factory BothTeamsToScore.fromJson(Map<String, dynamic> json) {
    return BothTeamsToScore(
      yes: (json["yes"] ?? 0).toDouble(),
      no: (json["no"] ?? 0).toDouble(),
    );
  }
}

class OverUnder25 {
  final double over;
  final double under;

  OverUnder25({
    required this.over,
    required this.under,
  });

  factory OverUnder25.fromJson(Map<String, dynamic> json) {
    return OverUnder25(
      over: (json["over"] ?? 0).toDouble(),
      under: (json["under"] ?? 0).toDouble(),
    );
  }
}

class DoubleChance {
  final double homeOrDraw;
  final double awayOrDraw;
  final double homeOrAway;

  DoubleChance({
    required this.homeOrDraw,
    required this.awayOrDraw,
    required this.homeOrAway,
  });

  factory DoubleChance.fromJson(Map<String, dynamic> json) {
    return DoubleChance(
      homeOrDraw: (json["home_or_draw"] ?? 0).toDouble(),
      awayOrDraw: (json["away_or_draw"] ?? 0).toDouble(),
      homeOrAway: (json["home_or_away"] ?? 0).toDouble(),
    );
  }
}

class CorrectScores {
  final List<TopScore> top10;

  CorrectScores({required this.top10});

  factory CorrectScores.fromJson(Map<String, dynamic> json) {
    return CorrectScores(
      top10: json["top_10"] != null
          ? (json["top_10"] as List).map((e) => TopScore.fromJson(e)).toList()
          : [],
    );
  }
}

class TopScore {
  final String score;
  final double probability;

  TopScore({
    required this.score,
    required this.probability,
  });

  factory TopScore.fromJson(Map<String, dynamic> json) {
    return TopScore(
      score: json["score"] ?? "",
      probability: (json["probability"] ?? 0).toDouble(),
    );
  }
}

class OddsData {
  final PreMatchOdds? preMatch;
  final dynamic inplay;

  OddsData({
    this.preMatch,
    this.inplay,
  });

  factory OddsData.fromJson(Map<String, dynamic> json) {
    return OddsData(
      preMatch: json["pre_match"] != null
          ? PreMatchOdds.fromJson(json["pre_match"])
          : null,
      inplay: json["inplay"],
    );
  }
}

class PreMatchOdds {
  final bool available;
  final int bookmakerId;
  final String bookmakerName;
  final int totalMarkets;
  final List<Market> markets;

  PreMatchOdds({
    required this.available,
    required this.bookmakerId,
    required this.bookmakerName,
    required this.totalMarkets,
    required this.markets,
  });

  factory PreMatchOdds.fromJson(Map<String, dynamic> json) {
    return PreMatchOdds(
      available: json["available"] ?? false,
      bookmakerId: json["bookmaker_id"] ?? 0,
      bookmakerName: json["bookmaker_name"] ?? "",
      totalMarkets: json["total_markets"] ?? 0,
      markets: json["markets"] != null
          ? (json["markets"] as List).map((e) => Market.fromJson(e)).toList()
          : [],
    );
  }
}

class Market {
  final int marketId;
  final String marketName;
  final List<Selection> selections;

  Market({
    required this.marketId,
    required this.marketName,
    required this.selections,
  });

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      marketId: json["market_id"] ?? 0,
      marketName: json["market_name"] ?? "",
      selections: json["selections"] != null
          ? (json["selections"] as List).map((e) => Selection.fromJson(e)).toList()
          : [],
    );
  }

  // Helper to get latest odds for each label
  Map<String, Selection> get latestOdds {
    final Map<String, Selection> latest = {};
    for (var selection in selections) {
      if (!latest.containsKey(selection.label) ||
          selection.id > latest[selection.label]!.id) {
        latest[selection.label] = selection;
      }
    }
    return latest;
  }
}

class Selection {
  final int id;
  final String label;
  final String? name;
  final double value;
  final String probability;
  final bool suspended;
  final dynamic total;

  Selection({
    required this.id,
    required this.label,
    this.name,
    required this.value,
    required this.probability,
    required this.suspended,
    this.total,
  });

  factory Selection.fromJson(Map<String, dynamic> json) {
    return Selection(
      id: json["id"] ?? 0,
      label: json["label"] ?? "",
      name: json["name"],
      value: (json["value"] ?? 0).toDouble(),
      probability: json["probability"] ?? "0%",
      suspended: json["suspended"] ?? false,
      total: json["total"],
    );
  }
}