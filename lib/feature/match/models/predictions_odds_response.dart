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
  // Main predictions
  final FullTimeResult fulltimeResult;
  final BothTeamsToScore bothTeamsToScore;
  final DoubleChance doubleChance;
  final CorrectScores correctScores;

  // Over/Under Goals
  final OverUnderGoals overUnder05;
  final OverUnderGoals overUnder15;
  final OverUnderGoals overUnder25;
  final OverUnderGoals overUnder35;
  final OverUnderGoals overUnder45;

  // Team to Score First
  final ThreeWayResult? teamToScoreFirst;

  // First Half Winner
  final ThreeWayResult? firstHalfWinner;

  // Half Time/Full Time
  final HalfTimeFullTime? halfTimeFullTime;

  // Home Over/Under
  final OverUnderGoals? homeOverUnder05;
  final OverUnderGoals? homeOverUnder15;
  final OverUnderGoals? homeOverUnder25;
  final OverUnderGoals? homeOverUnder35;

  // Away Over/Under
  final OverUnderGoals? awayOverUnder05;
  final OverUnderGoals? awayOverUnder15;
  final OverUnderGoals? awayOverUnder25;
  final OverUnderGoals? awayOverUnder35;

  // Corners Over/Under
  final CornersOverUnder? cornersOverUnder4;
  final CornersOverUnder? cornersOverUnder5;
  final CornersOverUnder? cornersOverUnder6;
  final CornersOverUnder? cornersOverUnder7;
  final CornersOverUnder? cornersOverUnder8;
  final CornersOverUnder? cornersOverUnder9;
  final CornersOverUnder? cornersOverUnder10;
  final CornersOverUnder? cornersOverUnder105;
  final CornersOverUnder? cornersOverUnder11;

  PredictionsData({
    required this.fulltimeResult,
    required this.bothTeamsToScore,
    required this.doubleChance,
    required this.correctScores,
    required this.overUnder05,
    required this.overUnder15,
    required this.overUnder25,
    required this.overUnder35,
    required this.overUnder45,
    this.teamToScoreFirst,
    this.firstHalfWinner,
    this.halfTimeFullTime,
    this.homeOverUnder05,
    this.homeOverUnder15,
    this.homeOverUnder25,
    this.homeOverUnder35,
    this.awayOverUnder05,
    this.awayOverUnder15,
    this.awayOverUnder25,
    this.awayOverUnder35,
    this.cornersOverUnder4,
    this.cornersOverUnder5,
    this.cornersOverUnder6,
    this.cornersOverUnder7,
    this.cornersOverUnder8,
    this.cornersOverUnder9,
    this.cornersOverUnder10,
    this.cornersOverUnder105,
    this.cornersOverUnder11,
  });

  factory PredictionsData.fromJson(Map<String, dynamic> json) {
    return PredictionsData(
      // Main predictions
      fulltimeResult: FullTimeResult.fromJson(json["fulltime_result"] ?? {}),
      bothTeamsToScore: BothTeamsToScore.fromJson(json["both_teams_to_score"] ?? {}),
      doubleChance: DoubleChance.fromJson(json["double_chance"] ?? {}),
      correctScores: CorrectScores.fromJson(json["correct_scores"] ?? {}),

      // Over/Under Goals
      overUnder05: OverUnderGoals.fromJson(json["over_under_0_5"] ?? {}),
      overUnder15: OverUnderGoals.fromJson(json["over_under_1_5"] ?? {}),
      overUnder25: OverUnderGoals.fromJson(json["over_under_2_5"] ?? {}),
      overUnder35: OverUnderGoals.fromJson(json["over_under_3_5"] ?? {}),
      overUnder45: OverUnderGoals.fromJson(json["over_under_4_5"] ?? {}),

      // Team to Score First
      teamToScoreFirst: json["team_to_score_first"] != null
          ? ThreeWayResult.fromJson(json["team_to_score_first"])
          : null,

      // First Half Winner
      firstHalfWinner: json["first_half_winner"] != null
          ? ThreeWayResult.fromJson(json["first_half_winner"])
          : null,

      // Half Time/Full Time
      halfTimeFullTime: json["half_time_full_time"] != null
          ? HalfTimeFullTime.fromJson(json["half_time_full_time"])
          : null,

      // Home Over/Under
      homeOverUnder05: json["home_over_under_0_5"] != null
          ? OverUnderGoals.fromJson(json["home_over_under_0_5"])
          : null,
      homeOverUnder15: json["home_over_under_1_5"] != null
          ? OverUnderGoals.fromJson(json["home_over_under_1_5"])
          : null,
      homeOverUnder25: json["home_over_under_2_5"] != null
          ? OverUnderGoals.fromJson(json["home_over_under_2_5"])
          : null,
      homeOverUnder35: json["home_over_under_3_5"] != null
          ? OverUnderGoals.fromJson(json["home_over_under_3_5"])
          : null,

      // Away Over/Under
      awayOverUnder05: json["away_over_under_0_5"] != null
          ? OverUnderGoals.fromJson(json["away_over_under_0_5"])
          : null,
      awayOverUnder15: json["away_over_under_1_5"] != null
          ? OverUnderGoals.fromJson(json["away_over_under_1_5"])
          : null,
      awayOverUnder25: json["away_over_under_2_5"] != null
          ? OverUnderGoals.fromJson(json["away_over_under_2_5"])
          : null,
      awayOverUnder35: json["away_over_under_3_5"] != null
          ? OverUnderGoals.fromJson(json["away_over_under_3_5"])
          : null,

      // Corners Over/Under
      cornersOverUnder4: json["corners_over_under_4"] != null
          ? CornersOverUnder.fromJson(json["corners_over_under_4"])
          : null,
      cornersOverUnder5: json["corners_over_under_5"] != null
          ? CornersOverUnder.fromJson(json["corners_over_under_5"])
          : null,
      cornersOverUnder6: json["corners_over_under_6"] != null
          ? CornersOverUnder.fromJson(json["corners_over_under_6"])
          : null,
      cornersOverUnder7: json["corners_over_under_7"] != null
          ? CornersOverUnder.fromJson(json["corners_over_under_7"])
          : null,
      cornersOverUnder8: json["corners_over_under_8"] != null
          ? CornersOverUnder.fromJson(json["corners_over_under_8"])
          : null,
      cornersOverUnder9: json["corners_over_under_9"] != null
          ? CornersOverUnder.fromJson(json["corners_over_under_9"])
          : null,
      cornersOverUnder10: json["corners_over_under_10"] != null
          ? CornersOverUnder.fromJson(json["corners_over_under_10"])
          : null,
      cornersOverUnder105: json["corners_over_under_10_5"] != null
          ? CornersOverUnder.fromJson(json["corners_over_under_10_5"])
          : null,
      cornersOverUnder11: json["corners_over_under_11"] != null
          ? CornersOverUnder.fromJson(json["corners_over_under_11"])
          : null,
    );
  }

  // Helper to get all available corners predictions as a list
  List<MapEntry<String, CornersOverUnder>> get availableCornersPredictions {
    final List<MapEntry<String, CornersOverUnder>> corners = [];
    if (cornersOverUnder4 != null) corners.add(MapEntry('4', cornersOverUnder4!));
    if (cornersOverUnder5 != null) corners.add(MapEntry('5', cornersOverUnder5!));
    if (cornersOverUnder6 != null) corners.add(MapEntry('6', cornersOverUnder6!));
    if (cornersOverUnder7 != null) corners.add(MapEntry('7', cornersOverUnder7!));
    if (cornersOverUnder8 != null) corners.add(MapEntry('8', cornersOverUnder8!));
    if (cornersOverUnder9 != null) corners.add(MapEntry('9', cornersOverUnder9!));
    if (cornersOverUnder10 != null) corners.add(MapEntry('10', cornersOverUnder10!));
    if (cornersOverUnder105 != null) corners.add(MapEntry('10.5', cornersOverUnder105!));
    if (cornersOverUnder11 != null) corners.add(MapEntry('11', cornersOverUnder11!));
    return corners;
  }

  // Helper to get all available home over/under predictions
  List<MapEntry<String, OverUnderGoals>> get availableHomeOverUnder {
    final List<MapEntry<String, OverUnderGoals>> list = [];
    if (homeOverUnder05 != null) list.add(MapEntry('0.5', homeOverUnder05!));
    if (homeOverUnder15 != null) list.add(MapEntry('1.5', homeOverUnder15!));
    if (homeOverUnder25 != null) list.add(MapEntry('2.5', homeOverUnder25!));
    if (homeOverUnder35 != null) list.add(MapEntry('3.5', homeOverUnder35!));
    return list;
  }

  // Helper to get all available away over/under predictions
  List<MapEntry<String, OverUnderGoals>> get availableAwayOverUnder {
    final List<MapEntry<String, OverUnderGoals>> list = [];
    if (awayOverUnder05 != null) list.add(MapEntry('0.5', awayOverUnder05!));
    if (awayOverUnder15 != null) list.add(MapEntry('1.5', awayOverUnder15!));
    if (awayOverUnder25 != null) list.add(MapEntry('2.5', awayOverUnder25!));
    if (awayOverUnder35 != null) list.add(MapEntry('3.5', awayOverUnder35!));
    return list;
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

class OverUnderGoals {
  final double over;
  final double under;

  OverUnderGoals({
    required this.over,
    required this.under,
  });

  factory OverUnderGoals.fromJson(Map<String, dynamic> json) {
    return OverUnderGoals(
      over: (json["over"] ?? json["yes"] ?? 0).toDouble(),
      under: (json["under"] ?? json["no"] ?? 0).toDouble(),
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

// Three-way result (Home/Draw/Away)
class ThreeWayResult {
  final double home;
  final double draw;
  final double away;

  ThreeWayResult({
    required this.home,
    required this.draw,
    required this.away,
  });

  factory ThreeWayResult.fromJson(Map<String, dynamic> json) {
    return ThreeWayResult(
      home: (json["home"] ?? 0).toDouble(),
      draw: (json["draw"] ?? 0).toDouble(),
      away: (json["away"] ?? 0).toDouble(),
    );
  }
}

// Corners Over/Under (Yes/Equal/No)
class CornersOverUnder {
  final double yes;
  final double equal;
  final double no;

  CornersOverUnder({
    required this.yes,
    required this.equal,
    required this.no,
  });

  factory CornersOverUnder.fromJson(Map<String, dynamic> json) {
    return CornersOverUnder(
      yes: (json["yes"] ?? json["over"] ?? 0).toDouble(),
      equal: (json["equal"] ?? 0).toDouble(),
      no: (json["no"] ?? json["under"] ?? 0).toDouble(),
    );
  }
}

// Half Time/Full Time
class HalfTimeFullTime {
  final double homeHome;
  final double homeDraw;
  final double homeAway;
  final double drawHome;
  final double drawDraw;
  final double drawAway;
  final double awayHome;
  final double awayDraw;
  final double awayAway;

  HalfTimeFullTime({
    required this.homeHome,
    required this.homeDraw,
    required this.homeAway,
    required this.drawHome,
    required this.drawDraw,
    required this.drawAway,
    required this.awayHome,
    required this.awayDraw,
    required this.awayAway,
  });

  factory HalfTimeFullTime.fromJson(Map<String, dynamic> json) {
    return HalfTimeFullTime(
      homeHome: (json["home_home"] ?? json["HH"] ?? 0).toDouble(),
      homeDraw: (json["home_draw"] ?? json["HD"] ?? 0).toDouble(),
      homeAway: (json["home_away"] ?? json["HA"] ?? 0).toDouble(),
      drawHome: (json["draw_home"] ?? json["DH"] ?? 0).toDouble(),
      drawDraw: (json["draw_draw"] ?? json["DD"] ?? 0).toDouble(),
      drawAway: (json["draw_away"] ?? json["DA"] ?? 0).toDouble(),
      awayHome: (json["away_home"] ?? json["AH"] ?? 0).toDouble(),
      awayDraw: (json["away_draw"] ?? json["AD"] ?? 0).toDouble(),
      awayAway: (json["away_away"] ?? json["AA"] ?? 0).toDouble(),
    );
  }

  // Helper to get values as a 3x3 grid
  List<List<double>> get asGrid => [
    [homeHome, homeDraw, homeAway],
    [drawHome, drawDraw, drawAway],
    [awayHome, awayDraw, awayAway],
  ];

  // Helper to get labels as a 3x3 grid
  List<List<String>> get labelsGrid => [
    ['HH', 'HD', 'HA'],
    ['DH', 'DD', 'DA'],
    ['AH', 'AD', 'AA'],
  ];
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

  Market? getMarketByName(String name) {
    try {
      return markets.firstWhere(
            (m) => m.marketName.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  Market? getMarketById(int id) {
    try {
      return markets.firstWhere((m) => m.marketId == id);
    } catch (e) {
      return null;
    }
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

  Map<String, Selection> getLatestOddsByTotal(String total) {
    final Map<String, Selection> latest = {};
    final filteredSelections = selections.where((s) => s.total == total);
    for (var selection in filteredSelections) {
      if (!latest.containsKey(selection.label) ||
          selection.id > latest[selection.label]!.id) {
        latest[selection.label] = selection;
      }
    }
    return latest;
  }

  List<String> get availableTotals {
    final totals = <String>{};
    for (var selection in selections) {
      if (selection.total != null) {
        totals.add(selection.total.toString());
      }
    }
    return totals.toList()..sort((a, b) => double.parse(a).compareTo(double.parse(b)));
  }
}

class Selection {
  final int id;
  final String label;
  final String? name;
  final double value;
  final String probability;
  final bool suspended;
  final String? total;

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
      total: json["total"]?.toString(),
    );
  }

  double get probabilityValue {
    final cleaned = probability.replaceAll('%', '');
    return double.tryParse(cleaned) ?? 0.0;
  }
}