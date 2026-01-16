/// Main League model class for date-based API
class LeagueByDateResponse {
  String status;
  String date;
  int totalLeagues;
  int totalMatches;
  List<LeaguePrimary> leagues;

  LeagueByDateResponse({
    required this.status,
    required this.date,
    required this.totalLeagues,
    required this.totalMatches,
    required this.leagues,
  });

  factory LeagueByDateResponse.fromJson(Map<String, dynamic> json) {
    return LeagueByDateResponse(
      status: json['status'] ?? '',
      date: json['date'] ?? '',
      totalLeagues: json['total_leagues'] ?? 0,
      totalMatches: json['total_matches'] ?? 0,
      leagues: (json['leagues'] as List?)
          ?.map((e) => LeaguePrimary.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'date': date,
    'total_leagues': totalLeagues,
    'total_matches': totalMatches,
    'leagues': leagues.map((e) => e.toJson()).toList(),
  };
}

class LeaguePrimary {
  int id;
  String name;
  String? shortCode;
  String logo;
  bool active;
  String type;
  String subType;
  int category;
  DateTime? lastPlayedAt;
  Country country;
  bool isFavorite;
  int? matchCount;
  List<Match>? matches;
  Map<String, List<Match>>? groupedMatches;

  LeaguePrimary({
    required this.id,
    required this.name,
    this.shortCode,
    required this.logo,
    this.active = true,
    required this.type,
    this.subType = '',
    this.category = 0,
    this.lastPlayedAt,
    required this.country,
    this.isFavorite = false,
    this.matchCount,
    this.matches,
    this.groupedMatches,
  });

  factory LeaguePrimary.fromJson(Map<String, dynamic> json) {
    return LeaguePrimary(
      id: json['id'],
      name: json['name'] ?? '',
      shortCode: json['short_code'],
      logo: json['logo'] ?? '',
      active: json['active'] ?? true,
      type: json['type'] ?? '',
      subType: json['sub_type'] ?? '',
      category: json['category'] ?? 0,
      lastPlayedAt: json['last_played_at'] != null
          ? DateTime.tryParse(json['last_played_at'])
          : null,
      country: Country.fromJson(json['country'] ?? {}),
      isFavorite: json['is_favorite'] ?? false,
      matchCount: json['match_count'],
      matches: (json['matches'] as List?)
          ?.map((e) => Match.fromJson(e))
          .toList(),
      groupedMatches: (json['grouped_matches'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
          key,
          (value as List).map((e) => Match.fromJson(e)).toList(),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'short_code': shortCode,
    'logo': logo,
    'active': active,
    'type': type,
    'sub_type': subType,
    'category': category,
    'last_played_at': lastPlayedAt?.toIso8601String(),
    'country': country.toJson(),
    'is_favorite': isFavorite,
    'match_count': matchCount,
    'matches': matches?.map((e) => e.toJson()).toList(),
    'grouped_matches': groupedMatches?.map(
          (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()),
    ),
  };
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
      name: json['name'] ?? '',
      code: json['code'],
      flag: json['flag'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'flag': flag,
  };
}

class Match {
  int id;
  String name;
  String startingAt;
  MatchStatus status;
  Team homeTeam;
  Team awayTeam;
  Score score;
  bool isFavorite;
  Round? round;
  Stage? stage;
  Group? group;
  Venue? venue;

  Match({
    required this.id,
    required this.name,
    required this.startingAt,
    required this.status,
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
    required this.isFavorite,
    this.round,
    this.stage,
    this.group,
    this.venue,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      name: json['name'] ?? '',
      startingAt: json['starting_at'] ?? '',
      status: MatchStatus.fromJson(json['status'] ?? {}),
      homeTeam: Team.fromJson(json['home_team'] ?? {}),
      awayTeam: Team.fromJson(json['away_team'] ?? {}),
      score: Score.fromJson(json['score'] ?? {}),
      isFavorite: json['is_favorite'] ?? false,
      round: json['round'] != null ? Round.fromJson(json['round']) : null,
      stage: json['stage'] != null ? Stage.fromJson(json['stage']) : null,
      group: json['group'] != null ? Group.fromJson(json['group']) : null,
      venue: json['venue'] != null ? Venue.fromJson(json['venue']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'starting_at': startingAt,
    'status': status.toJson(),
    'is_favorite': isFavorite,
    'home_team': homeTeam.toJson(),
    'away_team': awayTeam.toJson(),
    'score': score.toJson(),
    'round': round?.toJson(),
    'stage': stage?.toJson(),
    'group': group?.toJson(),
    'venue': venue?.toJson(),
  };
}

class MatchStatus {
  bool isLive;
  bool isFinished;
  bool isUpcoming;
  int stateId;
  String stateName;
  String stateShort;

  MatchStatus({
    required this.isLive,
    required this.isFinished,
    required this.isUpcoming,
    required this.stateId,
    required this.stateName,
    required this.stateShort,
  });

  factory MatchStatus.fromJson(Map<String, dynamic> json) {
    return MatchStatus(
      isLive: json['is_live'] ?? false,
      isFinished: json['is_finished'] ?? false,
      isUpcoming: json['is_upcoming'] ?? false,
      stateId: json['state_id'] ?? 0,
      stateName: json['state_name'] ?? '',
      stateShort: json['state_short'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'is_live': isLive,
    'is_finished': isFinished,
    'is_upcoming': isUpcoming,
    'state_id': stateId,
    'state_name': stateName,
    'state_short': stateShort,
  };
}

class Team {
  int id;
  String name;
  String? shortCode;
  String logo;
  String location;
  int? score;

  Team({
    required this.id,
    required this.name,
    this.shortCode,
    required this.logo,
    required this.location,
    this.score,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      shortCode: json['short_code'],
      logo: json['logo'] ?? '',
      location: json['location'] ?? '',
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'short_code': shortCode,
    'logo': logo,
    'location': location,
    'score': score,
  };
}

class Score {
  int? home;
  int? away;
  String display;

  Score({
    this.home,
    this.away,
    required this.display,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      home: json['home'],
      away: json['away'],
      display: json['display'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'home': home,
    'away': away,
    'display': display,
  };
}

class Round {
  int id;
  String name;

  Round({required this.id, required this.name});

  factory Round.fromJson(Map<String, dynamic> json) {
    return Round(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class Stage {
  int id;
  String name;

  Stage({required this.id, required this.name});

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class Group {
  int id;
  String name;

  Group({required this.id, required this.name});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class Venue {
  int id;
  String name;
  String? city;

  Venue({required this.id, required this.name, this.city});

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'city': city};
}