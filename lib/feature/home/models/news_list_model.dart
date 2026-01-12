import 'dart:convert';

NewsResponse newsResponseFromJson(String str) =>
    NewsResponse.fromJson(json.decode(str));

class NewsResponse {
  final String status;
  final List<NewsItem> news;
  final int count;
  final String? source;
  final String? note;
  final String? message;

  NewsResponse({
    required this.status,
    required this.news,
    this.count = 0,
    this.source,
    this.note,
    this.message,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) => NewsResponse(
    status: json['status'] ?? '',
    news: (json['news'] as List? ?? [])
        .map((item) => NewsItem.fromJson(item))
        .toList(),
    count: json['count'] ?? 0,
    source: json['source'],
    note: json['note'],
    message: json['message'],
  );
}

class NewsItem {
  final int id;
  final int fixtureId;
  final int leagueId;
  final String title;
  final String type;
  final List<NewsLine> lines;
  final NewsFixture fixture;
  final NewsLeague league;
  final NewsTeam homeTeam;
  final NewsTeam awayTeam;
  final NewsVenue? venue;

  NewsItem({
    required this.id,
    required this.fixtureId,
    required this.leagueId,
    required this.title,
    required this.type,
    required this.lines,
    required this.fixture,
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
    this.venue,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) => NewsItem(
    id: json['id'] ?? 0,
    fixtureId: json['fixture_id'] ?? 0,
    leagueId: json['league_id'] ?? 0,
    title: json['title'] ?? '',
    type: json['type'] ?? '',
    lines: (json['lines'] as List? ?? [])
        .map((line) => NewsLine.fromJson(line))
        .toList(),
    fixture: NewsFixture.fromJson(json['fixture'] ?? {}),
    league: NewsLeague.fromJson(json['league'] ?? {}),
    homeTeam: NewsTeam.fromJson(json['home_team'] ?? {}),
    awayTeam: NewsTeam.fromJson(json['away_team'] ?? {}),
    venue: json['venue'] != null ? NewsVenue.fromJson(json['venue']) : null,
  );

  // Helper getters
  DateTime get matchDate => fixture.startingAt;
  String get matchName => fixture.name;
  String get matchState => fixture.state;
  String get resultInfo => fixture.resultInfo;
}

class NewsLine {
  final int id;
  final int newsitemId;
  final String text;
  final String type;

  NewsLine({
    required this.id,
    required this.newsitemId,
    required this.text,
    required this.type,
  });

  factory NewsLine.fromJson(Map<String, dynamic> json) => NewsLine(
    id: json['id'] ?? 0,
    newsitemId: json['newsitem_id'] ?? 0,
    text: json['text'] ?? '',
    type: json['type'] ?? '',
  );

  // Helper to check line type
  bool get isHome => type == 'home';
  bool get isAway => type == 'away';
  bool get isIntroduction => type == 'introduction';
}

class NewsFixture {
  final int id;
  final String name;
  final DateTime startingAt;
  final String state;
  final String resultInfo;

  NewsFixture({
    required this.id,
    required this.name,
    required this.startingAt,
    required this.state,
    required this.resultInfo,
  });

  factory NewsFixture.fromJson(Map<String, dynamic> json) => NewsFixture(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    startingAt: DateTime.tryParse(json['starting_at'] ?? '') ?? DateTime.now(),
    state: json['state'] ?? '',
    resultInfo: json['result_info'] ?? '',
  );
}

class NewsLeague {
  final int id;
  final String name;
  final String logo;
  final String? country;

  NewsLeague({
    required this.id,
    required this.name,
    required this.logo,
    this.country,
  });

  factory NewsLeague.fromJson(Map<String, dynamic> json) => NewsLeague(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    logo: json['logo'] ?? '',
    country: json['country'],
  );
}

class NewsTeam {
  final int id;
  final String name;
  final String? shortCode;
  final String logo;
  final int score;

  NewsTeam({
    required this.id,
    required this.name,
    this.shortCode,
    required this.logo,
    required this.score,
  });

  factory NewsTeam.fromJson(Map<String, dynamic> json) => NewsTeam(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    shortCode: json['short_code'],
    logo: json['logo'] ?? '',
    score: json['score'] ?? 0,
  );
}

class NewsVenue {
  final String? name;
  final String? city;

  NewsVenue({
    this.name,
    this.city,
  });

  factory NewsVenue.fromJson(Map<String, dynamic> json) => NewsVenue(
    name: json['name'],
    city: json['city'],
  );
}