import 'dart:convert';

SummaryResponse summaryResponseFromJson(String str) =>
    SummaryResponse.fromJson(json.decode(str));

class SummaryResponse {
  final String status;
  final int fixtureId;
  final String fixtureName;
  final Summary summary;
  final Predictions predictions;

  SummaryResponse({
    required this.status,
    required this.fixtureId,
    required this.fixtureName,
    required this.summary,
    required this.predictions,
  });

  factory SummaryResponse.fromJson(Map<String, dynamic> json) {
    return SummaryResponse(
      status: json["status"],
      fixtureId: json["fixture_id"],
      fixtureName: json["fixture_name"],
      summary: Summary.fromJson(json["summary"]),
      predictions: Predictions.fromJson(json["predictions"]),
    );
  }
}

// ---------------------- SUMMARY -------------------------

class Summary {
  final int id;
  final String name;
  final String startingAt;
  final SummaryStatus status;
  final League league;
  final Team homeTeam;
  final Team awayTeam;
  final Score score;

  Summary({
    required this.id,
    required this.name,
    required this.startingAt,
    required this.status,
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      id: json["id"],
      name: json["name"],
      startingAt: json["starting_at"],
      status: SummaryStatus.fromJson(json["status"]),
      league: League.fromJson(json["league"]),
      homeTeam: Team.fromJson(json["home_team"]),
      awayTeam: Team.fromJson(json["away_team"]),
      score: Score.fromJson(json["score"]),
    );
  }
}

class SummaryStatus {
  final int id;
  final String name;
  final String shortName;
  final bool isLive;
  final int? minute;

  SummaryStatus({
    required this.id,
    required this.name,
    required this.shortName,
    required this.isLive,
    this.minute,
  });

  factory SummaryStatus.fromJson(Map<String, dynamic> json) {
    return SummaryStatus(
      id: json["id"],
      name: json["name"],
      shortName: json["short_name"],
      isLive: json["is_live"],
      minute: json["minute"],
    );
  }
}

// ---------------------- LEAGUE --------------------------

class League {
  final int id;
  final String name;
  final String logo;

  League({required this.id, required this.name, required this.logo});

  factory League.fromJson(Map<String, dynamic> json) => League(
    id: json["id"],
    name: json["name"],
    logo: json["logo"],
  );
}

// ---------------------- TEAM + EVENTS -------------------

class Team {
  final int id;
  final String name;
  final String logo;
  final TeamScores scores;
  final List<Event> events;

  Team({
    required this.id,
    required this.name,
    required this.logo,
    required this.scores,
    required this.events,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json["id"],
      name: json["name"],
      logo: json["logo"],
      scores: TeamScores.fromJson(json["scores"]),
      events: json["events"] != null
          ? (json["events"] as List).map((e) => Event.fromJson(e)).toList()
          : [],
    );
  }
}

class TeamScores {
  final int? current;
  final int? halftime;
  final int? fulltime;

  TeamScores({this.current, this.halftime, this.fulltime});

  factory TeamScores.fromJson(Map<String, dynamic> json) {
    return TeamScores(
      current: json["current"],
      halftime: json["halftime"],
      fulltime: json["fulltime"],
    );
  }
}

class Event {
  final int id;
  final int minute;
  final int? extraMinute;
  final EventType type;
  final String team;
  final Player? player; // nullable
  final String? period;

  Event({
    required this.id,
    required this.minute,
    this.extraMinute,
    required this.type,
    required this.team,
    this.player,
    this.period,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json["id"],
      minute: json["minute"],
      extraMinute: json["extra_minute"],
      type: EventType.fromJson(json["type"]),
      team: json["team"],
      player: json["player"] != null ? Player.fromJson(json["player"]) : null,
      period: json["period"],
    );
  }
}

class EventType {
  final String name;
  final String? code;

  EventType({required this.name, this.code});

  factory EventType.fromJson(Map<String, dynamic> json) {
    return EventType(
      name: json["name"],
      code: json["code"],
    );
  }
}

class Player {
  final int id;
  final String name;

  Player({required this.id, required this.name});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json["id"],
      name: json["name"],
    );
  }
}

// ---------------------- SCORE ---------------------------

class Score {
  final ScoreItem current;
  final ScoreItem? halftime;
  final ScoreItem? fulltime;

  Score({required this.current, this.halftime, this.fulltime});

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      current: ScoreItem.fromJson(json["current"]),
      halftime: json["halftime"] != null
          ? ScoreItem.fromJson(json["halftime"])
          : null,
      fulltime:
      json["fulltime"] != null ? ScoreItem.fromJson(json["fulltime"]) : null,
    );
  }
}

class ScoreItem {
  final int? home;
  final int? away;
  final String? display;

  ScoreItem({this.home, this.away, this.display});

  factory ScoreItem.fromJson(Map<String, dynamic> json) {
    return ScoreItem(
      home: json["home"],
      away: json["away"],
      display: json["display"],
    );
  }
}

// ---------------------- PREDICTIONS ----------------------

class Predictions {
  final FullTimeResult fulltimeResult;
  final CorrectScores correctScores;

  Predictions({
    required this.fulltimeResult,
    required this.correctScores,
  });

  factory Predictions.fromJson(Map<String, dynamic> json) {
    return Predictions(
      fulltimeResult: FullTimeResult.fromJson(json["fulltime_result"]),
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
  final Map<String, double> all;
  final List<TopScore> top5;

  CorrectScores({required this.all, required this.top5});

  factory CorrectScores.fromJson(Map<String, dynamic> json) {
    return CorrectScores(
      all: Map<String, double>.from(
          (json["all"] as Map).map((k, v) => MapEntry(k, (v as num).toDouble()))),
      top5: (json["top_5"] as List)
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
