import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
class Player with _$Player {
  const factory Player({
    required String id,
    required String name,
    required String nationality,
    required DateTime dateOfBirth,
    required List<String> positions,
    required String primaryPosition,
    required List<ClubHistory> clubs,
    required List<String> leagues,
    required String teammatesHash,
    Map<String, dynamic>? meta,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}

extension PlayerExtensions on Player {
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  String get position => primaryPosition;

  String get currentClub {
    if (clubs.isEmpty) return 'Unknown';

    // Find the current club (where 'to' is null or in the future)
    final currentClubHistory = clubs
        .where((club) => club.to == null || club.to!.isAfter(DateTime.now()))
        .toList();

    if (currentClubHistory.isEmpty) {
      // If no current club, return the most recent one
      final sortedClubs = clubs.toList()
        ..sort((a, b) => b.from.compareTo(a.from));
      return sortedClubs.first.clubId;
    }

    return currentClubHistory.first.clubId;
  }
}

@freezed
class ClubHistory with _$ClubHistory {
  const factory ClubHistory({
    required String clubId,
    required DateTime from,
    DateTime? to,
    @Default(false) bool isLoan,
  }) = _ClubHistory;

  factory ClubHistory.fromJson(Map<String, dynamic> json) =>
      _$ClubHistoryFromJson(json);
}

@freezed
class Club with _$Club {
  const factory Club({
    required String id,
    required String name,
    required String leagueId,
    required String country,
    @Default([]) List<String> rivals,
  }) = _Club;

  factory Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);
}

@freezed
class Match with _$Match {
  const factory Match({
    required String id,
    required DateTime date,
    required String competition,
    required String homeId,
    required String awayId,
    @Default([]) List<MatchEvent> events,
  }) = _Match;

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
}

@freezed
class MatchEvent with _$MatchEvent {
  const factory MatchEvent({
    required int minute,
    required String playerId,
    required String type,
    Map<String, dynamic>? details,
  }) = _MatchEvent;

  factory MatchEvent.fromJson(Map<String, dynamic> json) =>
      _$MatchEventFromJson(json);
}
