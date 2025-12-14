
class MatchLineup {
  final int fixtureId;
  final String fixtureName;
  final Fixture fixture;
  final League league;
  final StateInfo state;
  final Team homeTeam;
  final Team awayTeam;
  final Summary summary;

  MatchLineup({
    required this.fixtureId,
    required this.fixtureName,
    required this.fixture,
    required this.league,
    required this.state,
    required this.homeTeam,
    required this.awayTeam,
    required this.summary,
  });

  factory MatchLineup.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return MatchLineup(
      fixtureId: json['fixture_id'] ?? 0,
      fixtureName: json['fixture_name'] ?? '',
      fixture: Fixture.fromJson(data['fixture'] ?? {}),
      league: League.fromJson(data['league'] ?? {}),
      state: StateInfo.fromJson(data['state'] ?? {}),
      homeTeam: Team.fromJson(data['home_team'] ?? {}),
      awayTeam: Team.fromJson(data['away_team'] ?? {}),
      summary: Summary.fromJson(data['summary'] ?? {}),
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
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      startingAt: json['starting_at'] ?? '',
    );
  }
}

class League {
  final int id;
  final String name;
  final String? logo;

  League({required this.id, required this.name, this.logo});

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      logo: json['logo'],
    );
  }
}

class StateInfo {
  final int id;
  final String name;
  final String shortName;

  StateInfo({required this.id, required this.name, required this.shortName});

  factory StateInfo.fromJson(Map<String, dynamic> json) {
    return StateInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      shortName: json['short_name'] ?? '',
    );
  }
}

class Team {
  final int id;
  final String name;
  final String? shortCode;
  final String logo;
  final String location;
  final String formation;
  final Coach? coach;
  final List<Player> startingXi;
  final List<Player> substitutes;

  Team({
    required this.id,
    required this.name,
    this.shortCode,
    required this.logo,
    required this.location,
    required this.formation,
    this.coach,
    required this.startingXi,
    required this.substitutes,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      shortCode: json['short_code'],
      logo: json['logo'] ?? '',
      location: json['location'] ?? '',
      formation: json['formation'] ?? '',
      coach: json['coach'] != null ? Coach.fromJson(json['coach']) : null,
      startingXi: (json['starting_xi'] as List? ?? [])
          .map((e) => Player.fromJson(e))
          .toList(),
      substitutes: (json['substitutes'] as List? ?? [])
          .map((e) => Player.fromJson(e))
          .toList(),
    );
  }
}

class Coach {
  final int id;
  final String name;
  final String? image;

  Coach({required this.id, required this.name, this.image});

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'],
    );
  }
}

class Player {
  final int id;
  final String name;
  final int jerseyNumber;
  final String position;
  final int positionId;
  final String? specificPosition;
  final GridPosition? gridPosition;
  final bool isStartingXi;
  final String? image;

  Player({
    required this.id,
    required this.name,
    required this.jerseyNumber,
    required this.position,
    required this.positionId,
    this.specificPosition,
    this.gridPosition,
    required this.isStartingXi,
    this.image,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      jerseyNumber: json['jersey_number'] ?? 0,
      position: json['position'] ?? '',
      positionId: json['position_id'] ?? 0,
      specificPosition: json['specific_position'],
      gridPosition: json['grid_position'] != null
          ? GridPosition.fromJson(json['grid_position'])
          : null,
      isStartingXi: json['is_starting_xi'] ?? false,
      image: json['image'],
    );
  }
}

class GridPosition {
  final int line;
  final int position;

  GridPosition({required this.line, required this.position});

  factory GridPosition.fromJson(Map<String, dynamic> json) {
    return GridPosition(
      line: json['line'] ?? 0,
      position: json['position'] ?? 0,
    );
  }
}

class Summary {
  final String homeFormation;
  final String awayFormation;
  final int totalHomePlayers;
  final int totalAwayPlayers;
  final int homeStartingCount;
  final int awayStartingCount;
  final int homeSubsCount;
  final int awaySubsCount;

  Summary({
    required this.homeFormation,
    required this.awayFormation,
    required this.totalHomePlayers,
    required this.totalAwayPlayers,
    required this.homeStartingCount,
    required this.awayStartingCount,
    required this.homeSubsCount,
    required this.awaySubsCount,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      homeFormation: json['home_formation'] ?? '',
      awayFormation: json['away_formation'] ?? '',
      totalHomePlayers: json['total_home_players'] ?? 0,
      totalAwayPlayers: json['total_away_players'] ?? 0,
      homeStartingCount: json['home_starting_count'] ?? 0,
      awayStartingCount: json['away_starting_count'] ?? 0,
      homeSubsCount: json['home_subs_count'] ?? 0,
      awaySubsCount: json['away_subs_count'] ?? 0,
    );
  }
}
