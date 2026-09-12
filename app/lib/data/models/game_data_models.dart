/// Canonical game data models matching the JSON produced by data_pipeline.
///
/// Plain Dart classes (no codegen) so they never drift from the schema.
library;

/// A player with attributes and career history.
class GamePlayer {
  final String id;
  final String name;
  final List<String> alternateNames;
  final String nationality;
  final DateTime? dateOfBirth;
  final List<String> positions;
  final String primaryPosition;
  final String currentClub;
  final String currentLeague;
  final List<CareerEntry> career;
  final int appearances;
  final String? photo;

  const GamePlayer({
    required this.id,
    required this.name,
    this.alternateNames = const [],
    this.nationality = '',
    this.dateOfBirth,
    this.positions = const [],
    this.primaryPosition = '',
    this.currentClub = '',
    this.currentLeague = '',
    this.career = const [],
    this.appearances = 0,
    this.photo,
  });

  factory GamePlayer.fromJson(Map<String, dynamic> json) {
    return GamePlayer(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      alternateNames:
          List<String>.from(json['alternateNames'] as List? ?? const []),
      nationality: json['nationality'] as String? ?? '',
      dateOfBirth: _parseDate(json['dateOfBirth']),
      positions: List<String>.from(json['positions'] as List? ?? const []),
      primaryPosition: json['primaryPosition'] as String? ?? '',
      currentClub: json['currentClub'] as String? ?? '',
      currentLeague: json['currentLeague'] as String? ?? '',
      career: (json['career'] as List? ?? const [])
          .map((e) => CareerEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      appearances: (json['appearances'] as num?)?.toInt() ?? 0,
      photo: json['photo'] as String?,
    );
  }

  int? get age {
    final dob = dateOfBirth;
    if (dob == null) return null;
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  bool get hasKnownAge => age != null && dateOfBirth != null;

  /// Players who make good "Guess the Player" targets: known age + position + club.
  bool get isGuessable =>
      name.isNotEmpty &&
      hasKnownAge &&
      positions.isNotEmpty &&
      currentClub.isNotEmpty;
}

class CareerEntry {
  final String club;
  final String league;
  final int? startYear;
  final int? endYear;
  final bool isLoan;

  const CareerEntry({
    required this.club,
    this.league = '',
    this.startYear,
    this.endYear,
    this.isLoan = false,
  });

  factory CareerEntry.fromJson(Map<String, dynamic> json) {
    return CareerEntry(
      club: json['club'] as String? ?? '',
      league: json['league'] as String? ?? '',
      startYear: (json['startYear'] as num?)?.toInt(),
      endYear: (json['endYear'] as num?)?.toInt(),
      isLoan: json['isLoan'] as bool? ?? false,
    );
  }
}

/// A historic match with optional scorer list.
class GameMatch {
  final String id;
  final String competition;
  final String season;
  final String date;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final List<Scorer> scorers;

  const GameMatch({
    required this.id,
    this.competition = '',
    this.season = '',
    this.date = '',
    this.homeTeam = '',
    this.awayTeam = '',
    this.homeScore = 0,
    this.awayScore = 0,
    this.scorers = const [],
  });

  factory GameMatch.fromJson(Map<String, dynamic> json) {
    return GameMatch(
      id: json['id'] as String? ?? '',
      competition: json['competition'] as String? ?? '',
      season: json['season'] as String? ?? '',
      date: json['date'] as String? ?? '',
      homeTeam: json['homeTeam'] as String? ?? '',
      awayTeam: json['awayTeam'] as String? ?? '',
      homeScore: (json['homeScore'] as num?)?.toInt() ?? 0,
      awayScore: (json['awayScore'] as num?)?.toInt() ?? 0,
      scorers: (json['scorers'] as List? ?? const [])
          .map((e) => Scorer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  bool get hasScorers => scorers.isNotEmpty;
}

class Scorer {
  final String player;
  final String? team;
  final int? minute;
  final int goals;

  const Scorer({required this.player, this.team, this.minute, this.goals = 1});

  factory Scorer.fromJson(Map<String, dynamic> json) {
    return Scorer(
      player: json['player'] as String? ?? '',
      team: json['team'] as String?,
      minute: (json['minute'] as num?)?.toInt(),
      goals: (json['goals'] as num?)?.toInt() ?? 1,
    );
  }
}

/// A real team lineup with formation (for Missing XI).
class TeamLineup {
  final int matchId;
  final String teamName;
  final String opponent;
  final String competition;
  final String season;
  final String date;
  final String formation;
  final List<LineupPlayer> players;

  const TeamLineup({
    required this.matchId,
    this.teamName = '',
    this.opponent = '',
    this.competition = '',
    this.season = '',
    this.date = '',
    this.formation = '',
    this.players = const [],
  });

  factory TeamLineup.fromJson(Map<String, dynamic> json) {
    return TeamLineup(
      matchId: (json['matchId'] as num?)?.toInt() ?? 0,
      teamName: json['teamName'] as String? ?? '',
      opponent: json['opponent'] as String? ?? '',
      competition: json['competition'] as String? ?? '',
      season: json['season'] as String? ?? '',
      date: json['date'] as String? ?? '',
      formation: json['formation'] as String? ?? '',
      players: (json['players'] as List? ?? const [])
          .map((e) => LineupPlayer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class LineupPlayer {
  final String name;
  final String position;
  final int? number;
  final String nationality;

  const LineupPlayer({
    required this.name,
    this.position = '',
    this.number,
    this.nationality = '',
  });

  factory LineupPlayer.fromJson(Map<String, dynamic> json) {
    return LineupPlayer(
      name: json['name'] as String? ?? '',
      position: json['position'] as String? ?? '',
      number: (json['number'] as num?)?.toInt(),
      nationality: json['nationality'] as String? ?? '',
    );
  }
}

/// A football club.
class GameClub {
  final String id;
  final String name;
  final String league;
  final String country;
  final String stadium;
  final int? founded;
  final String badge;

  const GameClub({
    required this.id,
    this.name = '',
    this.league = '',
    this.country = '',
    this.stadium = '',
    this.founded,
    this.badge = '',
  });

  factory GameClub.fromJson(Map<String, dynamic> json) {
    return GameClub(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      league: json['league'] as String? ?? '',
      country: json['country'] as String? ?? '',
      stadium: json['stadium'] as String? ?? '',
      founded: (json['founded'] as num?)?.toInt(),
      badge: json['badge'] as String? ?? '',
    );
  }
}

/// A Tenable list category (top-10 style).
class TenableCategory {
  final String id;
  final String question;
  final String description;
  final List<TenableAnswer> answers;

  const TenableCategory({
    required this.id,
    this.question = '',
    this.description = '',
    this.answers = const [],
  });

  factory TenableCategory.fromJson(Map<String, dynamic> json) {
    return TenableCategory(
      id: json['id'] as String? ?? '',
      question: json['question'] as String? ?? '',
      description: json['description'] as String? ?? '',
      answers: (json['answers'] as List? ?? const [])
          .map((e) => TenableAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TenableAnswer {
  final String answer;
  final int value;
  final int position;

  const TenableAnswer({
    required this.answer,
    this.value = 0,
    this.position = 0,
  });

  factory TenableAnswer.fromJson(Map<String, dynamic> json) {
    return TenableAnswer(
      answer: json['answer'] as String? ?? '',
      value: (json['value'] as num?)?.toInt() ?? 0,
      position: (json['position'] as num?)?.toInt() ?? 0,
    );
  }
}

DateTime? _parseDate(dynamic value) {
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}
