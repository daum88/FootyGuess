import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

@freezed
class GameState with _$GameState {
  const factory GameState({
    required String mode,
    required String day,
    required List<String> attempts,
    required int points,
    required bool isCompleted,
    required DateTime startedAt,
    DateTime? completedAt,
    @Default([]) List<String> hintsUsed,
    Map<String, dynamic>? gameData,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String uid,
    required String displayName,
    String? photoURL,
    required DateTime createdAt,
    @Default(0) int streakCount,
    @Default({}) Map<String, dynamic> preferences,
    String? favoriteClub,
    @Default(0) int totalPoints,
    @Default({}) Map<String, int> gameStats,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

@freezed
class ScoreEntry with _$ScoreEntry {
  const factory ScoreEntry({
    required String uid,
    required String mode,
    required String day,
    required int attempts,
    required int points,
    required int timeMs,
    required DateTime createdAt,
    required String receipt,
    required String version,
  }) = _ScoreEntry;

  factory ScoreEntry.fromJson(Map<String, dynamic> json) =>
      _$ScoreEntryFromJson(json);
}

@freezed
class LeaderboardEntry with _$LeaderboardEntry {
  const factory LeaderboardEntry({
    required String uid,
    required String displayName,
    String? photoURL,
    required int points,
    required int rank,
    required DateTime createdAt,
    Map<String, dynamic>? metadata,
  }) = _LeaderboardEntry;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryFromJson(json);
}

@freezed
class DailyPuzzle with _$DailyPuzzle {
  const factory DailyPuzzle({
    required String mode,
    required String day,
    required String puzzleId,
    required Map<String, dynamic> payload,
    required String metaHash,
    required String version,
    required DateTime createdAt,
  }) = _DailyPuzzle;

  factory DailyPuzzle.fromJson(Map<String, dynamic> json) =>
      _$DailyPuzzleFromJson(json);
}

@freezed
class HintData with _$HintData {
  const factory HintData({
    required String hintType,
    required int cost,
    required String hintText,
    required Map<String, dynamic> payload,
    double? specificityScore,
  }) = _HintData;

  factory HintData.fromJson(Map<String, dynamic> json) =>
      _$HintDataFromJson(json);
}
