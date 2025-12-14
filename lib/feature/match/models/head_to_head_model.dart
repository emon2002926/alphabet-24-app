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
      status: json["status"],
      fixtureId: json["fixture_id"],
      fixtureName: json["fixture_name"],
      data: H2HData.fromJson(json["data"]),
    );
  }
}

class H2HData {
  final Fixture fixture;
  final League league;
  final Team homeTeam;
  final Team awayTeam;
  final List<dynamic> matches;

  H2HData({
    required this.fixture,
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
    required this.matches,
  });

  factory H2HData.fromJson(Map<String, dynamic> json) {
    return H2HData(
      fixture: Fixture.fromJson(json["fixture"]),
      league: League.fromJson(json["league"]),
      homeTeam: Team.fromJson(json["home_team"]),
      awayTeam: Team.fromJson(json["away_team"]),
      matches: json["matches"] ?? [],
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
      id: json["id"],
      name: json["name"],
      startingAt: json["starting_at"],
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

  Team({
    required this.id,
    required this.name,
    required this.shortCode,
    required this.logo,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json["id"],
      name: json["name"],
      shortCode: json["short_code"],
      logo: json["logo"],
    );
  }
}
