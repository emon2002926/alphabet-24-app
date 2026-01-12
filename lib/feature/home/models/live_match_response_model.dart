class LiveMatchResponse {
  String status;
  int count;
  int favoriteMatchesCount;
  int otherMatchesCount;
  List<LiveMatch> matches;
  bool isAuthenticated;
  FavoritesCount favoritesCount;
  DateTime timestamp;

  LiveMatchResponse({
    required this.status,
    required this.count,
    required this.favoriteMatchesCount,
    required this.otherMatchesCount,
    required this.matches,
    required this.isAuthenticated,
    required this.favoritesCount,
    required this.timestamp,
  });

  factory LiveMatchResponse.fromJson(Map<String, dynamic> json) {
    return LiveMatchResponse(
      status: json['status'] ?? "",
      count: json['count'] ?? 0,
      favoriteMatchesCount: json['favorite_matches_count'] ?? 0,
      otherMatchesCount: json['other_matches_count'] ?? 0,
      matches: (json['matches'] as List? ?? [])
          .map((e) => LiveMatch.fromJson(e))
          .toList(),
      isAuthenticated: json['is_authenticated'] ?? false,
      favoritesCount: FavoritesCount.fromJson(json['favorites_count'] ?? {}),
      timestamp: DateTime.tryParse(json['timestamp'] ?? "") ?? DateTime.now(),
    );
  }
}

// ================== LIVE MATCH ==================
class LiveMatch {
  int id;
  String name;
  DateTime startingAt;
  MatchStatus status;
  bool isFavoriteMatch;
  List<dynamic> matchReason;
  League league;
  Round round;
  Team homeTeam;
  Team awayTeam;
  MatchScore score;
  List<Period> periods;
  List<Event> events;
  Venue? venue;
  Predictions predictions;

  LiveMatch({
    required this.id,
    required this.name,
    required this.startingAt,
    required this.status,
    required this.isFavoriteMatch,
    required this.matchReason,
    required this.league,
    required this.round,
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
    required this.periods,
    required this.events,
    required this.venue,
    required this.predictions,
  });

  factory LiveMatch.fromJson(Map<String, dynamic> json) {
    return LiveMatch(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      startingAt: DateTime.tryParse(json['starting_at'] ?? "") ?? DateTime.now(),
      status: MatchStatus.fromJson(json['status'] ?? {}),
      isFavoriteMatch: json['is_favorite_match'] ?? false,
      matchReason: json['match_reason'] ?? [],
      league: League.fromJson(json['league'] ?? {}),
      round: Round.fromJson(json['round'] ?? {}),
      homeTeam: Team.fromJson(json['home_team'] ?? {}),
      awayTeam: Team.fromJson(json['away_team'] ?? {}),
      score: MatchScore.fromJson(json['score'] ?? {}),
      periods: (json['periods'] as List? ?? [])
          .map((e) => Period.fromJson(e))
          .toList(),
      events: (json['events'] as List? ?? [])
          .map((e) => Event.fromJson(e))
          .toList(),
      venue: json['venue'] != null ? Venue.fromJson(json['venue']) : null,
      predictions: Predictions.fromJson(json['predictions'] ?? {}),
    );
  }
}

// ================== SUB MODELS ==================

class MatchStatus {
  bool isLive;
  int? minute;
  String state;
  String stateShort;
  int stateId;

  MatchStatus({
    required this.isLive,
    required this.minute,
    required this.state,
    required this.stateShort,
    required this.stateId,
  });

  factory MatchStatus.fromJson(Map<String, dynamic> json) {
    return MatchStatus(
      isLive: json['is_live'] ?? false,
      minute: json['minute'],
      state: json['state'] ?? "",
      stateShort: json['state_short'] ?? "",
      stateId: json['state_id'] ?? 0,
    );
  }
}

class League {
  int id;
  String name;
  String logo;
  bool isFavorite;
  Country country;

  League({
    required this.id,
    required this.name,
    required this.logo,
    required this.isFavorite,
    required this.country,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      logo: json['logo'] ?? "",
      isFavorite: json['is_favorite'] ?? false,
      country: Country.fromJson(json['country'] ?? {}),
    );
  }
}

class Country {
  int id;
  String name;
  String? code;
  String? flag;

  Country({
    required this.id,
    required this.name,
    this.code,
    this.flag,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      code: json['code'],
      flag: json['flag'],
    );
  }
}

class Round {
  int id;
  String name;
  DateTime startingAt;
  DateTime endingAt;

  Round({
    required this.id,
    required this.name,
    required this.startingAt,
    required this.endingAt,
  });

  factory Round.fromJson(Map<String, dynamic> json) {
    return Round(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      startingAt: DateTime.tryParse(json['starting_at'] ?? "") ?? DateTime.now(),
      endingAt: DateTime.tryParse(json['ending_at'] ?? "") ?? DateTime.now(),
    );
  }
}

class Team {
  int id;
  String name;
  String? shortCode;
  String logo;
  String location;
  int score;
  bool isFavorite;
  Statistics? statistics;
  List<Event>? events;

  Team({
    required this.id,
    required this.name,
    required this.shortCode,
    required this.logo,
    required this.location,
    required this.score,
    required this.isFavorite,
    required this.statistics,
    required this.events,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      shortCode: json['short_code'],
      logo: json['logo'] ?? "",
      location: json['location'] ?? "",
      score: json['score'] ?? 0,
      isFavorite: json['is_favorite'] ?? false,
      statistics: json['statistics'] != null
          ? Statistics.fromJson(json['statistics'])
          : null,
      events: (json['events'] as List? ?? [])
          .map((e) => Event.fromJson(e))
          .toList(),
    );
  }
}

class Statistics {
  int value;

  Statistics({required this.value});

  factory Statistics.fromJson(Map<String, dynamic> json) =>
      Statistics(value: json['value'] ?? 0);
}

class Event {
  int id;
  String type;
  int minute;
  int? extraMinute;
  int participantId;
  String playerName;
  String? relatedPlayerName;
  String? result;

  Event({
    required this.id,
    required this.type,
    required this.minute,
    this.extraMinute,
    required this.participantId,
    required this.playerName,
    this.relatedPlayerName,
    this.result,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      type: json['type'] ?? "",
      minute: json['minute'] ?? 0,
      extraMinute: json['extra_minute'],
      participantId: json['participant_id'] ?? 0,
      playerName: json['player_name'] ?? "",
      relatedPlayerName: json['related_player_name'],
      result: json['result'],
    );
  }
}

class MatchScore {
  int home;
  int away;
  String display;

  MatchScore({
    required this.home,
    required this.away,
    required this.display,
  });

  factory MatchScore.fromJson(Map<String, dynamic> json) {
    return MatchScore(
      home: json['home'] ?? 0,
      away: json['away'] ?? 0,
      display: json['display'] ?? "",
    );
  }
}

class Period {
  int id;
  int typeId;
  String description;
  int started;
  int? ended;
  bool ticking;
  int minutes;
  int seconds;
  int? timeAdded;

  Period({
    required this.id,
    required this.typeId,
    required this.description,
    required this.started,
    this.ended,
    required this.ticking,
    required this.minutes,
    required this.seconds,
    this.timeAdded,
  });

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      id: json['id'] ?? 0,
      typeId: json['type_id'] ?? 0,
      description: json['description'] ?? "",
      started: json['started'] ?? 0,
      ended: json['ended'],
      ticking: json['ticking'] ?? false,
      minutes: json['minutes'] ?? 0,
      seconds: json['seconds'] ?? 0,
      timeAdded: json['time_added'],
    );
  }
}

class Venue {
  int id;
  String name;
  String city;
  int capacity;
  String? image;

  Venue({
    required this.id,
    required this.name,
    required this.city,
    required this.capacity,
    this.image,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      city: json['city'] ?? "",
      capacity: json['capacity'] ?? 0,
      image: json['image'],
    );
  }
}

// ================== PREDICTIONS ==================

class Predictions {
  FulltimeResult fulltimeResult;
  CorrectScores correctScores;
  BothTeamsToScore bothTeamsToScore;
  OverUnder overUnder25;
  DoubleChance doubleChance;

  Predictions({
    required this.fulltimeResult,
    required this.correctScores,
    required this.bothTeamsToScore,
    required this.overUnder25,
    required this.doubleChance,
  });

  factory Predictions.fromJson(Map<String, dynamic> json) {
    return Predictions(
      fulltimeResult: FulltimeResult.fromJson(json['fulltime_result'] ?? {}),
      correctScores: CorrectScores.fromJson(json['correct_scores'] ?? {}),
      bothTeamsToScore: BothTeamsToScore.fromJson(json['both_teams_to_score'] ?? {}),
      overUnder25: OverUnder.fromJson(json['over_under_2_5'] ?? {}),
      doubleChance: DoubleChance.fromJson(json['double_chance'] ?? {}),
    );
  }
}

class FulltimeResult {
  double homeWin;
  double draw;
  double awayWin;

  FulltimeResult({
    required this.homeWin,
    required this.draw,
    required this.awayWin,
  });

  factory FulltimeResult.fromJson(Map<String, dynamic> json) {
    return FulltimeResult(
      homeWin: (json['home_win'] ?? 0).toDouble(),
      draw: (json['draw'] ?? 0).toDouble(),
      awayWin: (json['away_win'] ?? 0).toDouble(),
    );
  }
}

class CorrectScores {
  Map<String, double> all;
  List<TopScore> top5;

  CorrectScores({
    required this.all,
    required this.top5,
  });

  factory CorrectScores.fromJson(Map<String, dynamic> json) {
    return CorrectScores(
      all: (json['all'] as Map? ?? {})
          .map((k, v) => MapEntry(k, (v as num).toDouble())),
      top5: (json['top_5'] as List? ?? [])
          .map((e) => TopScore.fromJson(e))
          .toList(),
    );
  }
}

class TopScore {
  String score;
  double probability;

  TopScore({required this.score, required this.probability});

  factory TopScore.fromJson(Map<String, dynamic> json) {
    return TopScore(
      score: json['score'] ?? "",
      probability: (json['probability'] ?? 0).toDouble(),
    );
  }
}

class BothTeamsToScore {
  double yes;
  double no;

  BothTeamsToScore({required this.yes, required this.no});

  factory BothTeamsToScore.fromJson(Map<String, dynamic> json) {
    return BothTeamsToScore(
      yes: (json['yes'] ?? 0).toDouble(),
      no: (json['no'] ?? 0).toDouble(),
    );
  }
}

class OverUnder {
  double over;
  double under;

  OverUnder({required this.over, required this.under});

  factory OverUnder.fromJson(Map<String, dynamic> json) {
    return OverUnder(
      over: (json['over'] ?? 0).toDouble(),
      under: (json['under'] ?? 0).toDouble(),
    );
  }
}

class DoubleChance {
  double homeOrDraw;
  double awayOrDraw;
  double homeOrAway;

  DoubleChance({
    required this.homeOrDraw,
    required this.awayOrDraw,
    required this.homeOrAway,
  });

  factory DoubleChance.fromJson(Map<String, dynamic> json) {
    return DoubleChance(
      homeOrDraw: (json['home_or_draw'] ?? 0).toDouble(),
      awayOrDraw: (json['away_or_draw'] ?? 0).toDouble(),
      homeOrAway: (json['home_or_away'] ?? 0).toDouble(),
    );
  }
}

// ================== FAVOURITES ==================

class FavoritesCount {
  int teams;
  int leagues;

  FavoritesCount({required this.teams, required this.leagues});

  factory FavoritesCount.fromJson(Map<String, dynamic> json) =>
      FavoritesCount(
        teams: json['teams'] ?? 0,
        leagues: json['leagues'] ?? 0,
      );
}

class FavouriteResponse {
  final List<dynamic> teams;
  final List<FavouriteLeague> leagues;
  final List<FavouriteFixture> fixtures;
  final int total;

  FavouriteResponse({
    required this.teams,
    required this.leagues,
    required this.fixtures,
    required this.total,
  });

  factory FavouriteResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final favorites = data['favorites'] ?? {};

    return FavouriteResponse(
      teams: favorites['teams'] ?? [],
      leagues: (favorites['leagues'] as List? ?? [])
          .map((e) => FavouriteLeague.fromJson(e))
          .toList(),
      fixtures: (favorites['fixtures'] as List? ?? [])
          .map((e) => FavouriteFixture.fromJson(e))
          .toList(),
      total: data['total'] ?? 0,
    );
  }
}

class FavouriteLeague {
  final int id;
  final int leagueId;
  final String leagueName;
  final String leagueLogo;
  final String leagueCountry;
  final String leagueType;
  final DateTime createdAt;
  final bool hasMatchesToday;
  final int matchesTodayCount;
  final List<dynamic> matches; // Dynamic list to handle match objects

  FavouriteLeague({
    required this.id,
    required this.leagueId,
    required this.leagueName,
    required this.leagueLogo,
    required this.leagueCountry,
    required this.leagueType,
    required this.createdAt,
    required this.hasMatchesToday,
    required this.matchesTodayCount,
    required this.matches,
  });

  factory FavouriteLeague.fromJson(Map<String, dynamic> json) {
    return FavouriteLeague(
      id: json['id'] ?? 0,
      leagueId: json['league_id'] ?? 0,
      leagueName: json['league_name'] ?? '',
      leagueLogo: json['league_logo'] ?? '',
      leagueCountry: json['league_country'] ?? '',
      leagueType: json['league_type'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      hasMatchesToday: json['has_matches_today'] ?? false,
      matchesTodayCount: json['matches_today_count'] ?? 0,
      matches: json['matches'] ?? [],
    );
  }
}

class FavouriteFixture {
  final int id;
  final String name;
  final DateTime startingAt;
  final bool isLive;
  final int? minute;
  final String state;
  final String stateShort;
  final int stateId;
  final FavouriteFixtureLeague league;
  final FavouriteFixtureRound? round;
  final FavouriteFixtureTeam homeTeam;
  final FavouriteFixtureTeam awayTeam;
  final FavouriteFixtureVenue? venue;
  final bool isFavorite;
  final int? favoriteId;
  final DateTime? favoritedAt;
  final Predictions? predictions;
  final dynamic odds;
  final Map<String, dynamic>? statistics;

  FavouriteFixture({
    required this.id,
    required this.name,
    required this.startingAt,
    required this.isLive,
    this.minute,
    required this.state,
    required this.stateShort,
    required this.stateId,
    required this.league,
    this.round,
    required this.homeTeam,
    required this.awayTeam,
    this.venue,
    required this.isFavorite,
    this.favoriteId,
    this.favoritedAt,
    this.predictions,
    this.odds,
    this.statistics,
  });

  factory FavouriteFixture.fromJson(Map<String, dynamic> json) {
    return FavouriteFixture(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      startingAt: DateTime.tryParse(json['starting_at'] ?? '') ?? DateTime.now(),
      isLive: json['is_live'] ?? false,
      minute: json['minute'],
      state: json['state'] ?? '',
      stateShort: json['state_short'] ?? '',
      stateId: json['state_id'] ?? 0,
      league: FavouriteFixtureLeague.fromJson(json['league'] ?? {}),
      round: json['round'] != null ? FavouriteFixtureRound.fromJson(json['round']) : null,
      homeTeam: FavouriteFixtureTeam.fromJson(json['home_team'] ?? {}),
      awayTeam: FavouriteFixtureTeam.fromJson(json['away_team'] ?? {}),
      venue: json['venue'] != null ? FavouriteFixtureVenue.fromJson(json['venue']) : null,
      isFavorite: json['is_favorite'] ?? false,
      favoriteId: json['favorite_id'],
      favoritedAt: DateTime.tryParse(json['favorited_at'] ?? ''),
      predictions: json['predictions'] != null ? Predictions.fromJson(json['predictions']) : null,
      odds: json['odds'],
      statistics: json['statistics'],
    );
  }
}

class FavouriteFixtureLeague {
  final int id;
  final String name;
  final String logo;
  final FavouriteFixtureCountry country;

  FavouriteFixtureLeague({
    required this.id,
    required this.name,
    required this.logo,
    required this.country,
  });

  factory FavouriteFixtureLeague.fromJson(Map<String, dynamic> json) {
    return FavouriteFixtureLeague(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      country: FavouriteFixtureCountry.fromJson(json['country'] ?? {}),
    );
  }
}

class FavouriteFixtureCountry {
  final int id;
  final String name;
  final String? code;
  final String? flag;

  FavouriteFixtureCountry({
    required this.id,
    required this.name,
    this.code,
    this.flag,
  });

  factory FavouriteFixtureCountry.fromJson(Map<String, dynamic> json) {
    return FavouriteFixtureCountry(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'],
      flag: json['flag'],
    );
  }
}

class FavouriteFixtureRound {
  final int id;
  final String name;
  final DateTime startingAt;
  final DateTime endingAt;

  FavouriteFixtureRound({
    required this.id,
    required this.name,
    required this.startingAt,
    required this.endingAt,
  });

  factory FavouriteFixtureRound.fromJson(Map<String, dynamic> json) {
    return FavouriteFixtureRound(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      startingAt: DateTime.tryParse(json['starting_at'] ?? '') ?? DateTime.now(),
      endingAt: DateTime.tryParse(json['ending_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class FavouriteFixtureTeam {
  final int id;
  final String name;
  final String? shortCode;
  final String logo;
  final int? score;

  FavouriteFixtureTeam({
    required this.id,
    required this.name,
    this.shortCode,
    required this.logo,
    this.score,
  });

  factory FavouriteFixtureTeam.fromJson(Map<String, dynamic> json) {
    return FavouriteFixtureTeam(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      shortCode: json['short_code'],
      logo: json['logo'] ?? '',
      score: json['score'],
    );
  }
}

class FavouriteFixtureVenue {
  final int id;
  final String name;
  final String city;
  final int capacity;

  FavouriteFixtureVenue({
    required this.id,
    required this.name,
    required this.city,
    required this.capacity,
  });

  factory FavouriteFixtureVenue.fromJson(Map<String, dynamic> json) {
    return FavouriteFixtureVenue(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      capacity: json['capacity'] ?? 0,
    );
  }
}