
class LeagueResponse {
  String status;
  int count;
  List<League> leagues;

  LeagueResponse({
    required this.status,
    required this.count,
    required this.leagues,
  });

  factory LeagueResponse.fromJson(Map<String, dynamic> json) {
    return LeagueResponse(
      status: json['status'],
      count: json['count'],
      leagues: (json['leagues'] as List)
          .map((e) => League.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'count': count,
    'leagues': leagues.map((e) => e.toJson()).toList(),
  };
}

class League {
  int id;
  String name;
  String shortCode;
  String logo;
  bool active;
  String type;
  String subType;
  int category;
  DateTime? lastPlayedAt; // Made optional
  Country country;
  bool isFavorite;
  int? matchCount; // NEW: for date-based API
  List<dynamic>? matches; // NEW: for date-based API
  Map<String, dynamic>? groupedMatches; // NEW: for date-based API

  League({
    required this.id,
    required this.name,
    required this.shortCode,
    required this.logo,
    required this.active,
    required this.type,
    required this.subType,
    required this.category,
    this.lastPlayedAt,
    required this.country,
    this.isFavorite = false,
    this.matchCount,
    this.matches,
    this.groupedMatches,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'],
      name: json['name'],
      shortCode: json['short_code'] ?? '',
      logo: json['logo'] ?? '',
      active: json['active'] ?? true,
      type: json['type'] ?? '',
      subType: json['sub_type'] ?? '',
      category: json['category'] ?? 0,
      // Handle optional lastPlayedAt (exists in old API, not in date-based API)
      lastPlayedAt: json['last_played_at'] != null
          ? DateTime.tryParse(json['last_played_at'])
          : null,
      country: Country.fromJson(json['country'] ?? {}),
      isFavorite: json['is_favorite'] ?? false,
      // NEW fields from date-based API
      matchCount: json['match_count'],
      matches: json['matches'],
      groupedMatches: json['grouped_matches'],
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
    'matches': matches,
    'grouped_matches': groupedMatches,
  };
}

class Country {
  int id;
  String name;
  String code;
  String flag;

  Country({
    required this.id,
    required this.name,
    required this.code,
    required this.flag,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      flag: json['flag'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'flag': flag,
  };
}