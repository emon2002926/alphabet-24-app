class NewsResponse {
  String status;
  List<NewsItem> news;

  NewsResponse({
    required this.status,
    required this.news,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) => NewsResponse(
    status: json['status'],
    news: (json['news'] as List)
        .map((item) => NewsItem.fromJson(item))
        .toList(),
  );
}

class NewsItem {
  int id;
  String title;
  String type;
  DateTime matchDate;
  List<NewsLine> lines;
  League league;

  NewsItem({
    required this.id,
    required this.title,
    required this.type,
    required this.matchDate,
    required this.lines,
    required this.league,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) => NewsItem(
    id: json['id'],
    title: json['title'],
    type: json['type'],
    matchDate: DateTime.parse(json['match_date']),
    lines: (json['lines'] as List)
        .map((line) => NewsLine.fromJson(line))
        .toList(),
    league: League.fromJson(json['league']),
  );
}

class NewsLine {
  int id;
  String text;

  NewsLine({
    required this.id,
    required this.text,
  });

  factory NewsLine.fromJson(Map<String, dynamic> json) => NewsLine(
    id: json['id'],
    text: json['text'],
  );
}

class League {
  int id;
  String logo;

  League({
    required this.id,
    required this.logo,
  });

  factory League.fromJson(Map<String, dynamic> json) => League(
    id: json['id'],
    logo: json['logo'] ?? "",
  );
}
